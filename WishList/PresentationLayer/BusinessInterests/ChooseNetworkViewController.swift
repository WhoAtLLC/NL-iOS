//
//  ChooseNetworkViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/11/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel
//import TSMessages

class ChooseNetworkViewController: UIViewController, TSMessageViewProtocol {

    @IBOutlet weak var lblOpenNetworking: UILabel!
    @IBOutlet weak var lblPrivateNetworking: UILabel!
   
    @IBOutlet weak var switchValue: UISwitch!
    
    @IBOutlet weak var imgViewIcon: UIImageView!
    
    @IBOutlet weak var lblOpenDescription: UILabel!
    @IBOutlet weak var lblOpenTitle: UILabel!
    
    @IBOutlet weak var lblPrivateTitle: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnBack: UIView!
    @IBOutlet weak var yellowBar: UIView!
    
    var selectedNetwork = "open"
    var fromMoreScreen = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BlueBackGround")!)
        self.btnSelect.layer.masksToBounds = true
        self.btnSelect.layer.cornerRadius = 20.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        if fromMoreScreen {
            
            btnSelect.setY(420)
            lblDescription.setY(470)
            btnBack.isHidden = false
            yellowBar.isHidden = true
            
            if rechability.isConnectedToNetwork() {
                
                loader.showActivityIndicator(self.view)
                
                let chooseNetworkModel = WLChooseNetwork()
                chooseNetworkModel.fromMoreScreen = true
                chooseNetworkModel.chooseNetwork({(Void, AnyObject) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    print(AnyObject)
                    if let response = AnyObject as? [String: AnyObject] {
                        if let status = response["network_status"] as? String {
                            
                            if status == "open" {
                                
                                self.switchValue.setOn(false, animated: true)
                            } else {
                                self.switchValue.setOn(true, animated: true)
                            }
                        }
                    }
                    
                    }, errorCallback: {(Void, NSError) -> Void in
                        
                        print(NSError)
                        loader.hideActivityIndicator(self.view)
                })
            } else {
                
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            }
        }
    }
   
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        let  alert = UIAlertController(title: "Niceleads", message: "You made change, Do you want to save it ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: okHandler))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: cancelHandler))
        self.present(alert, animated: true, completion: nil)
        
    //  self.navigationController?.popViewController(animated: true)
    }
    
    func okHandler(alert: UIAlertAction)
    {
        btnSelectTapped()
    }
    
    func cancelHandler(alert: UIAlertAction)
    {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions 
    
    @IBAction func switchValueChanges(_ sender: AnyObject) {
        
        if(self.switchValue.isOn){
            
            selectedNetwork = "private"
            self.lblPrivateTitle.isHidden = false
            self.lblOpenTitle.isHidden = true
            self.lblOpenDescription.text = "Limits your search results but is your most trusted option as you will at least have common contacts with the other member you're networking with."
            self.imgViewIcon.image = UIImage(named: "private_networking.png")
            self.lblPrivateNetworking.textColor = UIColor.white
            self.btnSelect.setTitle("Select", for: UIControl.State())
            self.lblDescription.text = "Select this for your most trusted option. Can be modified any time in My Account."
        }
        else {
            
            selectedNetwork = "open"
            self.lblPrivateTitle.isHidden = true
            self.lblOpenTitle.isHidden = false
            self.lblOpenDescription.text = "Offers the greatest number of networking opportunities, but you might not know anyone in common with the contact owner."
            self.imgViewIcon.image = UIImage(named: "open_networking.png")
            self.lblOpenNetworking.textColor = UIColor.white
            self.btnSelect.setTitle("Select", for: UIControl.State())
            self.lblDescription.text = "Select this for the most networking opportunities. Can be modified any time in My Account."
        }
    }
    
    @IBAction func btnSelectTouchUpInside(_ sender: AnyObject) {
        
      btnSelectTapped()
    }
    
    func btnSelectTapped()
    {
        if btnSelect.currentTitle == "Select" {
            
            if !rechability.isConnectedToNetwork() {
                
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                return
            }
            
            loader.showActivityIndicator(self.view)
            
            let chooseNetworkModel = WLChooseNetwork()
            chooseNetworkModel.fromMoreScreen = false
            chooseNetworkModel.selectedNetwork = selectedNetwork
            chooseNetworkModel.chooseNetwork({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                if let response = AnyObject as? [String: AnyObject] {
                    if let _ = response["network_status"] as? String {
                        
                        if self.fromMoreScreen {
                            
                            Mixpanel.sharedInstance()?.track("Network Changed", properties:["selectedNetwork": self.selectedNetwork])
                            self.navigationController?.popViewController(animated: true)
                            
                        } else {
                            
                            Mixpanel.sharedInstance()?.track("Choose Network", properties:["selectedNetwork": self.selectedNetwork])
                            UserDefaults.standard.set(true, forKey: "networkSelected")
                            self.checkStatus()
                            
                        }
                    }
                }
                
            }, errorCallback: {(Void, NSError) -> Void in
                
                print(NSError)
                loader.hideActivityIndicator(self.view)
            })
        }

    }
    
    func checkStatus() {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        loader.showActivityIndicator(self.view)
        
        let emailStatus = WLCheckEmailStatus()
        emailStatus.checkEmailStatus({(Void, AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            print(AnyObject)
            if let response = AnyObject as? [String: AnyObject] {
                
                if let result = response["result"] as? Bool {
                    
                    if result {
                        
                        let dashboardView = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
                        self.navigationController?.pushViewController(dashboardView, animated: true)
                        
                    } else {
                        
                        let resendEmailView = self.storyboard?.instantiateViewController(withIdentifier: "ResendEmailViewController") as! ResendEmailViewController
                        self.navigationController?.pushViewController(resendEmailView, animated: true)
                    }
                }
            }
            
            }, {(Void, NSError) -> Void in
        
                loader.hideActivityIndicator(self.view)
                let resendEmailView = self.storyboard?.instantiateViewController(withIdentifier: "ResendEmailViewController") as! ResendEmailViewController
                self.navigationController?.pushViewController(resendEmailView, animated: true)
        })
    }
}
