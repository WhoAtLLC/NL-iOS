//
//  InviteViewController.swift
//  WishList
//
//  Created by Dharmesh on 06/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import MessageUI
import TwitterKit
import FacebookShare

class InviteViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTextTapped(_ sender: AnyObject) {
        
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Save time networking for new opportunities. Join me on WhoAt's WishList today https://itunes.apple.com/us/app/whoat-wishlist/id1123737064?mt=8"
        messageVC.messageComposeDelegate = self
        self.present(messageVC, animated: false, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setSubject("Join me on WishList to generate new leads.")
        mailComposerVC.setMessageBody("Save time networking for new opportunities. Join me on WhoAt's WishList today https://itunes.apple.com/us/app/whoat-wishlist/id1123737064?mt=8", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnEmailTapped(_ sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func btnFacebook(_ sender: Any) {
        let linkShare = LinkShareContent(url: URL(string: "https://itunes.apple.com/us/app/whoat-wishlist/id1123737064?mt=8")!, quote: "Save time networking for new opportunities. Join me on WhoAt's WishList today.")
        let shareDialog = ShareDialog(content: linkShare)
        shareDialog.mode = .browser
        shareDialog.completion = {result in
            print(result)
        }
        do{
            try shareDialog.show()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btnTwitter(_ sender: Any) {
        let composer = TWTRComposer()
        composer.setURL(URL(string: "https://itunes.apple.com/us/app/whoat-wishlist/id1123737064?mt=8")!)
        composer.setText("Save time networking for new opportunities. Join me on WhoAt's WishList today.")
        
        composer.show(from: self) { (result) in
            if result == TWTRComposerResult.cancelled
            {
                print("Tweet cancelled")
            }
            else
            {
                print(result)
                print("Tweet successful")
            }
        }
    }
    
}
