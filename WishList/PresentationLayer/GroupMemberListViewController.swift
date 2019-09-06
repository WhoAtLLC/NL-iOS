//
//  GroupMemberListViewController.swift
//  WishList
//
//  Created by Dharmesh on 26/08/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit


class GroupMemberListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var lblSelectedGroupName: UILabel!
    @IBOutlet weak var tblGroupList: UITableView!
    
    @IBOutlet weak var groupDetailPopUp: UIView!
    @IBOutlet weak var groupDetailSubView: UIView!
    @IBOutlet weak var lblSelectedGroupTitle: UILabel!
    @IBOutlet weak var lblCValidDate: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblOwnerCompany: UILabel!
    @IBOutlet weak var lblGroupOwnerHeadline: UILabel!
    @IBOutlet weak var lblYourConnectionAt: UILabel!
    @IBOutlet weak var grpDtlPopUpTopCnstrnt: NSLayoutConstraint!
    
    var selectedGroup: GroupObject?
    var selectedCompany: CompanyWishListObject?
    var connectionObjects = [ConnectionObject]()
    var originalData = [ConnectionObject]()
    var nextPageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblYourConnectionAt.text = selectedCompany?.title!
        lblDescription.isUserInteractionEnabled = false
        
        //groupDetailPopUp.setY(568)
        self.grpDtlPopUpTopCnstrnt.constant = 900
        groupDetailPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        groupDetailSubView.layer.cornerRadius = 5

        tblGroupList.separatorStyle = .none
        lblSelectedGroupName.text = selectedGroup?.name
        getSelectedCompaniesGroupMember()
    }
    
    @IBAction func btnCanclePopTapped(_ sender: AnyObject) {
        
        self.tabBarController?.tabBar.layer.zPosition = 0
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.groupDetailPopUp.setY(568)
                self.grpDtlPopUpTopCnstrnt.constant = 900
                
            }, completion: nil)
    }
    
    @IBAction func btnGroupTapped(_ sender: AnyObject) {
        
        for i in 0...self.navigationController!.viewControllers.count {
            
            if(self.navigationController?.viewControllers[i].isKind(of: CompaniesViewController.self) == true) {
                
                let test = self.navigationController?.viewControllers[i] as! CompaniesViewController
                test.companiesSelected = false
                test.groupsSelected = true
                
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! CompaniesViewController, animated: false)
            }
        }
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
                            
                            self.tabBarController?.tabBar.layer.zPosition = 0
                            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                                
                                //self.groupDetailPopUp.setY(568)
                                self.grpDtlPopUpTopCnstrnt.constant = 900
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
    
    @IBAction func btnGroupDetailTapped(_ sender: AnyObject) {
        
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
        
        self.tabBarController?.tabBar.layer.zPosition = -1
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                
                //self.groupDetailPopUp.setY(0)
                self.grpDtlPopUpTopCnstrnt.constant = 0
            }, completion: nil)
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
    
    var footerView = UIView()
    
    func initFooterView() {
        
        footerView = UIView(frame: CGRect(x: 0,y: 0,width: 320,height: 40))
        
        let actInd = UIActivityIndicatorView(style: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: 150, y: 5, width: 20, height: 20)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.view.endEditing(true)
        let searchCompanies = self.storyboard?.instantiateViewController(withIdentifier: "SearchCompanies") as! SearchCompaniesViewController
        self.navigationController?.pushViewController(searchCompanies, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    let connections = WLConnection()
    
    func getSelectedCompaniesGroupMember() {
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            
            let selectedCompaniesMember = WLGetSelectedCompaniesGroupMember()
            selectedCompaniesMember.groupHandle = selectedGroup!.slug!
            selectedCompaniesMember.selectedComapnyID = selectedCompany!.id!
            selectedCompaniesMember.getSelectedCompaniesGroupMember({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                self.connectionObjects.removeAll()
                self.originalData.removeAll()
                
                if let response = AnyObject as? [String : AnyObject] {
                    
                    if let results = response["results"] as? [[String: AnyObject]] {
                        
                        self.nextPageURL = ""
                        self.nextPageURL = response["next"] as? String ?? ""
                        
                        for connection in results {
                            
                            let wishlistmember = connection["wishlistmember"] as? Bool ?? false
                            let connectioncount = connection["connectioncount"] as? Int ?? 0
                            let title = connection["title"] as? String ?? ""
                            let connectionname = connection["connectionname"] as? String ?? ""
                            let highlight = connection["highlight"] as? Int ?? 0
                            let id = connection["id"] as? Int ?? 0
                            let connectionpossibleto = connection["connectionpossibleto"] as? [[String: AnyObject]]
                            
                            var mutualContactArr = [MutualContactObject]()
                            if connectionpossibleto?.count > 0 {
                                
                                for possibleConnection in connectionpossibleto! {
                                    
                                    let count = possibleConnection["count"] as? Int ?? 0
                                    let handle = possibleConnection["handle"] as? String ?? ""
                                    let title = possibleConnection["title"] as? String ?? ""
                                    let contact = possibleConnection["contact"] as? Int ?? 0
                                    let short_bio = possibleConnection["short_bio"] as? String ?? ""
                                    
                                    let mutualContactObj = MutualContactObject(handle: handle, title: title, count: count, contact: contact, short_bio: short_bio)
                                    mutualContactArr.append(mutualContactObj)
                                    
                                }
                            }
                            let connectionObj = ConnectionObject(wishlistmember: wishlistmember, connectioncount: connectioncount, title: title, connectionname: connectionname, mutualContactObj: mutualContactArr, highlight: highlight, id: id)
                            self.connectionObjects.append(connectionObj)
                            self.originalData.append(connectionObj)
                        }
                        
                        self.tblGroupList.reloadData()
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
            })
        }
    }
    
    @IBAction func btnDownArrowTapped(_ sender: AnyObject) {
        
        print("Called")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblGroupList.dequeueReusableCell(withIdentifier: "SelectedGroup", for: indexPath) as! YourConnectionsTableViewCell
        cell.selectionStyle = .none
        
        var connection: ConnectionObject?
        connection = connectionObjects[indexPath.row]
        
        cell.lblConnectionTitle.text = connection?.connectionname
        
        if connection?.highlight == 1 {
            
            cell.lblConnectionTitle.font = UIFont(name: "Gotham-Bold", size: cell.lblConnectionTitle.font.pointSize)
            
        } else {
            cell.lblConnectionTitle.font = UIFont(name: "Gotham-Book", size: cell.lblConnectionTitle.font.pointSize)
        }
        
        cell.lblPosition.text = connection!.title
        cell.lblConnectionCount.text = "\(connection!.connectioncount!)"
        
        if cell.lblPosition.text?.characters.count == 0 {
            cell.lblConnectionTitle.setY(26)
        } else {
            cell.lblConnectionTitle.setY(11)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return connectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let connectionView = self.storyboard?.instantiateViewController(withIdentifier: "MutualContacts") as! ContactDetailViewController
        connectionView.selectedConnectionObject = connectionObjects[indexPath.row]
        connectionView.commingFromGroup = true
        connectionView.selectedGroup = selectedGroup
        connectionView.selectedCompany = selectedCompany?.title ?? ""
        self.navigationController?.pushViewController(connectionView, animated: true)
        self.view.endEditing(true)
    }
    
    @IBAction func btnCompaniesTapped(_ sender: AnyObject) {
        
        for i in 0...self.navigationController!.viewControllers.count {
            
            if(self.navigationController?.viewControllers[i].isKind(of: CompaniesViewController.self) == true) {
                
                let test = self.navigationController?.viewControllers[i] as! CompaniesViewController
                test.companiesSelected = true
                test.groupsSelected = false
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! CompaniesViewController, animated: false)
            }
        }
    }
    
    @IBAction func btnMembersTapped(_ sender: AnyObject) {
        
        for i in 0...self.navigationController!.viewControllers.count {
            
            if(self.navigationController?.viewControllers[i].isKind(of: CompaniesViewController.self) == true) {
                
                let test = self.navigationController?.viewControllers[i] as! CompaniesViewController
                test.companiesSelected = false
                test.groupsSelected = false
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i] as! CompaniesViewController, animated: false)
            }
        }
    }
}
