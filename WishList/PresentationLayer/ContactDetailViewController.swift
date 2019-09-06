//
//  ContactDetailViewController.swift
//  WishList
//
//  Created by Dharmesh on 29/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit


class ContactDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tblContactConnections: UITableView!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var imgWishListMember: UIImageView!
    @IBOutlet weak var GroupNameView: UIView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var viewMenu: UIView!
    
    @IBOutlet weak var groupDetailPopUp: UIView!
    @IBOutlet weak var groupDtlPopUpTopCnstrnt: NSLayoutConstraint!
    
    @IBOutlet weak var groupDetailSubView: UIView!
    @IBOutlet weak var lblSelectedGroupTitle: UILabel!
    @IBOutlet weak var lblCValidDate: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblOwnerCompany: UILabel!
    @IBOutlet weak var lblGroupOwnerHeadline: UILabel!
    @IBOutlet weak var selectedUserImage: UIImageView!
    
    var selectedConnectionObject: ConnectionObject?
    var selectedGroup: GroupObject?
    var selectedCompany = ""
    var commingFromGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblContactConnections.separatorStyle = .none
        if selectedConnectionObject!.wishlistmember == false {
            imgWishListMember.isHidden = true
        }
        
        lblContactName.text = selectedConnectionObject!.connectionname
        lblPosition.text = selectedConnectionObject?.title
        
        //groupDetailPopUp.setY(568)
         self.groupDtlPopUpTopCnstrnt.constant = 1000
        groupDetailPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        groupDetailSubView.layer.cornerRadius = 5
        
        if commingFromGroup {
            GroupNameView.isHidden = false
            viewMenu.setY(189)
            tblContactConnections.setY(220)
            tblContactConnections.setHeight(297)
            lblGroupName.text = selectedGroup?.name
        } else {
            GroupNameView.isHidden = true
        }
    }
    
    @IBAction func showGroupDetail(_ sender: AnyObject) {
        
        self.lblSelectedGroupTitle.text = selectedGroup!.name
        self.lblDescription.text = selectedGroup!.description
        
        if selectedGroup!.expiration_date?.characters.count > 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: selectedGroup!.expiration_date!)
            
            dateFormatter.dateFormat = "MMM"
            let monthName = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "dd"
            
            let day = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "yyyy"
            
            let year = dateFormatter.string(from: date!)
            
            let suffix = daySuffix(date!)
            
            self.lblCValidDate.text = "valid until \(monthName). \(day)\(suffix) \(year)"
        }
        
        self.lblOwnerName.text = selectedGroup!.owner_name
        
        if selectedGroup?.owner_company?.count > 0 {
            self.lblOwnerCompany.text = selectedGroup!.owner_company![0]
        }
        
        if selectedGroup?.owner_title?.count > 0 {
            self.lblGroupOwnerHeadline.text = selectedGroup!.owner_title![0]
        }
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
         self.tabBarController?.tabBar.isHidden = true
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                
                //self.groupDetailPopUp.setY(0)
                self.groupDtlPopUpTopCnstrnt.constant = 0
                
            }, completion: nil)
    }
    
    @IBAction func btnContactOrganizerTapped(_ sender: AnyObject) {
        
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            let contactGroupOrganizer = WLContactGroupOrganizer()
            contactGroupOrganizer.groupSlug = selectedGroup!.slug!
            contactGroupOrganizer.contactGroupOrganizer({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                if let response = AnyObject as? [String: AnyObject] {
                    
                    if let faction = response["faction"] as? [String] {
                        
                        let result = faction[0] ?? ""
                        
                        if result == "ok" {
                            
                            //self.tabBarController?.tabBar.layer.zPosition = 0
                            self.tabBarController?.tabBar.isHidden = false
                            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                                
                                //self.groupDetailPopUp.setY(568)
                                 self.groupDtlPopUpTopCnstrnt.constant = 1000
                                }, completion: { action in
                                    
                                    let alert = UIAlertController(title: "Alert", message: "Email successfully sent.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                            })
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
    
    @IBAction func btnCanclePopTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.groupDetailPopUp.setY(568)
                 self.groupDtlPopUpTopCnstrnt.constant = 1000
            }, completion: nil)
    }
    
    @IBAction func btnGoBack(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedConnectionObject!.mutualContactObj!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblContactConnections.dequeueReusableCell(withIdentifier: "contactConnections", for: indexPath) as! ConnectionDetailTableViewCell
        cell.selectionStyle = .none
        
        let mutualContactObj = selectedConnectionObject?.mutualContactObj![indexPath.row]
        cell.lblConnectionTitle.text = mutualContactObj!.handle
        cell.lblMutualContactCounter.text = "\(mutualContactObj!.count!)"
        cell.lblSort_Bio.text = mutualContactObj!.short_bio
        
        if cell.lblSort_Bio.text!.characters.count == 0 {
            cell.lblConnectionTitle.frame = CGRect(x: 60, y: 26, width: cell.lblConnectionTitle.frame.size.width, height: cell.lblConnectionTitle.frame.size.height)
        } else {
            cell.lblConnectionTitle.frame = CGRect(x: 60, y: 8, width: cell.lblConnectionTitle.frame.size.width, height: cell.lblConnectionTitle.frame.size.height)
        }
        
        cell.imgUserPicture.image = UIImage(named: "CompanyPlaceHolderImage")
        
        cell.imgUserPicture.imageFromUrl(WLAppSettings.getBaseUrl() + "/api/v1/profile/\(mutualContactObj!.handle!)/avatar/")
        cell.imgUserPicture.makeThisRound
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let startRequestView = self.storyboard?.instantiateViewController(withIdentifier: "StartRequest") as! StartRequestViewController
        startRequestView.handle = selectedConnectionObject!.mutualContactObj![indexPath.row].handle!
        startRequestView.introducreName = lblContactName.text
        startRequestView.selectedCompany = selectedCompany
        startRequestView.selectedConnectionObject = selectedConnectionObject
        startRequestView.selectedMutualContact = selectedConnectionObject?.mutualContactObj![indexPath.row]
        if commingFromGroup {
            
            startRequestView.commingFromGroup = true
        }
        
        startRequestView.id = selectedConnectionObject!.id!
        self.navigationController?.pushViewController(startRequestView, animated: true)
    }
}
