//
//  ViewController.swift
//  WishList
//
//  Created by Harendra Singh on 04/01/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import AddressBook

struct SharedRechabilityInstance {
    static var instance = SharedRechabilityInstance()
    var reachability: NetworkReachability?
}
// ViewController
//started autolayout
class ViewController: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            SharedRechabilityInstance.instance.reachability = try NetworkReachability(hostname: "www.google.com")
            NotificationCenter.default.addObserver(self, selector: #selector(networkStatusManager(_:)), name: NSNotification.Name(rawValue: Notification.flagsChanged), object: SharedRechabilityInstance.instance.reachability)
            do {
                try SharedRechabilityInstance.instance.reachability?.start()
                updateInterfaceWith(SharedRechabilityInstance.instance.reachability?.networkStatus)
            } catch let error as ReachabilityError {
                print(error)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        lblVersion.text = "Version: \(nsObject as! String)"
        
        if WLUserSettings.getAuthToken() != nil {
        
            let isProfileComplete = UserDefaults.standard.bool(forKey: "profileComplete")
            let isContactUploaded = UserDefaults.standard.bool(forKey: "contactUploaded")
            let isMyBusinessSelected = UserDefaults.standard.bool(forKey: "businessSelected")
            let isNetworkSelected = UserDefaults.standard.bool(forKey: "networkSelected")
            let isFBLoginAttempt = UserDefaults.standard.bool(forKey: "floginattempt")
            print(isFBLoginAttempt)
            
            if !isProfileComplete {
                
                let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
                if isFBLoginAttempt {
                    
                    SignUpView.isLoginWithFB = true
                } else {
                    SignUpView.isLoginWithFB = false
                }
                self.navigationController?.pushViewController(SignUpView, animated: true)
                
            } else if !isContactUploaded {
                
                let authorizationStatus = ABAddressBookGetAuthorizationStatus()
                
                switch authorizationStatus {
                case .denied, .restricted:
                    
                    print("Denied")
                    
                    let syncInfoView = self.storyboard?.instantiateViewController(withIdentifier: "SyncInfoView") as! SyncInfoViewController
                    self.navigationController?.pushViewController(syncInfoView, animated: true)
                    
                case .authorized:
                    
                    let UploadContactsView = self.storyboard?.instantiateViewController(withIdentifier: "UploadContacts") as! HomeViewController
                    self.navigationController?.pushViewController(UploadContactsView, animated: true)
                    
                case .notDetermined:
                    
                    let UploadContactsView = self.storyboard?.instantiateViewController(withIdentifier: "UploadContacts") as! HomeViewController
                    self.navigationController?.pushViewController(UploadContactsView, animated: true)
                }
                
                
                
            } else if !isMyBusinessSelected {
                
                let BusinessInterestView = self.storyboard?.instantiateViewController(withIdentifier: "SetUpBusinessView") as! SetUpBusinessViewController
                self.navigationController?.pushViewController(BusinessInterestView, animated: true)
                
            } else if !isNetworkSelected {
                
                let chooseNetworkView = self.storyboard?.instantiateViewController(withIdentifier: "ChooseNetworkViewController") as! ChooseNetworkViewController
                self.navigationController?.pushViewController(chooseNetworkView, animated: true)
            } else {
                let dashboardView = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
                self.navigationController?.pushViewController(dashboardView, animated: true)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    func updateInterfaceWith(_ networkStatus:  NetworkStatus?) {
        
        guard let networkStatus = networkStatus else { return }
        switch networkStatus {
        case .unreachable:
            
            let alert = UIAlertController(title: "Alert", message: "The internet connection seems to be down. Please check!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        default: break
        }
    }
    
    @objc func networkStatusManager(_ notification: Foundation.Notification) {
        
        guard let networkReachability = notification.object as? NetworkReachability else { return }
        updateInterfaceWith(networkReachability.networkStatus)
        print("--> NetworkReachability Summary")
        print("NetworkStatus:", networkReachability.networkStatus)
        print("HostName:", networkReachability.hostname)
        print("Reachable:", networkReachability.isReachable)
        print("Wifi:", networkReachability.isReachableViaWiFi)
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
    }
}
