//
//  ResendEmailViewController.swift
//  WishList
//
//  Created by Dharmesh on 23/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import MessageUI

class ResendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var lblEmailSentTo: UILabel!
    
    var commingFromDashboard = false
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnResend.layer.cornerRadius = 20.0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ResendEmailViewController.checkEmailStatus), userInfo: nil, repeats: true)
        if let userEmail = UserDefaults.standard.object(forKey: "userEmail") as? String {
            
            lblEmailSentTo.text = "A verification email was sent to: \(userEmail)"
        }
        
        let lbltxt = "If you have a yucky IT policy and can’t receive the email, please contact support@whoat.io."
        let attributedString = NSMutableAttributedString(string: lbltxt)
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineStyle.rawValue): 1], range: NSRange(location: 74, length: 17))
        lblContact.attributedText = attributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if commingFromDashboard {
            
            lblContact.setY(470)
            btnSupport.setY(482)
        }
    }
    
    @objc func checkEmailStatus() {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        let emailStatus = WLCheckEmailStatus()
        emailStatus.checkEmailStatus({(Void,  AnyObject) -> Void in
            
            if let response =  AnyObject as? [String: AnyObject] {
                
                if let result = response["result"] as? Bool {
                    
                    if result {
                        
                        self.timer?.invalidate()
                        
                        if self.commingFromDashboard {
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        } else {
                            
                            let dashboardView = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
                            self.navigationController?.pushViewController(dashboardView, animated: true)
                        }
                        
                        
                    }
                }
            }
            
        }, {(Void, NSError) -> Void in
                
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        timer?.invalidate()
    }

    @IBAction func btnResendTapped(_ sender: AnyObject) {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        loader.showActivityIndicator(self.view)
        let resendEmailVerification = WLResendEmailVerification()
        resendEmailVerification.resendEmailVerification({(Void,  AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            if let response =  AnyObject as? [String: AnyObject] {
                
                if let result = response["result"] as? Bool {
                    
                    if result {
                        
                        let alert = UIAlertController(title: "Alert", message: "Email sent successfully! Please check your email.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
        
        })
    }
    
    @IBAction func btnGoToDashBoardTapped(_ sender: AnyObject) {
        
        
    }
    
    @IBAction func btnSupprtTapped(_ sender: AnyObject) {
        
        let emailTitle = "Feedback"
        let messageBody = "Bug report?"
        let toRecipents = ["support@whoat.io"]
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(error?.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
