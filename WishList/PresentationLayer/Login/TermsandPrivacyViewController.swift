//
//  TermsandPrivacyViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/7/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
//import TSMessages

class TermsandPrivacyViewController: UIViewController, TSMessageViewProtocol {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var strTitle : String?
    var strURL : String?
    
    var commingFromMyAccount = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        
        if commingFromMyAccount {
            webView.frame.size.height = 380
        }
        
        if strTitle == "Terms & Conditions" {
            
            if !rechability.isConnectedToNetwork() {
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                return
            }
            
            loader.showActivityIndicator(self.view)
            let getTerms = WLGetTerms()
            getTerms.getTermsDetail({(Void,AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                if let response = AnyObject as? [String:AnyObject] {
                    if let content = response["content"] as? [String: AnyObject] {
                        
                        let label = content["label"] as! String
                        let dataContent = content["content"] as! String
                        
                        self.lblTitle.text = label
                        self.webView.loadHTMLString(dataContent, baseURL: nil)
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
            
                    loader.hideActivityIndicator(self.view)
                    print(NSError)
            })
        } else {
            
            if !rechability.isConnectedToNetwork() {
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                return
            }
            
            loader.showActivityIndicator(self.view)
            let getTerms = WLGetTerms()
            
            getTerms.isPrivacyPolicy = true
            getTerms.getTermsDetail({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                if let response = AnyObject as? [String: AnyObject] {
                    
                    if let content = response["content"] as? [String: AnyObject] {
                        
                        let label = content["label"] as! String
                        let dataContent = content["content"] as! String
                        
                        self.lblTitle.text = label
                        self.webView.loadHTMLString(dataContent, baseURL: nil)
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    print(NSError)
            })
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
    }

    
    // MARK: - Button Actions
    

    @IBAction func btnBackTouchUpInside(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    

}
