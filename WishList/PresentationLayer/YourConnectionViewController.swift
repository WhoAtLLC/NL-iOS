//
//  YourConnectionViewController.swift
//  WishList
//
//  Created by Dharmesh on 28/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

//import TSMessages

class YourConnectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TSMessageViewProtocol {
    
    @IBOutlet weak var tblConnections: UITableView!
    @IBOutlet weak var companiesIntroView: UIView!
    @IBOutlet weak var compniesIntroViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblSelectedCompanyName: UILabel!
    @IBOutlet weak var searchBarHolder: UIView!
    @IBOutlet weak var lblSearchInfo: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var btnCancleSearch: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var introImage: UIImageView!
    
    var selectedCompany: CompanyWishListObject?
    var recentSearchSelected = false
    var selectedCompanyFromRecentSearch: RecentSearchObject?
    
    var firstTime = UserDefaults.standard.bool(forKey: "firstTimeCompanyIntro")
    
    var connectionObjects = [ConnectionObject]()
    var filtered = [ConnectionObject]()
    var originalData = [ConnectionObject]()
    
    var searchActive = false
    var nextPageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(YourConnectionViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(YourConnectionViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tblConnections.separatorStyle = .none
        searchTextField.isHidden = true
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(YourConnectionViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchTextField.tintColor = UIColor.white
        searchTextField.returnKeyType = UIReturnKeyType.done
        searchTextField.autocorrectionType = .no
        searchTextField.textColor = UIColor.white
        btnCancleSearch.isHidden = true
        
        if recentSearchSelected {
            
            lblSelectedCompanyName.text = selectedCompanyFromRecentSearch?.name as? String
        } else {
            lblSelectedCompanyName.text = selectedCompany?.title
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(YourConnectionViewController.btnSearchTapped(_:)))
        lblSearchInfo.isUserInteractionEnabled = true
        lblSearchInfo.addGestureRecognizer(tap)
        
        if rechability.isConnectedToNetwork() {
            getConnections()
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
        initFooterView()
    }
    
    @IBAction func btnCancleSearchTapped(_ sender: AnyObject) {
        
        btnSearch.isHidden = false
        btnCancleSearch.isHidden = true
        searchTextField.resignFirstResponder()
        searchTextField.isHidden = true
        lblSearchInfo.isHidden = false
        
        searchActive = false
        connectionObjects = originalData
        tblConnections.reloadData()
    }
    
    @IBAction func btnSearchTapped(_ sender: AnyObject) {
        
        btnSearch.isHidden = true
        btnCancleSearch.isHidden = false
        searchTextField.becomeFirstResponder()
        searchTextField.isHidden = false
        lblSearchInfo.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ///self.compniesIntroViewTopConstraint.constant = 1000
        firstTime = UserDefaults.standard.bool(forKey: "firstTimeCompanyIntro")
        if !firstTime {
            
            let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(YourConnectionViewController.hideMainIntro))
            introImage.isUserInteractionEnabled = true
            introImage.addGestureRecognizer(tapForMainViewImage)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(YourConnectionViewController.respondToSwipeGesture(_:)))
            swipeLeft.direction = .left
            self.introImage.addGestureRecognizer(swipeLeft)
            
            Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(YourConnectionViewController.openIntroView), userInfo: nil, repeats: false)
        }
        else {
            companiesIntroView.isHidden = true
        }
    }
    
    @objc func hideMainIntro() {
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.companiesIntroView.setY(568)
                 self.compniesIntroViewTopConstraint.constant = 1000
            }, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case .left:
                self.tabBarController?.tabBar.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        //self.companiesIntroView.setY(568)
                        self.compniesIntroViewTopConstraint.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ sender: Foundation.Notification) {
        
        tblConnections.setHeight(215)
    }
    
    @objc func keyboardWillHide(_ sender: Foundation.Notification) {
        
        tblConnections.setHeight(381)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
//        self.filtered = self.connectionObjects.filter({( aSpecies: ConnectionObject) -> Bool in
//            
//            return aSpecies.connectionname!.lowercaseString.rangeOfString(textField.text!.lowercaseString) != nil
//        })
//        
//        let filteredWithTitle = self.connectionObjects.filter({( aSpecies: ConnectionObject) -> Bool in
//            
//            return aSpecies.title!.lowercaseString.rangeOfString(textField.text!.lowercaseString) != nil
//        })
//        
//        self.filtered = filtered + filteredWithTitle
//        
//        if textField.text?.length == 0 {
//            
//            searchActive = false
//        } else {
//            searchActive = true
//        }
        
//        if self.filtered.count == 0 {
        
            searchActive = false
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let connectionSearch = WLSearchConnection()
            if recentSearchSelected {
                connectionSearch.ConnectionID = selectedCompanyFromRecentSearch!.id!
            } else {
                connectionSearch.ConnectionID = selectedCompany!.id!
            }
            
            connectionSearch.searchKey = textField.text!
            connectionSearch.SearchConnection({(Void,  AnyObject) -> Void in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                self.connectionObjects.removeAll()
                
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
                        }
                        print(self.connectionObjects)
                        self.tblConnections.reloadData()
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    print(NSError)
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
            })
//        }
        self.tblConnections.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        btnCancleSearch.isHidden = false
        btnSearch.isHidden = true
        filtered = originalData
        textField.placeholder = nil
//        searchActive = true
        self.tblConnections.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        return false
    }
    
    let connections = WLConnection()
    
    func getConnections() {
        
        loader.showActivityIndicator(self.view)
        
        if recentSearchSelected {
            connections.companyID = selectedCompanyFromRecentSearch!.id!
        } else {
            connections.companyID = selectedCompany!.id!
        }
        
        connections.getConnections({(Void, AnyObject) -> Void in
            
            self.connectionObjects.removeAll()
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
                    
                    self.tblConnections.reloadData()
                }
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
        
        })
        
    }
    
    @objc func openIntroView() {
        companiesIntroView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        firstTime = true
        self.tabBarController?.tabBar.isHidden = true
        UserDefaults.standard.set(true, forKey: "firstTimeCompanyIntro")
    }
    
    @IBAction func btnGoBackTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelCompaniesIntro(_ sender: AnyObject) {
        
        companiesIntroView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        } else {
            return connectionObjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblConnections.dequeueReusableCell(withIdentifier: "YourConnections", for: indexPath) as! YourConnectionsTableViewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let connectionView = self.storyboard?.instantiateViewController(withIdentifier: "MutualContacts") as! ContactDetailViewController
        if searchActive {
            connectionView.selectedConnectionObject = filtered[indexPath.row]
            connectionView.selectedCompany = selectedCompany!.title!
        } else {
            connectionView.selectedConnectionObject = connectionObjects[indexPath.row]
            connectionView.selectedCompany = selectedCompany?.title ?? ""
        }
        self.navigationController?.pushViewController(connectionView, animated: true)
        self.view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if connectionObjects.count > 7 {
            
            if indexPath.row + 1 == connectionObjects.count {
                
                if nextPageURL.characters.count > 0 {
                    
                    if rechability.isConnectedToNetwork() {
                        
                        self.tblConnections.tableFooterView = footerView
                        (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                        
                        connections.nextMutualContactURL = nextPageURL
                        connections.getConnections({(Void, AnyObject) -> Void in
                            
                            (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                            
                            if let response = AnyObject as? [String : AnyObject] {
                                
                                if let results = response["results"] as? [[String: AnyObject]] {
                                    
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
                                        
                                        if self.searchTextField.text?.length == 0 {
                                            
                                            self.filtered = self.connectionObjects
                                        }
                                    }
                                    
                                    self.tblConnections.reloadData()
                                }
                            }
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
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
