//
//  MoreViewController.swift
//  WishList
//
//  Created by Dharmesh on 02/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import MessageUI
import Foundation
import Mixpanel

class MoreViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var tableViewMore: UITableView!
    
    let section = ["Get More Leads", "Account Settings", "We Love Hearing From You","More Settings"]
    
    let items = [["New Lead Sheet Frequency", "Invite Your Sales Colleagues", "Manage Groups", "Re Sync Contacts"], ["My WishList", "Select Public or Private Network", "Tutorial"], ["Suggest a feature", "Support", "Follow us on Twitter"],["Contact Us", "Privacy Policy","Terms of Service", "Sign Out"]]
    
    let itemImages = [["listMail", "InviteColleagues", "ManageGroupsIcon", "ReSynicon"], ["MyBusIntIcon", "BusNetSetIcon", "CoachPoints"], ["Feature", "Support", "FollowOnTwitter"], ["contact_us", "privacy_policy", "terms_of_service", "sign_out"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMore.delegate = self
        tableViewMore.dataSource = self
        tableViewMore.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // UIApplication.sharedApplication().statusBarView?.backgroundColor = UIColor(netHex: 0x498CE7)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
        
    }
    
    @objc func switchValueDidChange(_ sender:UISwitch!)
    {
        if (sender.isOn == true){
            
            UserDefaults.standard.set(false, forKey: "firstTime")
            UserDefaults.standard.set(false, forKey: "NotificationFirstTime")
            UserDefaults.standard.set(false, forKey: "firstTimeForSendRequest")
            UserDefaults.standard.set(false, forKey: "firstTimeCompanySubIntro")
            UserDefaults.standard.set(false, forKey: "firstTimeCompanyIntro")
            UserDefaults.standard.set(false, forKey: "MyBusinessIntroForFirstTime")
            UserDefaults.standard.set(false, forKey: "firstTimeMemberIntro")
            UserDefaults.standard.set(false, forKey: "selectCompaniesIntroForFirstTime")
            UserDefaults.standard.set(false, forKey: "shouldShowCoachMarks")
        }
        else{
            
            UserDefaults.standard.set(true, forKey: "firstTime")
            UserDefaults.standard.set(true, forKey: "NotificationFirstTime")
            UserDefaults.standard.set(true, forKey: "firstTimeForSendRequest")
            UserDefaults.standard.set(true, forKey: "firstTimeCompanySubIntro")
            UserDefaults.standard.set(true, forKey: "firstTimeCompanyIntro")
            UserDefaults.standard.set(true, forKey: "MyBusinessIntroForFirstTime")
            UserDefaults.standard.set(true, forKey: "firstTimeMemberIntro")
            UserDefaults.standard.set(true, forKey: "selectCompaniesIntroForFirstTime")
            UserDefaults.standard.set(true, forKey: "shouldShowCoachMarks")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController(_ email: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
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
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["support@whoat.io"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
}
extension MoreViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(netHex: 0xECECEC)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 25))
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: label.font.fontName, size: 12)
        label.text = self.section[section]
        label.textColor = UIColor(netHex: 0x333C4E)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewMore.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MoreTableViewCell
        cell?.labelName.text = self.items[indexPath.section][indexPath.row]
        cell?.imageIcon.image = UIImage(named: self.itemImages[indexPath.section][indexPath.row])
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        
        if indexPath.section == 1 && indexPath.row == 2 {
            cell?.cellSwitch.isHidden = false
            cell?.accessoryType = .none
            cell?.cellSwitch.isHidden = false
            cell?.cellSwitch.setOn(false, animated: false)
            cell?.cellSwitch.addTarget(self, action: #selector(MoreViewController.switchValueDidChange(_:)), for: .valueChanged)
        }else if indexPath.section == 3 && indexPath.row == 3 {
            cell?.accessoryType = .none
        }else {
            cell?.cellSwitch.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                
                let EmailNotificationView = self.storyboard?.instantiateViewController(withIdentifier: "EmailNotificationViewController") as! EmailNotificationViewController
                self.navigationController?.pushViewController(EmailNotificationView, animated: true)
            case 1:
                let InviteView = self.storyboard?.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
                self.navigationController?.pushViewController(InviteView, animated: true)
                
            case 2:
                
                let ManageGroupsView = self.storyboard?.instantiateViewController(withIdentifier: "ManageGroupsViewController") as! ManageGroupsViewController
                self.navigationController?.pushViewController(ManageGroupsView, animated: true)
                
            case 3:
                let ManageGroupsView = self.storyboard?.instantiateViewController(withIdentifier: "ReSyncContactVC") as! ReSyncContactVC
                self.navigationController?.pushViewController(ManageGroupsView, animated: true)

            default:
                break
            }
            
        case 1:
            
            switch indexPath.row {
            case 0:
                
                let BusinessInterestView = self.storyboard?.instantiateViewController(withIdentifier: "SetUpBusinessView") as! SetUpBusinessViewController
                BusinessInterestView.commingFromMoreForMyBusiness = true
                self.navigationController?.pushViewController(BusinessInterestView, animated: true)
                
            case 1:
                
                let selectNetworkView = self.storyboard?.instantiateViewController(withIdentifier: "ChooseNetworkViewController") as! ChooseNetworkViewController
                selectNetworkView.fromMoreScreen = true
                self.navigationController?.pushViewController(selectNetworkView, animated: true)
                
            default:
                break
            }
            
        case 2:
            
            switch indexPath.row {
            case 0:
                
                let mailComposeViewController = configuredMailComposeViewController("ceo@whoat.io")
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                
            case 1:
                
                let mailComposeViewController = configuredMailComposeViewController("support@whoat.io")
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                
            case 2:
                
                UIApplication.shared.openURL(URL(string: "https://twitter.com/WhoAt_io")!)
                
            default:
                break
            }
        case 3:
            
            switch indexPath.row {
                
            case 0:
                
                print("Contact us Button Pressed")
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                
            case 1:
                
                let TermsandPrivacyView = self.storyboard?.instantiateViewController(withIdentifier: "TermsandPrivacy") as! TermsandPrivacyViewController
                TermsandPrivacyView.strTitle = "Privacy Policy"
                TermsandPrivacyView.commingFromMyAccount = true
                self.navigationController?.pushViewController(TermsandPrivacyView, animated: true)
                
            case 2:
                
                let TermsandPrivacyView = self.storyboard?.instantiateViewController(withIdentifier: "TermsandPrivacy") as! TermsandPrivacyViewController
                TermsandPrivacyView.strTitle = "Terms & Conditions"
                TermsandPrivacyView.commingFromMyAccount = true
                self.navigationController?.pushViewController(TermsandPrivacyView, animated: true)
                
            case 3:
                
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                WLUserSettings.setAuthToken(nil)
                WLUserSettings.setUser("")
                WLUserSettings.setHandle("")
                WLUserSettings.setEmail(nil)
                
                Mixpanel.sharedInstance()?.track("User Logged Out", properties:nil)
                
                UserDefaults.standard.set(false, forKey: "profileComplete")
                UserDefaults.standard.set(false, forKey: "contactUploaded")
                UserDefaults.standard.set(false, forKey: "businessSelected")
                UserDefaults.standard.set(false, forKey: "networkSelected")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "RootNav") as! UINavigationController
                self.present(vc, animated: false, completion: nil)
                
            default:
                break
            }
        default:
            break
        }
    }
}
