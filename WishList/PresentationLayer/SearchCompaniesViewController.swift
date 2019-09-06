//
//  SearchCompaniesViewController.swift
//  WishList
//
//  Created by Dharmesh on 13/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import MessageUI
import Mixpanel

//import TSMessages

class SearchCompaniesViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, TSMessageViewProtocol {

    @IBOutlet weak var txtSearchCompanies: UITextField!
    @IBOutlet weak var tblCompaniesList: UITableView!
    @IBOutlet weak var companyTblHolder: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l5: UILabel!
    @IBOutlet weak var l6: UILabel!
    @IBOutlet weak var l7: UILabel!
    @IBOutlet weak var l8: UILabel!
    @IBOutlet weak var l9: UILabel!
    @IBOutlet weak var l10: UILabel!
    @IBOutlet weak var lblRecentSearches: UILabel!
    @IBOutlet weak var tblHotSearches: UITableView!
    let searchCompanies = WLSearchCompanies()
    
    
    var searchActive = false
    var nextCompanyFeedURL = ""
    var companiesObject = [CompanyWishListObject]()
    var tempCompaniesObject = [CompanyWishListObject]()
    var loadingCompleted = true
    var footerView = UIView()
    var lblArray = [UILabel]()
    var recentSeatchArray = [RecentSearchObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFooterView()
        lblArray = [l1,l2,l3,l4,l5,l6,l7,l8,l9,l10]
        noDataView.isHidden = true
        tblCompaniesList.separatorStyle = .none
        companyTblHolder.isHidden = true
        txtSearchCompanies.delegate = self
        txtSearchCompanies.backgroundColor = UIColor(patternImage: UIImage(named: "SearchBarBG")!)
        txtSearchCompanies.addTarget(self, action: #selector(SearchCompaniesViewController.textFieldDidChange(_:)), for: .editingChanged)
        txtSearchCompanies.autocorrectionType = .no
        txtSearchCompanies.clearButtonMode = UITextField.ViewMode.whileEditing
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchCompaniesViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchCompaniesViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ sender: Foundation.Notification) {
        
        tblCompaniesList.frame.size.height = 285
    }
    @objc func keyboardWillHide(_ sender: Foundation.Notification) {
        
        tblCompaniesList.frame.size.height = 450
    }
    
    func initFooterView() {
        
        footerView = UIView(frame: CGRect(x: 0,y: 0,width: 320,height: 40))
        
        let actInd = UIActivityIndicatorView(style: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: 150, y: 5, width: 20, height: 20)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        txtSearchCompanies.returnKeyType = UIReturnKeyType.done
        activityIndicator.isHidden = true
        txtSearchCompanies.becomeFirstResponder()
        txtSearchCompanies.textAlignment = .left
        
        let dict  = UserDefaults.standard.value(forKey: "hotSearches") as? [[String:AnyObject]]
       
        if let wrappedData = dict {
            lblRecentSearches.isHidden = false
            for dic in wrappedData {
                
                let id = dic["id"] as? Int ?? 0
                let name = dic["name"] as? String ?? ""
                let searchresult = RecentSearchObject(id: id, name: name)
                recentSeatchArray.append(searchresult)
            }
            tblHotSearches.reloadData()
            
        } else {
            lblRecentSearches.isHidden = true
        }
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.txtSearchCompanies.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        companiesObject.removeAll()
        
        if rechability.isConnectedToNetwork() {
            
            if textField.text?.characters.count > 1 {
                
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                
                searchCompanies.searchKeyword = textField.text!
                searchCompanies.searchCompany({(Void, AnyObject) -> Void in
                    
                    self.companiesObject.removeAll()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                    if let response = AnyObject as? [String : AnyObject] {
                        
                        self.nextCompanyFeedURL = response["next"] as? String ?? ""
                        
                        if let allCompanies = response["results"] as? [[String: AnyObject]] {
                            
                            self.companyTblHolder.isHidden = false
                            for companies in allCompanies {
                                
                                let id = companies["id"] as? Int ?? 0
                                let title = companies["title"] as? String ?? ""
                                let level = companies["level"] as? Int ?? 0
                                let icon = companies["icon"] as? String ?? ""
                                
                                let company = CompanyWishListObject(id: id, title: title, level: level, icon: icon)
                                self.tempCompaniesObject.append(company)
                            }
                            
                            for object in self.tempCompaniesObject {
                                
                                if object.title!.lowercased().contains(textField.text!.lowercased()) {
                                    
                                    self.companiesObject.append(object)
                                }
                            }
                            self.companiesObject = self.companiesObject.filterDuplicates { $0.title! == $1.title!}
                            
                            if self.companiesObject.count == 0 {
                                
                                self.noDataView.isHidden = false
                                self.companyTblHolder.isHidden = true
                                
                            } else {
                                
                                self.noDataView.isHidden = true
                                self.companyTblHolder.isHidden = false
                                self.tblCompaniesList.reloadData()
                            }
                        }
                    }
                    
                    }, errorCallback: {(Void, NSError) -> Void in
                        print(NSError)
                })
            } else {
                
                self.companiesObject.removeAll()
                self.tblCompaniesList.reloadData()
                self.noDataView.isHidden = true
                self.companyTblHolder.isHidden = true
            }
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        searchActive = true
        btnSearch.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        searchActive = false
        btnSearch.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblHotSearches {
             print(recentSeatchArray.count)
          return recentSeatchArray.count
        } else {
            print(companiesObject.count)
          return companiesObject.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblHotSearches {
            return 22
        } else {
            return 66
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblHotSearches {
            
            let cell = tblHotSearches.dequeueReusableCell(withIdentifier: "cell") as! HotSearchesTableViewCell
            cell.lbl.text = recentSeatchArray[indexPath.row].name as String
            
            return cell
            
        } else {
            
            let cell = tblCompaniesList.dequeueReusableCell(withIdentifier: "cell") as! DashBoardCompaniesTableViewCell
            cell.selectionStyle = .none
            let company = companiesObject[indexPath.row]
            
            cell.lblCompanyName.text = company.title
            
            switch company.level! {
                
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
            cell.imgCompany.image = UIImage(named: "CompanyPlaceHolderImage")
            
            if company.icon?.characters.count > 0 {
                cell.imgCompany.hnk_setImageFromURL(URL(string: company.icon!)!)
            } else {
                cell.imgCompany.image = UIImage(named: "CompanyPlaceHolderImage")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //EmailAFriend
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let acceptAction = UITableViewRowAction(style: .normal, title: "             ") {action, index in
            
            let emailTitle = "Feedback"
            let messageBody = "Feature request or bug report?"
            let toRecipents = ["test@g.com"]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            
            self.present(mc, animated: true, completion: nil)
        }
        
        acceptAction.backgroundColor = UIColor(patternImage: UIImage(named: "EmailAFriend")!)
        
        return [acceptAction]
        
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblHotSearches {
            
            let connectionView = self.storyboard?.instantiateViewController(withIdentifier: "yourConnection") as! YourConnectionViewController
            connectionView.recentSearchSelected = true
            connectionView.selectedCompanyFromRecentSearch = recentSeatchArray[indexPath.row]
            self.navigationController?.pushViewController(connectionView, animated: true)
            
        } else {
            
            let dict  = UserDefaults.standard.value(forKey: "hotSearches") as? [[String:AnyObject]]
            
            if let wrappedData = dict {
                
                var decodedCompanies = [RecentSearchObject]()
                for dic in wrappedData {
                    
                    let id = dic["id"] as? Int ?? 0
                    let name = dic["name"] as? String ?? ""
                    let searchresult = RecentSearchObject(id: id, name: name)
                    decodedCompanies.append(searchresult)
                }
                
                let comapny = RecentSearchObject(id: companiesObject[indexPath.row].id!, name: companiesObject[indexPath.row].title! as String)
                
                for i in 0 ..< decodedCompanies.count {
                    
                    if comapny.id == decodedCompanies[i].id {
                        decodedCompanies.remove(at: i)
                    }
                }
                decodedCompanies.insert(comapny, at: 0)
                
                var companyDicArr = [[String:AnyObject]]()
                for compony in decodedCompanies {
                    
                    let compony = ["id":compony.id! as AnyObject,"name":compony.name as String ] as [String : AnyObject]
                    companyDicArr.append(compony)
                    
                }
                UserDefaults.standard.set(companyDicArr, forKey: "hotSearches")
                
                let compony = ["id":decodedCompanies[0].id! as AnyObject,"name":decodedCompanies[0].name! as String ] as [String : AnyObject]
                UserDefaults.standard.set([compony], forKey: "hotSearches")
                
            } else {
                
                let compony = ["id":companiesObject[indexPath.row].id!,"name":companiesObject[indexPath.row].title! as String ] as [String : AnyObject]
                UserDefaults.standard.set([compony], forKey: "hotSearches")
                
            }
        
            let connectionView = self.storyboard?.instantiateViewController(withIdentifier: "yourConnection") as! YourConnectionViewController
            connectionView.recentSearchSelected = false
            connectionView.selectedCompany = companiesObject[indexPath.row]
            print(companiesObject[indexPath.row].title!)
            Mixpanel.sharedInstance()?.track("Company Searched", properties:["CompanyName": companiesObject[indexPath.row].title!])
            self.navigationController?.pushViewController(connectionView, animated: true)
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if companiesObject.count > 7 {
            
            if indexPath.row + 1 == companiesObject.count {
                
                if nextCompanyFeedURL.characters.count > 0 {
                    
                    if rechability.isConnectedToNetwork() {
                        
                        self.tblCompaniesList.tableFooterView = footerView
                        (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                        
                        let loadMoreCompanyFeed = WLMoreCompanyFeed()
                        loadMoreCompanyFeed.nextURL = nextCompanyFeedURL
                        loadMoreCompanyFeed.loadMoreCompanyFeed({(Void, AnyObject) -> Void in
                            
                            (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                            
                            if let response = AnyObject as? [String : AnyObject] {
                                
                                self.nextCompanyFeedURL = response["next"] as! String
                                
                                if let allCompanies = response["results"] as? [[String: AnyObject]] {
                                    
                                    for companies in allCompanies {
                                        
                                        let id = companies["id"] as? Int ?? 0
                                        let title = companies["title"] as? String ?? ""
                                        let level = companies["level"] as? Int ?? 0
                                        let icon = companies["icon"] as? String ?? ""
                                        
                                        let company = CompanyWishListObject(id: id, title: title, level: level, icon: icon)
                                        self.companiesObject.append(company)
                                    }
                                    
                                    self.tblCompaniesList.reloadData()
                                }
                            }
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                print(NSError)
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                        })
                    } else {
                        
                        TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                    }
                }
            }
        }
    }
}

extension Array {
    
    func filterDuplicates(_ includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}
