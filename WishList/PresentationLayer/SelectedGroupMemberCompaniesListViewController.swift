//
//  SelectedGroupMemberCompaniesListViewController.swift
//  WishList
//
//  Created by Dharmesh on 26/08/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel


class SelectedGroupMemberCompaniesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tblCompanyList: UITableView!
    @IBOutlet weak var lblSelectedGroupName: UILabel!
    @IBOutlet weak var txtSearchCompanies: UITextField!
    
    @IBOutlet weak var groupDetailPopUp: UIView!
    @IBOutlet weak var groupDetailSubView: UIView!
    @IBOutlet weak var lblSelectedGroupTitle: UILabel!
    @IBOutlet weak var lblCValidDate: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblOwnerCompany: UILabel!
    @IBOutlet weak var lblGroupOwnerHeadline: UILabel!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var MutualContactView: UIView!
    @IBOutlet weak var tblMutualContacts: UITableView!
    @IBOutlet weak var companiesView: UIView!
    @IBOutlet weak var newBtnGroups: UIButton!
    @IBOutlet weak var grpDtlPopUpTopCnstrnt: NSLayoutConstraint!
    
    var selectedGroup: GroupObject?
    var companiesObjects = [CompanyWishListObject]()
    var mutualContactObj = [MemberObjects]()
    
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMutualContacts.separatorStyle = .none
        MutualContactView.isHidden = false
        companiesView.isHidden = true
        tfSearch.addTarget(self, action: #selector(SelectedGroupMemberCompaniesListViewController.textFieldDidChange(_:)), for: .editingChanged)
        activityIndicator.isHidden = true
        lblDescription.isUserInteractionEnabled = false
        
        //groupDetailPopUp.setY(568)
        grpDtlPopUpTopCnstrnt.constant = 900
        groupDetailPopUp.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        groupDetailSubView.layer.cornerRadius = 5

        txtSearchCompanies.delegate = self
        txtSearchCompanies.isUserInteractionEnabled = true
        lblSelectedGroupName.text = selectedGroup?.name
        tblCompanyList.separatorStyle = .none
        getGroupMembers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        txtSearchCompanies.backgroundColor = UIColor(patternImage: UIImage(named: "SearchBarBG")!)
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
    
    @IBAction func btnUpArrowTapped(_ sender: AnyObject) {
        
        MutualContactView.isHidden = false
        companiesView.isHidden = true
        self.view.endEditing(true)
    }
    
    func getGroupMembers() {
        
        loader.showActivityIndicator(self.view)
        let getGroupMembers = WLGroupMemberList()
        getGroupMembers.group = selectedGroup!.slug!
        getGroupMembers.getGroupMemberList({(Void, AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            
            if let response = AnyObject as? [String: AnyObject] {
                
                if let result = response["results"] as? [[String: AnyObject]] {
                    
                    for contact in result {
                        
                        let id = contact["id"] as? Int ?? 0
                        let handle = contact["handle"] as? String ?? ""
                        let short_bio = contact["short_bio"] as? String ?? ""
                        let mutuals = contact["mutuals"] as? Int ?? 0
                        let avatar = contact["avatar"] as? String ?? ""
                        
                        let contactObj = MemberObjects(companies: 0, handle: handle, id: id, mutual: mutuals, short_bio: short_bio, leads: 0, avatar: avatar)
                        self.mutualContactObj.append(contactObj)
                    }
                }
                
                self.tblMutualContacts.reloadData()
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
                print(NSError)
        })
    }
    
    @IBAction func btnDownArrowTapped(_ sender: AnyObject) {
        
        MutualContactView.isHidden = true
        companiesView.isHidden = false
        self.view.endEditing(true)
        
        if companiesObjects.count == 0 {
            
            getCompaniesForSelectedGroup()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnGroupTapped(_ sender: AnyObject) {
        
        getGroups()
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
                        
                        if let result = faction[0] as? String {
                            
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
    
    func setupDropDowns() {
        
        chooseArticleDropDown.anchorView = newBtnGroups
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: newBtnGroups.bounds.height)
        chooseArticleDropDown.dataSource = groupNameArr
        chooseArticleDropDown.selectionAction = { [unowned self] (index, item) in
            
            self.tabBarController?.tabBar.isHidden = false
            let selectedGroupCompanyList = self.storyboard?.instantiateViewController(withIdentifier: "SelectedGroupMemberCompaniesListViewController") as! SelectedGroupMemberCompaniesListViewController
            Mixpanel.sharedInstance()?.track("Group Selected", properties:["Group": self.groupObjects[index].name!])
            selectedGroupCompanyList.selectedGroup = self.groupObjects[index]
            self.navigationController?.pushViewController(selectedGroupCompanyList, animated: true)
        }
    }
    
    var memberObjects = [MemberObjects]()
    var groupObjects = [GroupObject]()
    var groupNameArr = [String]()
    let mfLoader = MFLoader()
    
    func getGroups() {
        
        if groupObjects.count > 0 {
            
            self.setupDropDowns()
            self.dropDowns.forEach { $0.dismissMode = .onTap }
            self.dropDowns.forEach { $0.direction = .any }
            self.chooseArticleDropDown.show()
            
        } else {
            
            if rechability.isConnectedToNetwork() {
                
                mfLoader.showActivityIndicator(self.view)
                let groups = WLGroupList()
                groups.getGroupList({(Void, AnyObject) -> Void in
                    
                    self.mfLoader.hideActivityIndicator(self.view)
                    
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
                                self.groupNameArr.append(name)
                            }
                            
                            if self.groupNameArr.count > 0 {
                                
                                self.setupDropDowns()
                                self.dropDowns.forEach { $0.dismissMode = .onTap }
                                self.dropDowns.forEach { $0.direction = .any }
                                self.chooseArticleDropDown.show()
                            }
                        }
                    }
                    
                    }, errorCallback: {(Void, NSError) -> Void in
                        
                        self.mfLoader.hideActivityIndicator(self.view)
                })
            } else {
                
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case tblCompanyList:
            
            let cell = tblCompanyList.dequeueReusableCell(withIdentifier: "cell") as! DashBoardCompaniesTableViewCell
            cell.selectionStyle = .none
            
            let compObj = companiesObjects[indexPath.row]
            cell.lblCompanyName.text = compObj.title
            
            if compObj.icon?.characters.count > 0 {
                cell.imgCompany.hnk_setImageFromURL(URL(string: compObj.icon!)!)
            } else {
                cell.imgCompany.image = UIImage(named: "CompanyPlaceHolderImage")
            }
            
            switch compObj.level! {
                
            case 1:
                
                cell.imgCompanyConnectionStrength.image = UIImage(named: "L1")
                
            case 2:
                
                cell.imgCompanyConnectionStrength.image = UIImage(named: "L2")
                
            case 3:
                
                cell.imgCompanyConnectionStrength.image = UIImage(named: "L3")
                
            case 4:
                
                cell.imgCompanyConnectionStrength.image = UIImage(named: "L4")
                
            case 5:
                
                cell.imgCompanyConnectionStrength.image = UIImage(named: "L5")
                
            default:
                
                cell.imgCompanyConnectionStrength.image = nil
                
            }
            
            return cell
            
        case tblMutualContacts:
            
            let cell = self.tblMutualContacts.dequeueReusableCell(withIdentifier: "SelectedGroup", for: indexPath) as! YourConnectionsTableViewCell
            cell.selectionStyle = .none
            
            var connection: MemberObjects?
            connection = mutualContactObj[indexPath.row]
            
            cell.lblConnectionTitle.text = connection?.handle
            
            cell.lblPosition.text = connection!.short_bio
            cell.lblConnectionCount.text = "\(connection!.mutual!)"
            
            if cell.lblPosition.text?.characters.count == 0 {
                cell.lblConnectionTitle.setY(26)
            } else {
                cell.lblConnectionTitle.setY(11)
            }
            
            return cell
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    let searchGroupCompanies = WLSearchGroupCompanies()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        MutualContactView.isHidden = true
        companiesView.isHidden = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchGroupCompanies.group = selectedGroup!.slug!
        searchGroupCompanies.keyword = textField.text!
        searchGroupCompanies.searchCompaniesForGroup({(Void, AnyObject) -> Void in
            
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.companiesObjects.removeAll()
            if let response = AnyObject as? [String: AnyObject] {
                
                if let result = response["results"] as? [[String: AnyObject]] {
                    
                    for company in result {
                        
                        let id  = company["id"] as? Int ?? 0
                        let title = company["title"] as? String ?? ""
                        let level = company["level"] as? Int ?? 0
                        let icon = company["icon"] as? String ?? ""
                        
                        let compObj = CompanyWishListObject(id: id, title: title, level: level, icon: icon)
                        self.companiesObjects.append(compObj)
                    }
                    
                    self.tblCompanyList.reloadData()
                }
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                print(NSError)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case tblCompanyList:
            return companiesObjects.count
        case tblMutualContacts:
            return mutualContactObj.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case tblCompanyList:
            
            let selectedMCompanyMemberList = self.storyboard?.instantiateViewController(withIdentifier: "GroupMemberListViewController") as! GroupMemberListViewController
            selectedMCompanyMemberList.selectedGroup = selectedGroup
            selectedMCompanyMemberList.selectedCompany = companiesObjects[indexPath.row]
            self.navigationController?.pushViewController(selectedMCompanyMemberList, animated: true)
            
        case tblMutualContacts:
            
            let memberMatchingView = self.storyboard?.instantiateViewController(withIdentifier: "MemberMatchingViewController") as! MemberMatchingViewController
            memberMatchingView.selectedMemberObj = mutualContactObj[indexPath.row]
            self.navigationController?.pushViewController(memberMatchingView, animated: true)
            
        default:
            break
        }
        
        
    }
    
    func getCompaniesForSelectedGroup() {
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            let getGroupCompanies = WLGetGroupCompanies()
            getGroupCompanies.groupHandle = selectedGroup!.slug!
            
            getGroupCompanies.getCompaniesForSelectedGroups({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                if let response = AnyObject as? [String: AnyObject] {
                    
                    if let result = response["results"] as? [[String: AnyObject]] {
                        
                        for company in result {
                            
                            let id  = company["id"] as? Int ?? 0
                            let title = company["title"] as? String ?? ""
                            let level = company["level"] as? Int ?? 0
                            let icon = company["icon"] as? String ?? ""
                            
                            let compObj = CompanyWishListObject(id: id, title: title, level: level, icon: icon)
                            self.companiesObjects.append(compObj)
                        }
                        
                        self.tblCompanyList.reloadData()
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
            })
        }
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
