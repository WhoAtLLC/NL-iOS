//
//  ManageGroupsViewController.swift
//  WishList
//
//  Created by Dharmesh on 26/08/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import MessageUI


class ManageGroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tblGroups: UITableView!
    @IBOutlet weak var groupDetailPopUp: UIView!
    @IBOutlet weak var groupDetailSubView: UIView!
    @IBOutlet weak var btnLeaveGroup: UIButton!
    @IBOutlet weak var lblSelectedGroupTitle: UILabel!
    @IBOutlet weak var lblCValidDate: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblGroupOwner: UILabel!
    @IBOutlet weak var lblOwnerHeadline: UILabel!
    @IBOutlet weak var lblOwnerCompany: UILabel!
    @IBOutlet weak var noGroupView: UIView!
    @IBOutlet weak var grpDtlPopUpTop: NSLayoutConstraint!
    @IBOutlet weak var noGroupParent: UIView!
    
    var groupObjects = [GroupObject]()
    var selectedGroupSlug = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblGroups.separatorStyle = .none
        lblDescription.isUserInteractionEnabled = false
        
        self.grpDtlPopUpTop.constant = 900
        groupDetailPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        groupDetailSubView.layer.cornerRadius = 5

        let underlineAttributedString = NSAttributedString(string: "Leave this Group", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineStyle.rawValue): NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.red])
        btnLeaveGroup.setAttributedTitle(underlineAttributedString, for: UIControl.State())
        getGroups()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupObjects.count
    }
    
    @IBAction func btnCanclePopTapped(_ sender: AnyObject) {
        
       // self.tabBarController?.tabBar.layer.zPosition = 0
          self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                self.grpDtlPopUpTop.constant = 900
                
                
            }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblGroups.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ManageGroupsTableViewCell
        cell.selectionStyle = .none
        let groupObject = groupObjects[indexPath.row]
        cell.lblGroupName.text = groupObject.name
        cell.lblGroupMemberCount.text = "\(groupObject.count!)"
        
        return cell
    }
    
    
    @IBAction func btnContactTapped(_ sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["sales@whoat.io"])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnLearnMoreTapped(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: "http://wishlist.whoat.io/for-organizers.html")!)
    }
    
    var selectedIndex = -1
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groupObject = groupObjects[indexPath.row]
        self.lblSelectedGroupTitle.text = groupObject.name
        self.lblDescription.text = groupObject.description
        
        if groupObject.expiration_date?.characters.count > 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: groupObject.expiration_date!)
            
            dateFormatter.dateFormat = "MMM"
            let monthName = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "dd"
            
            let day = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "yyyy"
            
            let year = dateFormatter.string(from: date!)
            
            let suffix = daySuffix(date!)
            
            self.lblCValidDate.text = "valid until \(monthName). \(day)\(suffix) \(year)"
        }
        
        self.lblGroupOwner.text = groupObject.owner_name
        if groupObject.owner_company?.count > 0 {
            
            self.lblOwnerCompany.text = groupObject.owner_company![0]
        }
        if groupObject.owner_title?.count > 0 {
            
            self.lblOwnerHeadline.text = groupObject.owner_title![0]
        }
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
          self.tabBarController?.tabBar.isHidden = true
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                
                self.grpDtlPopUpTop.constant = 0
                
            }, completion: nil)
        
        selectedGroupSlug = groupObject.slug!
    }
    
    func daySuffix(_ date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = (calendar as NSCalendar).component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    @IBAction func btnLeaveThisGroupTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
          self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            
                self.grpDtlPopUpTop.constant = 900
                
            }, completion: { action in
                
                let alertController = UIAlertController(title: "", message: "Are you sure you want to leave the group?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                    
                    
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                    
                    
                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
            }
        
        })
    }
    
    @IBAction func btnContactOrganizerTapped(_ sender: AnyObject) {
        

        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            let contactGroupOrganizer = WLContactGroupOrganizer()
            contactGroupOrganizer.groupSlug = selectedGroupSlug
            contactGroupOrganizer.contactGroupOrganizer({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                if let response = AnyObject as? [String: AnyObject] {
                    
                    if let faction = response["faction"] as? [String] {
                        
                        if let result = faction[0] as? String {
                            
                            if result == "ok" {
                                
                               // self.tabBarController?.tabBar.layer.zPosition = 0
                                  self.tabBarController?.tabBar.isHidden = false
                                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                                    
                                    self.grpDtlPopUpTop.constant = 900
                                    
                                    }, completion: { action in
                                        
                                        let alert = UIAlertController(title: "Alert", message: "Email successfully sent.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        
                                })
                            }
                        }
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    print(NSError)
            })
            
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
        
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func getGroups() {
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            let groups = WLGroupList()
            groups.getGroupList({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                if let response = AnyObject as? [String: AnyObject] {
                    
                    if let faction = response["faction"] as? [[String: AnyObject]] {
                        
                        for group in faction {
                            
                            let name = group["name"] as? String ?? ""
                            let slug = group["slug"] as? String ?? ""
                            let description = group["description"] as? String ?? ""
                            let expiration_date = group["expiration_date"] as? String ?? ""
                            let count = group["count"] as? Int ?? 0
                            let owner_name = group["owner_name"] as? String ?? ""
                            let owner_company = group["owner_company"] as? [String] ?? [""]
                            let owner_title = group["owner_title"] as? [String] ?? [""]
                            
                            let groupObj = GroupObject(name: name, slug: slug, description: description, expiration_date: expiration_date, count: count, owner_name: owner_name, owner_company: owner_company, owner_title: owner_title)
                            self.groupObjects.append(groupObj)
                        }
                        
                        if self.groupObjects.count > 0 {
                            self.tblGroups.isHidden = false
                            self.noGroupView.isHidden = true
                            self.noGroupParent.isHidden = true
                        } else {
                            
                            self.tblGroups.isHidden = true
                            self.noGroupView.isHidden = false
                             self.noGroupParent.isHidden = false
                        }
                        
                        self.tblGroups.reloadData()
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
}
