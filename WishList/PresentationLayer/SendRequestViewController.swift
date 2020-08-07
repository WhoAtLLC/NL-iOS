//
//  SendRequestViewController.swift
//  WishList
//
//  Created by Dharmesh on 01/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel
import Haneke
import Firebase
import FirebaseAuth
//import TSMessages


protocol SendRequestDelegate  {
    func switchToNotificationTab()
}

class SendRequestViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, TSMessageViewProtocol {

    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var introViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnReason: UIButton!
    @IBOutlet weak var btnCompanies: UIButton!
    @IBOutlet weak var btnMutualContacts: UIButton!
    @IBOutlet weak var introTextView: KMPlaceholderTextView!
    @IBOutlet weak var returnTextView: KMPlaceholderTextView!
    @IBOutlet weak var lblIntroCount: UILabel!
    @IBOutlet weak var lblReturnCount: UILabel!
    
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var reasonScrollView: UIScrollView!
    @IBOutlet weak var companiesView: UIView!
    @IBOutlet weak var mutualContactView: UIView!
    
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var tblMutualContacts: UITableView!
    
    @IBOutlet weak var btnSendRequest: UIButton!
    
    @IBOutlet weak var lblRequestTo: UILabel!
    @IBOutlet weak var lblSelectComp: UILabel!
    
    @IBOutlet weak var introBG: UIView!
    @IBOutlet weak var returnBG: UIView!
    
    @IBOutlet weak var introImage: UIImageView!
    @IBOutlet weak var btnClearIntro: UIButton!
    @IBOutlet weak var btnClearReturn: UIButton!
    
    var menuButtonArray = [UIButton]()
    
    var firstTime = UserDefaults.standard.bool(forKey: "firstTimeForSendRequest")
    
    var returnTextViewClicked = false
    
    var selectedMutualContact: MutualContactObject?
    var selectedConnectionObject: ConnectionObject?
    
    
    var companyObjects = [CompanyObject]()
    var nextPageURL = ""
    
    var connectionObjects = [MutualConnectionObject]()
    
    var selectedCompaniesArray = [Int]()
    var selectedCompaniesName = [String]()
    var companiesLoaded = false
    
    var handle = ""
    var nextMutualContactURL = ""
    var introducreName = ""
    var id = 0
    var changeTabDelegate: SendRequestDelegate?
    var myCompaniesForMemberMatching = [Int]()
    
    var commingFromMemberMatching = false
    var selectedCompany = ""
    var commingFromGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFooterView()
        returnTextView.placeholder = "Second, after reviewing the interests of \(handle), suggest how you can help them in return for helping you."
        lblRequestTo.text = "to \(introducreName)"
        introTextView.placeholder = "First, describe the reason for the intro to \(introducreName.characters.split{$0 == " "}.map(String.init)[0]) and what you're looking to accomplish."
        menuButtonArray = [btnReason, btnCompanies, btnMutualContacts]
        
        introTextView.delegate = self
        returnTextView.delegate = self
        tblCompanies.separatorStyle = .none
        tblMutualContacts.separatorStyle = .none
        
        companiesView.isHidden = true
        mutualContactView.isHidden = true
        
        getMutualContacts()
        getProfile()
    }
    
    @IBAction func btnClearIntroTapped(_ sender: AnyObject) {
        
        self.introTextView.text = ""
        self.btnClearIntro.isHidden = true
    }
    
    @IBAction func btnClearReturnTapped(_ sender: AnyObject) {
        
        self.returnTextView.text = ""
        self.btnClearReturn.isHidden = true
    }
    
    func getProfile() {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        loader.showActivityIndicator(self.view)
        let profile = WLProfile()
        
        profile.myProfile({ (Void, AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            if let response = AnyObject as? [String : AnyObject] {
                print("respose",response)
                let business_additional = response["business_additional"] as? String ?? ""
                let business_discussion = response["business_discussion"] as? String ?? ""
                
                self.introTextView.text = business_discussion + "\n\n" + business_additional
                
                self.lblIntroCount.text = "\(business_discussion.characters.count) of 500"
//                self.lblReturnCount.text = "\(business_additional.characters.count) of 500"
                
                if business_discussion.length > 0 {
                    
                    self.btnClearIntro.isHidden = false
                }
                
//                if business_additional.length > 0 {
//                    
//                    self.btnClearReturn.hidden = false
//                }
            }
            
            }, errorCallback: { (Void, NSError) -> Void in
                print(NSError)
                loader.hideActivityIndicator(self.view)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.introViewTopConstraint.constant = 1000
        firstTime = UserDefaults.standard.bool(forKey: "firstTimeForSendRequest")
        if !firstTime {
            
            self.introViewTopConstraint.constant = 0
            
            let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(SendRequestViewController.hideMainIntro))
            introImage.isUserInteractionEnabled = true
            introImage.addGestureRecognizer(tapForMainViewImage)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SendRequestViewController.respondToSwipeGesture(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.introImage.addGestureRecognizer(swipeLeft)
            
            introView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
           // self.tabBarController?.tabBar.layer.zPosition = -1
            self.tabBarController?.tabBar.isHidden = true
            UserDefaults.standard.set(true, forKey: "firstTimeForSendRequest")
            
        }
    }
    
    @objc func hideMainIntro() {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.introView.setY(568)
                self.introViewTopConstraint.constant = 1000
            }, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case .left:
                //self.tabBarController?.tabBar.layer.zPosition = 0
                self.tabBarController?.tabBar.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        //self.introView.setY(568)
                        self.introViewTopConstraint.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
    
        if textView == introTextView {
            self.introBG.layer.borderColor = UIColor.clear.cgColor
            
            if introTextView.text.length > 0 {
                
                self.btnClearIntro.isHidden = false
            } else {
                
                self.btnClearIntro.isHidden = true
            }
            
            
        } else {
            
            self.returnBG.layer.borderColor = UIColor.clear.cgColor
            
            if self.returnTextView.text.length > 0 {
                
                self.btnClearReturn.isHidden = false
            } else {
                
                self.btnClearReturn.isHidden = true
            }
            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == returnTextView {
            
            returnBG.backgroundColor = UIColor(netHex: 0xECECEC)
            returnTextView.placeholder = ""
            returnTextView.placeholderColor = UIColor(netHex: 0x7F7F84)
            reasonScrollView.contentInset = UIEdgeInsets(top: -100, left: 0, bottom: 0, right: 0)
            btnSendRequest.frame = CGRect(x: btnSendRequest.frame.origin.x, y: 270, width: btnSendRequest.frame.size.width, height: btnSendRequest.frame.size.height)
            
        } else {
            
            introBG.backgroundColor = UIColor(netHex: 0xECECEC)
            introTextView.placeholderColor = UIColor(netHex: 0x7F7F84)
            introTextView.placeholder = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == returnTextView {
            
            self.reasonScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.btnSendRequest.frame = CGRect(x: btnSendRequest.frame.origin.x, y: 467, width: btnSendRequest.frame.size.width, height: btnSendRequest.frame.size.height)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        if textView == introTextView {
            lblIntroCount.text = "\(textView.text.characters.count) of 500"
        } else {
            lblReturnCount.text = "\(textView.text.characters.count) of 500"
        }
        return textView.text.characters.count + (text.characters.count - range.length) <= 500
    }
    
    var selectedMutualContacts = [Int]()
    
    @IBAction func btnSendRequestTapped(_ sender: AnyObject) {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        self.view.endEditing(true)
        if introTextView.text.characters.count > 0 && returnTextView.text.characters.count > 0 {
                
            if selectedCompaniesArray.count > 0 {
                
                if !commingFromMemberMatching {
                    
                    print(introTextView.text!)
                    print(returnTextView.text!)
                    print(selectedCompaniesArray)
                    print(selectedMutualContacts)
                    print(selectedMutualContact!.handle!)
                    print(id)
                    
                    
                    
                    loader.showActivityIndicator(self.view)
                    
                    let dynamicLinksDomainURIPrefix = "https://niceleads.page.link"
                    let link = URL(string: "https://niceleads.com/accept")
                    guard let linkBuilder = DynamicLinkComponents.init(link: link!, domainURIPrefix: dynamicLinksDomainURIPrefix) else{
                        print("could not create")
                        return
                    }
                    
                    linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.root.wishlist")
                    linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.root.wishlist")
                    
                    guard let longDynamicLink = linkBuilder.url else { return }
                    print(longDynamicLink.absoluteString)
                    let sendRequestObject = WLSendRequestObject()
                    sendRequestObject.howIntroReason = introTextView.text!
                    sendRequestObject.whyIntroReason = returnTextView.text!
                    sendRequestObject.companiesofInterest = selectedCompaniesArray
                    sendRequestObject.excludedmutualcontacts = selectedMutualContacts
                    sendRequestObject.recipient = selectedMutualContact!.handle!
                    sendRequestObject.contact = id
                    sendRequestObject.dynamicLink = longDynamicLink.absoluteString
                    sendRequestObject.sendRequest({(Void, AnyObject) -> Void in
                        
                        loader.hideActivityIndicator(self.view)
                        
                        if let response = AnyObject as? [String : AnyObject] {
                            print("res",response)
                            if let status = response["status"] as? String {
                                
                                if status == "pending" {
                                    let selectedCompaniesString = self.selectedCompaniesName.joined(separator: "-")
                                    if self.commingFromGroup {
                                        
                                        Mixpanel.sharedInstance()?.track("Request Created With Groups", properties:["Selected Companies": selectedCompaniesString, "selectedCompany": self.selectedCompany, "Introduction To": self.introducreName, "Introduction From": self.handle])
                                    } else {
                                        
                                        Mixpanel.sharedInstance()?.track("Request Created", properties:["Selected Companies": selectedCompaniesString, "selectedCompany": self.selectedCompany, "Introduction To": self.introducreName, "Introduction From": self.handle])
                                    }
                                    self.btnSendRequest.setTitle("Request Sent", for: UIControl.State())
                                    self.btnSendRequest.isUserInteractionEnabled = false
                                    self.btnSendRequest.setBackgroundImage(UIImage(named: "RequestSent"), for: UIControl.State())
                                    self.tblMutualContacts.isUserInteractionEnabled = false
                                    self.tblCompanies.isUserInteractionEnabled = false
                                    self.introTextView.isUserInteractionEnabled = false
                                    self.returnTextView.isUserInteractionEnabled = false
                                    
                                    self.goToNotificationScreen()
                                }
                            }
                        }
                        
                        }, {(Void, NSError) -> Void in
                            loader.hideActivityIndicator(self.view)
                            
                            print(NSError)
                            
                            let alert = UIAlertController(title: "Alert", message: "Failed!!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    })
                    
                } else {
                    
                    print(introTextView.text!)
                    print(returnTextView.text!)
                    print(selectedCompaniesArray)
                    print(myCompaniesForMemberMatching)
                    print(handle)
                    
                    loader.showActivityIndicator(self.view)
                    let sendRequestWithMemberMatchingObject = WLSendRequestWithMemberMatchingObject()
                    sendRequestWithMemberMatchingObject.howIntroReason = introTextView.text!
                    sendRequestWithMemberMatchingObject.whyIntroReason = returnTextView.text!
                    sendRequestWithMemberMatchingObject.companiesofInterest = selectedCompaniesArray
                    sendRequestWithMemberMatchingObject.companiesOffered = selectedCompaniesArray
                    sendRequestWithMemberMatchingObject.excludedmutualcontacts = selectedMutualContacts
                    sendRequestWithMemberMatchingObject.recipient = handle
                    sendRequestWithMemberMatchingObject.category = "match"
                    sendRequestWithMemberMatchingObject.sendRequestWithMemberMatching({(Void, AnyObject) -> Void in
                        
                        loader.hideActivityIndicator(self.view)
                        print(AnyObject)
                        if let response = AnyObject as? [String : AnyObject] {
                            
                            if let status = response["status"] as? String {
                                
                                if status == "pending" {
                                    
                                    let selectedCompaniesString = self.selectedCompaniesName.joined(separator: "-")
                                    
                                    Mixpanel.sharedInstance()?.track("Request Created From Member Matching", properties:["Selected Member": self.introducreName, "Selected Companies": selectedCompaniesString])
                                    
                                    self.btnSendRequest.setTitle("Request Sent", for: UIControl.State())
                                    self.btnSendRequest.isUserInteractionEnabled = false
                                    self.btnSendRequest.setBackgroundImage(UIImage(named: "RequestSent"), for: UIControl.State())
                                    self.tblMutualContacts.isUserInteractionEnabled = false
                                    self.tblCompanies.isUserInteractionEnabled = false
                                    self.introTextView.isUserInteractionEnabled = false
                                    self.returnTextView.isUserInteractionEnabled = false
                                    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(SendRequestViewController.goToNotificationScreen), userInfo: nil, repeats: false)
                                }
                            }
                        }
                        
                        }, errorCallback: {(Void, NSError) -> Void in
                    
                            loader.hideActivityIndicator(self.view)
                    })
                    
                }
                
            } else {
                
                let alert = UIAlertController(title: "Alert", message: "Please select at least 1 company to offer help in return.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
                    
                    self.view.endEditing(true)
                    
                    self.lblSelectComp.text = "Select companies you can help \(self.handle)"
                    
                    self.btnCompanies.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
                    self.btnReason.setBackgroundImage(nil, for: UIControl.State())
                    self.btnMutualContacts.setBackgroundImage(nil, for: UIControl.State())
                    
                    self.reasonView.isHidden = true
                    self.companiesView.isHidden = false
                    self.mutualContactView.isHidden = true
                    
                    if !self.companiesLoaded {
                        self.getCompanies()
                    }
                
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        } else {
            
            self.view.endEditing(true)
            for menuButton in menuButtonArray {
                
                if menuButton.currentTitle! == "Reason" {
                    
                    menuButton.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
                } else {
                    menuButton.setBackgroundImage(nil, for: UIControl.State())
                }
            }
            reasonView.isHidden = false
            companiesView.isHidden = true
            mutualContactView.isHidden = true
            
            if introTextView.text.characters.count == 0 && returnTextView.text.characters.count == 0 {
                
                self.introBG.layer.borderWidth = 1
                self.introBG.layer.borderColor = UIColor.red.cgColor
                introBG.shake()
                
                self.returnBG.layer.borderWidth = 1
                self.returnBG.layer.borderColor = UIColor.red.cgColor
                returnBG.shake()
                
                let alert = UIAlertController(title: "Alert", message: "Enter why you want the intro and how you can help in return.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                if introTextView.text.characters.count == 0 {
                    
                    self.introBG.layer.borderWidth = 1
                    self.introBG.layer.borderColor = UIColor.red.cgColor
                    introBG.shake()
                    
                    let alert = UIAlertController(title: "Alert", message: "Enter why you want the intro.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    self.introBG.layer.borderColor = UIColor.clear.cgColor
                }
                
                if returnTextView.text.characters.count == 0 {
                    
                    self.returnBG.layer.borderWidth = 1
                    self.returnBG.layer.borderColor = UIColor.red.cgColor
                    returnBG.shake()
                    
                    let alert = UIAlertController(title: "Alert", message: "Enter how you can help in return.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    self.returnBG.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
    }
    
    @objc func goToNotificationScreen() {
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "SwitchTabNotification"), object: nil)
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnMutualContactTapped(_ sender: UIButton) {
        
        switch sender.currentTitle! {
            
            case "Reason":
                self.view.endEditing(true)
                for menuButton in menuButtonArray {
                    
                    if menuButton.currentTitle! == "Reason" {
                        
                        menuButton.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
                    } else {
                        menuButton.setBackgroundImage(nil, for: UIControl.State())
                    }
                }
                reasonView.isHidden = false
                companiesView.isHidden = true
                mutualContactView.isHidden = true
            
            case "Companies":
                
                self.view.endEditing(true)
                
                lblSelectComp.text = "Select companies you can help \(handle)"
                for menuButton in menuButtonArray {
                    
                    if menuButton.currentTitle! == "Companies" {
                        
                        menuButton.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
                    } else {
                        menuButton.setBackgroundImage(nil, for: UIControl.State())
                    }
                }
            
                reasonView.isHidden = true
                companiesView.isHidden = false
                mutualContactView.isHidden = true
                
                if !companiesLoaded {
                    getCompanies()
                }
            
            case "Mutual Contacts":
                
                self.view.endEditing(true)
                for menuButton in menuButtonArray {
                    
                    if menuButton.currentTitle! == "Mutual Contacts" {
                        
                        menuButton.setBackgroundImage(UIImage(named: "MutualContactBG"), for: UIControl.State())
                    } else {
                        menuButton.setBackgroundImage(nil, for: UIControl.State())
                    }
                }
            
                reasonView.isHidden = true
                companiesView.isHidden = true
                mutualContactView.isHidden = false
            
            default:
                break
            
        }
    }
    
    @IBAction func btnCancleIntroView(_ sender: AnyObject) {
        
    
       // self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        
        //introView.isHidden = true
        self.introViewTopConstraint.constant = 1000
    }
    
    func getCompanies() {
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            
            companyObjects.removeAll()
            
            let companyModel = WLCompanyList()
            
            companyModel.isContactCompanies = true
            companyModel.mutualContact = handle
            
            companyModel.companyList({ (Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                self.companiesLoaded = true
                
                let response = AnyObject as! [String: AnyObject]
                
                self.nextPageURL = response["next"] as? String ?? ""
                
                if let companies = response["results"] as? [[String: AnyObject]] {
                    
                    for company1 in companies {
                        
                        if let company = company1["company"] as? [String: AnyObject] {
                            
                            let id = company["id"] as? Int ?? 0
                            let slug = company["slug"] as? String ?? ""
                            let date_created = company["date_created"] as? String ?? ""
                            let date_changed = company["date_changed"] as? String ?? ""
                            let title = company["title"] as? String ?? ""
                            let profile_image_url = company["profile_image_url"] as? String ?? ""
                            let type = company["type"] as? String ?? ""
                            let primary_role = company["primary_role"] as? String ?? ""
                            let unique_thirdparty_ref = company["unique_thirdparty_ref"] as? String ?? ""
                            let short_description = company["short_description"] as? String ?? ""
                            let funding_round_name = company["funding_round_name"] as? String ?? ""
                            let crunchbase_url = company["crunchbase_url"] as? String ?? ""
                            let homepage_url = company["homepage_url"] as? String ?? ""
                            let facebook_url = company["facebook_url"] as? String ?? ""
                            let twitter_url = company["twitter_url"] as? String ?? ""
                            let linkedin_url = company["linkedin_url"] as? String ?? ""
                            let stock_symbol = company["stock_symbol"] as? String ?? ""
                            let location_city = company["location_city"] as? String ?? ""
                            let location_region = company["location_region"] as? String ?? ""
                            let location_country_code = company["location_country_code"] as? String ?? ""
                            
                            let companyDetail = CompanyObject(id: id, slug: slug, date_created: date_created, date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: false)
                            
                            self.companyObjects.append(companyDetail)
                        }
                    }
                    self.tblCompanies.reloadData()
                }
                
                }, errorCallback: { (Void, NSError) -> Void in
                    print(NSError)
                    loader.hideActivityIndicator(self.view)
                    
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
        
    }
    
    func getMutualContacts() {
        
        
        
        if rechability.isConnectedToNetwork() {
            
            if rechability.isConnectedToNetwork() {
                
                connectionObjects.removeAll()
                let connections = WLConnection()
                connections.isMutualContacts = true
                connections.contactHandle = handle
                connections.getConnections({(Void, AnyObject) -> Void in
                    
                    print(AnyObject)
                    if let responseMain = AnyObject as? [String: AnyObject] {
                        
                        self.nextMutualContactURL = responseMain["next"] as? String ?? ""
                        
                        if let response = responseMain["results"] as? [[String: AnyObject]] {
                            
                            for connection in response {
                                
                                let id = connection["id"] as? Int ?? 0
                                let connectioncount = connection["connectioncount"] as? Int ?? 0
                                let wishlistmember = connection["wishlistmember"] as? Int ?? 0
                                let slug = connection["slug"] as? String ?? ""
                                let date_created = connection["date_created"] as? String ?? ""
                                let date_changed = connection["date_changed"] as? String ?? ""
                                let first_name = connection["first_name"] as? String ?? ""
                                let middle_name = connection["middle_name"] as? String ?? ""
                                let last_name = connection["last_name"] as? String ?? ""
                                let label = connection["label"] as? String ?? ""
                                let title = connection["title"] as? String ?? ""
                                let email = connection["email"] as? String ?? ""
                                let address = connection["address"] as? String ?? ""
                                let address_two = connection["address_two"] as? String ?? ""
                                let city = connection["city"] as? String ?? ""
                                let state = connection["state"] as? String ?? ""
                                let postal_code = connection["postal_code"] as? String ?? ""
                                let country = connection["country"] as? String ?? ""
                                let date_submitted = connection["date_submitted"] as? String ?? ""
                                let date_updated = connection["date_updated"] as? String ?? ""
                                let approved = connection["approved"] as? Int ?? 0
                                let handle = connection["handle"] as? String ?? ""
                                let bio = connection["bio"] as? String ?? ""
                                let key = connection["key"] as? Int ?? 0
                                let profile = connection["profile"] as? Int ?? 0
                                let company = connection["company"] as? String ?? ""
                                
                                let connectionObject = MutualConnectionObject(id: id, connectioncount: connectioncount, wishlistmember: wishlistmember, slug: slug, date_created: date_created, date_changed: date_changed, first_name: first_name, middle_name: middle_name, last_name: last_name, label: label, title: title, email: email, address: address, address_two: address_two, city: city, state: state, postal_code: postal_code, country: country, date_submitted: date_submitted, date_updated: date_updated, approved: approved, handle: handle, bio: bio, key: key, profile: profile, fullName: first_name + " " + last_name, company: company)
                                
                                self.connectionObjects.append(connectionObject)
                            }
                            
                            self.tblMutualContacts.reloadData()
                        }
                    }
                    
                    }, errorCallback: {(Void, NSError) -> Void in
                        
                        
                })
            } else {
                
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            }
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
    
}

extension SendRequestViewController{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == tblCompanies {
            
            if companyObjects.count > 7 {
                
                if indexPath.row + 1 == companyObjects.count {
                    
                    if nextPageURL.characters.count > 0 {
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblCompanies.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            let companyModel = WLLoadMoreCompanyList()
                            companyModel.nextPageURL = nextPageURL
                            companyModel.loadMoreCompanies({(Void,AnyObject) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                let response = AnyObject as! [String: AnyObject]
                                self.nextPageURL = response["next"] as? String ?? ""
                                
                                if let companies = response["results"] as? [[String: AnyObject]] {
                                    
                                    for company1 in companies {
                                        
                                        if let company = company1["company"] as? [String : AnyObject] {
                                            
                                            let id = company["id"] as? Int ?? 0
                                            let slug = company["slug"] as? String ?? ""
                                            let date_created = company["date_created"] as? String ?? ""
                                            let date_changed = company["date_changed"] as? String ?? ""
                                            let title = company["title"] as? String ?? ""
                                            let profile_image_url = company["profile_image_url"] as? String ?? ""
                                            let type = company["type"] as? String ?? ""
                                            let primary_role = company["primary_role"] as? String ?? ""
                                            let unique_thirdparty_ref = company["unique_thirdparty_ref"] as? String ?? ""
                                            let short_description = company["short_description"] as? String ?? ""
                                            let funding_round_name = company["funding_round_name"] as? String ?? ""
                                            let crunchbase_url = company["crunchbase_url"] as? String ?? ""
                                            let homepage_url = company["homepage_url"] as? String ?? ""
                                            let facebook_url = company["facebook_url"] as? String ?? ""
                                            let twitter_url = company["twitter_url"] as? String ?? ""
                                            let linkedin_url = company["linkedin_url"] as? String ?? ""
                                            let stock_symbol = company["stock_symbol"] as? String ?? ""
                                            let location_city = company["location_city"] as? String ?? ""
                                            let location_region = company["location_region"] as? String ?? ""
                                            let location_country_code = company["location_country_code"] as? String ?? ""
                                            
                                            let companyDetail = CompanyObject(id: id, slug: slug, date_created: date_created, date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: false)
                                            
                                            self.companyObjects.append(companyDetail)
                                        }
                                    }
                                    self.tblCompanies.reloadData()
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
        } else if tableView == tblMutualContacts {
            
            if rechability.isConnectedToNetwork() {
                
                if connectionObjects.count > 7 {
                    
                    if indexPath.row + 1 == connectionObjects.count {
                        
                        if nextMutualContactURL.characters.count > 0 {
                            
                            self.tblMutualContacts.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            let connections = WLConnection()
                            connections.nextMutualContactURL = nextMutualContactURL
                            connections.getConnections({(Void, AnyObject) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                
                                if let responseMain = AnyObject as? [String: AnyObject] {
                                    
                                    self.nextMutualContactURL = responseMain["next"] as? String ?? ""
                                    
                                    if let response = responseMain["results"] as? [[String: AnyObject]] {
                                        
                                        for connection in response {
                                            
                                            let id = connection["id"] as? Int ?? 0
                                            let connectioncount = connection["connectioncount"] as? Int ?? 0
                                            let wishlistmember = connection["wishlistmember"] as? Int ?? 0
                                            let slug = connection["slug"] as? String ?? ""
                                            let date_created = connection["date_created"] as? String ?? ""
                                            let date_changed = connection["date_changed"] as? String ?? ""
                                            let first_name = connection["first_name"] as? String ?? ""
                                            let middle_name = connection["middle_name"] as? String ?? ""
                                            let last_name = connection["last_name"] as? String ?? ""
                                            let label = connection["label"] as? String ?? ""
                                            let title = connection["title"] as? String ?? ""
                                            let email = connection["email"] as? String ?? ""
                                            let address = connection["address"] as? String ?? ""
                                            let address_two = connection["address_two"] as? String ?? ""
                                            let city = connection["city"] as? String ?? ""
                                            let state = connection["state"] as? String ?? ""
                                            let postal_code = connection["postal_code"] as? String ?? ""
                                            let country = connection["country"] as? String ?? ""
                                            let date_submitted = connection["date_submitted"] as? String ?? ""
                                            let date_updated = connection["date_updated"] as? String ?? ""
                                            let approved = connection["approved"] as? Int ?? 0
                                            let handle = connection["handle"] as? String ?? ""
                                            let bio = connection["bio"] as? String ?? ""
                                            let key = connection["key"] as? Int ?? 0
                                            let profile = connection["profile"] as? Int ?? 0
                                            let company = connection["company"] as? String ?? ""
                                            
                                            let connectionObject = MutualConnectionObject(id: id, connectioncount: connectioncount, wishlistmember: wishlistmember, slug: slug, date_created: date_created, date_changed: date_changed, first_name: first_name, middle_name: middle_name, last_name: last_name, label: label, title: title, email: email, address: address, address_two: address_two, city: city, state: state, postal_code: postal_code, country: country, date_submitted: date_submitted, date_updated: date_updated, approved: approved, handle: handle, bio: bio, key: key, profile: profile, fullName: first_name + " " + last_name, company: company)
                                            
                                            self.connectionObjects.append(connectionObject)
                                        }
                                        
                                        self.tblMutualContacts.reloadData()
                                    }
                                }
                                
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                            })
                        }
                    }
                }
            } else {
                
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblCompanies {
            return 70
        } else {
            return 62
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if tableView == tblMutualContacts {
            return "Archive"
        } else {
            return "Delete"
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableView == tblMutualContacts {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == tblMutualContacts {
            if editingStyle == .delete {
                selectedMutualContacts.append(connectionObjects[indexPath.row].id!)
                connectionObjects.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.tblCompanies {
            count = companyObjects.count
        }
        
        if tableView == self.tblMutualContacts {
            count =  connectionObjects.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblCompanies {
            let cell = tableView.dequeueReusableCell(withIdentifier: "companiesCell", for: indexPath) as! CompaniesSendRequestTableViewCell
            cell.selectionStyle = .none
            let company = companyObjects[indexPath.row]
            cell.lblCompanyName.text = company.title
            if let url = URL(string: company.profile_image_url!) {
                cell.imgCompany.hnk_setImageFromURL(url)
            }
            cell.btnSelected.isSelected = company.isSelected!
            
            return cell
        }
        else {
            
            let cell = self.tblMutualContacts.dequeueReusableCell(withIdentifier: "mutulaContactsCell")! as! MutualContactsSendRequestTableViewCell
            cell.selectionStyle = .none
            let contact = connectionObjects[indexPath.row]
            cell.lblContactName.text = contact.fullName
            cell.lblContactPosition.text = contact.title
            cell.lblContactCompany.text = contact.company
            
            if cell.lblContactPosition.text?.characters.count == 0 {
                cell.lblContactName.setY(20)
            } else {
                cell.lblContactName.setY(8)
            }
            //            cell.lblContactCompany.text = contact.label
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblCompanies {
            let company = companyObjects[indexPath.row]
            
            if company.isSelected == true {
                company.isSelected = false
                
            } else {
                company.isSelected = true
            }
            
            selectedCompaniesArray.removeAll()
            selectedCompaniesName.removeAll()
            
            for comp in companyObjects {
                
                if comp.isSelected == true {
                    selectedCompaniesArray.append(comp.id!)
                    selectedCompaniesName.append(comp.title!)
                }
            }
            self.tblCompanies.reloadData()
        }
    }
    
}
