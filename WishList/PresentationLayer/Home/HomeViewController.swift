//
//  HomeViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/8/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import AddressBook
import Mixpanel
//import TSMessages

class HomeViewController: UIViewController, TSMessageViewProtocol {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var viewMainPopUp: UIView!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var lblOk: UILabel!
    @IBOutlet weak var btnNoWishList: UIButton!
    @IBOutlet weak var btnContinue: UIButton!

    
    var contactStr: String!
    
    var addressBookRef: ABAddressBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewPopUp.isHidden = true
        
        
        self.viewMainPopUp.layer.cornerRadius = 5.0;
        self.viewMainPopUp.layer.masksToBounds = true;
        
        self.viewAlert.layer.cornerRadius = 6.0;
        self.viewAlert.layer.masksToBounds = true;
        self.viewAlert.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        self.viewAlert.layer.borderWidth = 1.0

        self.lblOk.layer.borderWidth = 2.0;
        self.lblOk.layer.borderColor = UIColor(red: 193.0/255.0, green: 199.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        
        let maskPath = UIBezierPath(roundedRect: self.lblOk.bounds, byRoundingCorners: UIRectCorner.bottomRight, cornerRadii: CGSize(width: 8.0, height: 8.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.lblOk.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.lineWidth = 2.0
        maskLayer.strokeColor = UIColor(red: 193.0/255.0, green: 199.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
        self.lblOk.layer.mask = maskLayer

    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .denied, .restricted:
            
            print("Denied")
            
            let syncInfoView = self.storyboard?.instantiateViewController(withIdentifier: "SyncInfoView") as! SyncInfoViewController
            self.navigationController?.pushViewController(syncInfoView, animated: true)
            
        case .authorized:
            
            print("Authorised")
            addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            
        case .notDetermined:
            
            print("Not Determined")
            addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
    }
    func prepareObjects1(_ dict : Dictionary<String, AnyObject> ) -> NSMutableDictionary
    {
        let dictParameters = NSMutableDictionary()
        for (key, value) in dict
        {
            dictParameters.setValue(value, forKey: key)
        }
        
        return dictParameters
    }
    
    @IBAction func btnUploadContactsTouchUpInside(_ sender: AnyObject) {
        
        self.viewPopUp.fadeIn()
    }

    @IBAction func btnContinueTouchUpInside(_ sender: AnyObject) {
        
        self.viewPopUp.fadeOut()
        
        if rechability.isConnectedToNetwork() {
            
            let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.syncContact()
            }
        } else {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
        
    }
    
    @IBAction func btnNoWishList(_ sender: AnyObject) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func syncContact() {
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .denied, .restricted:
            
            let syncInfoView = self.storyboard?.instantiateViewController(withIdentifier: "SyncInfoView") as! SyncInfoViewController
            self.navigationController?.pushViewController(syncInfoView, animated: true)
            
        case .authorized:
            
            Mixpanel.sharedInstance()?.track("Contact Uploaded", properties:nil)
            let BusinessInterestView = self.storyboard?.instantiateViewController(withIdentifier: "SetUpBusinessView") as! SetUpBusinessViewController
            self.navigationController?.pushViewController(BusinessInterestView, animated: true)
//            let BusinessInterestView = self.storyboard?.instantiateViewControllerWithIdentifier("BusinessInterest") as! BusinessInterestViewController
//            self.navigationController?.pushViewController(BusinessInterestView, animated: true)
            print("Authorized")
//            loader.showActivityIndicator(self.view)
            
            WLSyncWorker().startSyncWithSuccess({ (Void2, Any) -> Void in
                
                UserDefaults.standard.set(true, forKey: "contactUploaded")
//                loader.hideActivityIndicator(self.view)
                

                }, progressCallBack: { (Void2, progress) -> Void in
                    
                    let progre : (Int, Int) = progress
                    self.contactStr = "\(progre.0)"
                    
                }) { (Void2, NSError) -> Void in
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        print("error")
                        let UploadContactsView = self.storyboard?.instantiateViewController(withIdentifier: "UploadContacts") as! HomeViewController
                        self.navigationController?.pushViewController(UploadContactsView, animated: true)
//                        loader.hideActivityIndicator(self.view)
                    })
            }
        case .notDetermined:
            
            print("Not Determined")
            ABAddressBookRequestAccessWithCompletion(addressBookRef) {
                (granted: Bool, error: CFError!) in
                DispatchQueue.main.async {
                    if !granted {
                        
                        print("Just denied")
                        let syncInfoView = self.storyboard?.instantiateViewController(withIdentifier: "SyncInfoView") as! SyncInfoViewController
                        self.navigationController?.pushViewController(syncInfoView, animated: true)
                    } else {
                        
                        Mixpanel.sharedInstance()?.track("Contact Uploaded", properties:nil)
                        let BusinessInterestView = self.storyboard?.instantiateViewController(withIdentifier: "SetUpBusinessView") as! SetUpBusinessViewController
                        self.navigationController?.pushViewController(BusinessInterestView, animated: true)
//                        let BusinessInterestView = self.storyboard?.instantiateViewControllerWithIdentifier("BusinessInterest") as! BusinessInterestViewController
//                        self.navigationController?.pushViewController(BusinessInterestView, animated: true)
                        
//                        loader.showActivityIndicator(self.view)
                        
                        WLSyncWorker().startSyncWithSuccess({ (Void2, Any) -> Void in
                            
                            UserDefaults.standard.set(true, forKey: "contactUploaded")
//                            loader.hideActivityIndicator(self.view)
                            
                            
                            }, progressCallBack: { (Void2, progress) -> Void in
                                
                                let progre : (Int, Int) = progress
                                self.contactStr = "\(progre.0)"
                                
                            }) { (Void2, NSError) -> Void in
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    
                                    print("Error")
//                                    loader.hideActivityIndicator(self.view)
//                                    let BusinessInterestView = self.storyboard?.instantiateViewControllerWithIdentifier("BusinessInterest") as! BusinessInterestViewController
//                                    self.navigationController?.pushViewController(BusinessInterestView, animated: true)
                                })
                        }
                    }
                }
            }
        }
    }
}
