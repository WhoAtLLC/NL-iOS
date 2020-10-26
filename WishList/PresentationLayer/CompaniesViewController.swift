//
//  DahsBoardViewController.swift
//  WishList
//
//  Created by Dharmesh on 18/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import MessageUI
import Mixpanel
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//import TSMessage

class CompaniesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate, TSMessageViewProtocol, MFMessageComposeViewControllerDelegate {

    //Empty Contact Screen
    @IBOutlet weak var imgLoader: UIImageView!
    @IBOutlet weak var txtSearchCompanies: UITextField!
    
    //Intro View
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var introSubView: UIView!
    @IBOutlet weak var introLayerView: UIView!
    @IBOutlet weak var imgIntroSubview: UIImageView!
    @IBOutlet weak var lbltitleIntroSubView: UILabel!
    @IBOutlet weak var txtDescriptionIntroSubView: UILabel!
    @IBOutlet weak var txtVDescriptionIntroSubView: UITextView!
    @IBOutlet weak var introViewTopConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyListView: UIView!
    @IBOutlet weak var tblCompaniesList: UITableView!
    @IBOutlet weak var lblContactInfo: UILabel!
    
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnMembers: UIButton!
    
    @IBOutlet weak var memberView: UIView!
    @IBOutlet weak var tblMembers: UITableView!
    
    @IBOutlet weak var introImage: UIImageView!
    @IBOutlet weak var memberIntroView: UIView!
    @IBOutlet weak var membrIntroViewTopCnstrnt: NSLayoutConstraint!
    
    @IBOutlet weak var viewNoMembers: UIView!
    @IBOutlet weak var selectGroupPopUpView: UIView!
    @IBOutlet weak var slctGrpPopUpViewTopCnstrnt: NSLayoutConstraint!
    
    @IBOutlet weak var selectGroupSubView: UIView!
    @IBOutlet weak var lblSelectGroup: UILabel!
    @IBOutlet weak var lblNoGroups1: UILabel!
    @IBOutlet weak var lblNoGroups2: UILabel!
    @IBOutlet weak var btnLearnMoreHere: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var newBtnGroups: UIButton!
    
    
    var firstTime = UserDefaults.standard.bool(forKey: "firstTime")
    var firstTimeMemberIntro = UserDefaults.standard.bool(forKey: "firstTimeMemberIntro")
    var loader: FillableLoader = FillableLoader()
    
    var companiesObject = [CompanyWishListObject]()
    var FilterCompObject = [CompanyWishListObject]()
    var filtered = [CompanyWishListObject]()
        var tempCompaniesObject = [CompanyWishListObject]()
    
    var tempMembersObject = [MemberObjects]()
    
    var nextCompanyFeedURL = ""
    var nextMemberURL = ""
    var footerView = UIView()
    var refreshControl: UIRefreshControl!
    var timer: Timer?
    let mfLoader = MFLoader()
    var companiesSelected = true
    var groupsSelected = false
    var timerForNotificationCounter: Timer?
    var overLayView : UIView?
        let searchCompanies = WLSearchCompanies()
    let chooseArticleDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if companiesSelected {
            
            btnCompany.isSelected = true
            btnMembers.isSelected = false
            // selectGroupPopUpView.setY(568)
            self.slctGrpPopUpViewTopCnstrnt.constant = 1000
            removeOverLay()
            companyListView.isHidden = false
            memberView.isHidden = true
            companiesSelected = true
            groupsSelected = false
            getCompanies()
            
        }
//        print(WLUserSettings.getAuthToken())
        viewNoMembers.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(CompaniesViewController.methodOfReceivedNotification(_:)), name:NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CompaniesViewController.updateCounterForAppForeground(_:)), name: NSNotification.Name(rawValue: "UpdateCounterForAppForeground"), object: nil)
        initFooterView()
        tblCompaniesList.separatorStyle = .none
        tblMembers.separatorStyle = .none
        lblContactInfo.text = "You're either a super connector with loads of contacts or our server loads are high. We're making this process smarter soon so please be patient!\n\n In the mean time, complete your Profile by clicking My Account below."
        
        txtSearchCompanies.delegate = self
        btnCompany.isSelected = true
        memberView.isHidden = true
        txtSearchCompanies.addTarget(self, action: #selector(CompaniesViewController.textFieldDidChange(_:)), for: .editingChanged)
        txtSearchCompanies.autocorrectionType = .no
//        txtSearchCompanies.clearButtonMode = UITextField.ViewMode.whileEditing
        txtSearchCompanies.returnKeyType = UIReturnKeyType.done
        txtSearchCompanies.textAlignment = .left
        //selectGroupPopUpView.setY(568)
        self.slctGrpPopUpViewTopCnstrnt.constant = 1000
        removeOverLay()
        selectGroupPopUpView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        selectGroupSubView.layer.cornerRadius = 5
        txtSearchCompanies.backgroundColor = UIColor(patternImage: UIImage(named: "SearchBarBG")!)
        self.activityIndicator.stopAnimating()
        if timerForNotificationCounter == nil {
            
//            timerForNotificationCounter = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(CompaniesViewController.updateCounterForNotificationInBackground), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.membrIntroViewTopCnstrnt.constant = 1000
        // self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        
        if companiesSelected {
 
        } else if groupsSelected {
            
            btnMembers.isSelected = false
            btnCompany.isSelected = false
            
            companyListView.isHidden = true
            memberView.isHidden = true
            companiesSelected = false
            groupsSelected = true
            
            getGroups()
            
        } else {
            
            btnMembers.isSelected = true
            btnCompany.isSelected = false
            //selectGroupPopUpView.setY(568)
            self.slctGrpPopUpViewTopCnstrnt.constant = 1000
            removeOverLay()
            companyListView.isHidden = true
            memberView.isHidden = false
            companiesSelected = false
            groupsSelected = false
            getMembers()
        }
        
        firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        
        if !firstTime {
            
            //introView.setY(0)
            self.introViewTopConstarint.constant = 0
            introView.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(CompaniesViewController.hideIntro))
            introLayerView.addGestureRecognizer(tap)
            
            let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(CompaniesViewController.hideMainIntro))
            introImage.isUserInteractionEnabled = true
            introImage.addGestureRecognizer(tapForMainViewImage)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CompaniesViewController.respondToSwipeGesture(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.introImage.addGestureRecognizer(swipeLeft)
            
            introSubView.isHidden = true
            introLayerView.isHidden = true
            
            introSubView.layer.cornerRadius = 8.0
            introSubView.clipsToBounds = true
            
            introLayerView.isHidden = true
            introSubView.isHidden = true
            
            self.tabBarController?.tabBar.isHidden = true
            UserDefaults.standard.set(true, forKey: "firstTime")
            
        } else {
            
            introView.isHidden = true
            let loaderGIF = UIImage(named: "loader2")
            imgLoader.image = loaderGIF
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func setupUI(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1792, 2436, 2688:
                introImage.image = UIImage(named: "IntroImageX")
            default:
               introImage.image = UIImage(named: "introimageNew")
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {     
       if txtSearchCompanies.placeholder == "Search Companies"
       {
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
                            
//                            self.companyTblHolder.isHidden = false
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
                            

                                self.tblCompaniesList.reloadData()
//                            }
                        }
                    }
                    
                }, errorCallback: {(Void, NSError) -> Void in
                    print(NSError)
                })
            } else {
                
//                self.companiesObject.removeAll()
                getCompanies()
               self.loader.removeLoader()
//                self.noDataView.isHidden = true
//                self.companyTblHolder.isHidden = true
            }
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
       }else{
        
        tempMembersObject = memberObjects
        memberObjects.removeAll()
        
        if rechability.isConnectedToNetwork() {
            
            if textField.text?.characters.count > 0 {
                
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                
                let searchKeyword = textField.text!
                
                 for member in tempMembersObject
                 {
                    if member.handle!.lowercased().contains(searchKeyword.lowercased())
                    {
                       memberObjects.append(member)
                    }
                 }
                 self.memberObjects = self.memberObjects.filterDuplicates { $0.handle! == $1.handle!}
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tblMembers.reloadData()
              
            } else {
                
                getMembers()
                self.loader.removeLoader()
            }
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.txtSearchCompanies.resignFirstResponder()
        return true
    }

    
    func addOverLay(){
    
        var h :CGFloat = 83
    
        overLayView = UIView(frame: CGRect(x: 0, y: self.view.height-10, width: self.view.width, height: h+10))
        overLayView?.backgroundColor = UIColor.black.withAlphaComponent(0.82)
        
        self.tabBarController?.view.addSubview(overLayView!)
    }
    
    func removeOverLay(){
        
        overLayView?.removeFromSuperview()
    }
    
    @IBAction func btnContactTapped(_ sender: AnyObject) {
        
        let emailTitle = ""
        let messageBody = ""
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(["sales@whoat.io"])
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mc, animated: true, completion: nil)
        } else {
            
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func updateCounterForNotificationInBackground() {
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            print("This is run on the background queue")
            if rechability.isConnectedToNetwork() {
                let profile = WLProfile()
                
                profile.myProfile({ (Void, Any) -> Void in
                    
                    if let dict = (Any).self as? [String: AnyObject] {
                        
                        if let notifications = dict["notifications"] as? [String: AnyObject] {
                            
                            if let unread = notifications["unread"] as? Int {
                                
                                let tabArray = self.tabBarController?.tabBar.items as NSArray!
                                let tabItem = tabArray?.object(at: 1) as! UITabBarItem
                                
                                if unread > 0 {
                                    
                                    tabItem.badgeValue = "\(unread)"
                                } else {
                                    tabItem.badgeValue = nil
                                    
                                }
                                UIApplication.shared.applicationIconBadgeNumber = unread
                            }
                        }
                    }
                    
                    }, errorCallback: { (Void, NSError) -> Void in
                        print(NSError)
                })
            }
        })
    }
    
    @IBAction func btnLearnMoreHereTapped(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: "https://wishlist.whoat.io/for-organizers.html")!)
    }
    
    @IBAction func btnAddMoreFromCompaniesList(_ sender: AnyObject) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            
            controller.body = "Save time networking for new opportunities. Join me on WhoAt's WishList today https://itunes.apple.com/us/app/whoat-wishlist/id1123737064?mt=8"
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func updateCounterForAppForeground(_ notification: Foundation.Notification) {
        
        if rechability.isConnectedToNetwork() {
            let profile = WLProfile()
            
            profile.myProfile({ (Void, AnyObject) -> Void in
                
                if let dict = AnyObject as? [String: AnyObject] {
                    
                    if let notifications = dict["notifications"] as? [String: AnyObject] {
                        
                        if let unread = notifications["unread"] as? Int {
                            
                            let tabArray = self.tabBarController?.tabBar.items as NSArray!
                            let tabItem = tabArray?.object(at: 1) as! UITabBarItem
                            
                            if unread > 0 {
                                
                                tabItem.badgeValue = "\(unread)"
                            } else {
                                tabItem.badgeValue = nil
                                
                            }
                            UIApplication.shared.applicationIconBadgeNumber = unread
                        }
                    }
                }
                
                }, errorCallback: { (Void, NSError) -> Void in
                    print(NSError)
            })
        }
    }
    
    @objc func methodOfReceivedNotification(_ notification: Foundation.Notification){
        
        let dict = notification.object as! NSDictionary
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray?.object(at: 1) as! UITabBarItem
        let newBadge = UIApplication.shared.applicationIconBadgeNumber + 1
        
        if newBadge > 0 {
            
            tabItem.badgeValue = "\(newBadge)"
        } else {
            tabItem.badgeValue = nil
            
        }
        UIApplication.shared.applicationIconBadgeNumber = newBadge
        
        if let alert = dict["alert"] as? String {
            
            if alert.contains("rejected") {
                
                let alert = UIAlertController(title: "Bummer ;-(", message: alert, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                    print(requestIDGlobal)
                    
                    let tabArray = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabArray?.object(at: 1) as! UITabBarItem
                    let newBadge = UIApplication.shared.applicationIconBadgeNumber
                    
                    if newBadge > 0 {
                        
                        tabItem.badgeValue = "\(newBadge)"
                        UIApplication.shared.applicationIconBadgeNumber = newBadge
                    } else {
                        
                        tabItem.badgeValue = nil
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                    
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "SwitchTabNotification"), object: nil)
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "RefreshNotificationsAPI"), object: nil)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                    requestIDGlobal = ""
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else if alert.contains("accepted your request to meet") {
                
                let alert = UIAlertController(title: "You're getting some love!", message: alert, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                    print(requestIDGlobal)
                    
                    let tabArray = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabArray?.object(at: 1) as! UITabBarItem
                    let newBadge = UIApplication.shared.applicationIconBadgeNumber
                    
                    if newBadge > 0 {
                        
                        tabItem.badgeValue = "\(newBadge)"
                        UIApplication.shared.applicationIconBadgeNumber = newBadge
                    } else {
                        
                        tabItem.badgeValue = nil
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                    
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "SwitchTabNotification"), object: nil)
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "RefreshNotificationsAPI"), object: nil)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
                    
                    requestIDGlobal = ""
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else if alert.contains("sent you a message on") {
                
                let alert = UIAlertController(title: "New lead for you!", message: alert, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    
                    print(requestIDGlobal)
                    
                    let tabArray = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabArray?.object(at: 1) as! UITabBarItem
                    let newBadge = UIApplication.shared.applicationIconBadgeNumber
                    
                    if newBadge > 0 {
                        
                        tabItem.badgeValue = "\(newBadge)"
                        UIApplication.shared.applicationIconBadgeNumber = newBadge
                    } else {
                        
                        tabItem.badgeValue = nil
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                    
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "SwitchTabNotification"), object: nil)
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "RefreshNotificationsAPI"), object: nil)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                    requestIDGlobal = ""
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Push", message: alert, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                    print(requestIDGlobal)
                    
                    let tabArray = self.tabBarController?.tabBar.items as NSArray!
                    let tabItem = tabArray?.object(at: 1) as! UITabBarItem
                    let newBadge = UIApplication.shared.applicationIconBadgeNumber
                    
                    if newBadge > 0 {
                        
                        tabItem.badgeValue = "\(newBadge)"
                        UIApplication.shared.applicationIconBadgeNumber = newBadge
                    } else {
                        
                        tabItem.badgeValue = nil
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                    
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "SwitchTabNotification"), object: nil)
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "RefreshNotificationsAPI"), object: nil)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                    requestIDGlobal = ""
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnCancleGroupSelectionPopUp(_ sender: AnyObject) {
        
        btnCompany.isSelected = true
        btnMembers.isSelected = false
        
        companyListView.isHidden = false
        memberView.isHidden = true
        companiesSelected = true
        getCompanies()
        
        // self.tabBarController?.tabBar.isHidden = false
        removeOverLay()
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.selectGroupPopUpView.setY(568)
                self.slctGrpPopUpViewTopCnstrnt.constant = 1000
            }, completion: nil)
    }
    
    @IBAction func addMoreCompaniesTapped(_ sender: AnyObject) {
        
        let BusinessInterestView = self.storyboard?.instantiateViewController(withIdentifier: "SetUpBusinessView") as! SetUpBusinessViewController
        BusinessInterestView.commingFromCompaniseScreen = true
        self.navigationController?.pushViewController(BusinessInterestView, animated: true)
    }
    
    @IBAction func inviteOthersTapped(_ sender: AnyObject) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Save time networking for new opportunities. Join me on WhoAt's WishList today https://itunes.apple.com/us/app/whoat-wishlist/id1123737064?mt=8"
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var groupNameArr = [String]()
    
    @IBAction func menuButtonsTapped(_ sender: UIButton) {
        
        if let title = sender.currentTitle {
            
            switch title {
                
            case "Companies":
                self.txtSearchCompanies.placeholder = "Search Companies"
                btnCompany.isSelected = true
                btnMembers.isSelected = false
                //selectGroupPopUpView.setY(568)
                self.slctGrpPopUpViewTopCnstrnt.constant = 1000
                removeOverLay()
                companyListView.isHidden = false
                memberView.isHidden = true
                companiesSelected = true
                groupsSelected = false
                getCompanies()
                
            case "Members":
                 self.txtSearchCompanies.placeholder = "Search Members"
                firstTimeMemberIntro = UserDefaults.standard.bool(forKey: "firstTimeMemberIntro")
                if !firstTimeMemberIntro {
                    
                    //memberIntroView.setY(0)
                    self.membrIntroViewTopCnstrnt.constant = 0
                    memberIntroView.isHidden = false
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(CompaniesViewController.hideIntroForMember))
                    memberIntroView.addGestureRecognizer(tap)
                    
                    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CompaniesViewController.respondToSwipeGestureForMember(_:)))
                    swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                    self.memberIntroView.addGestureRecognizer(swipeLeft)
                    
                    self.tabBarController?.tabBar.isHidden = true
                    UserDefaults.standard.set(true, forKey: "firstTimeMemberIntro")
                    
                }
                
                btnMembers.isSelected = true
                btnCompany.isSelected = false
               // selectGroupPopUpView.setY(568)
                self.slctGrpPopUpViewTopCnstrnt.constant = 1000
                removeOverLay()
                companyListView.isHidden = true
                memberView.isHidden = false
                companiesSelected = false
                groupsSelected = false
                getMembers()
                
            default:
                
                break
            }
            
        } else {
            
            getGroups()
        }
    }
    
    func setupDropDowns() {
        
        chooseArticleDropDown.anchorView = newBtnGroups
        chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: newBtnGroups.bounds.height)
        chooseArticleDropDown.dataSource = groupNameArr
        chooseArticleDropDown.selectionAction = { [unowned self] (index, item) in
            
            self.tabBarController?.tabBar.isHidden = false
            self.removeOverLay()
            let selectedGroupCompanyList = self.storyboard?.instantiateViewController(withIdentifier: "SelectedGroupMemberCompaniesListViewController") as! SelectedGroupMemberCompaniesListViewController
            Mixpanel.sharedInstance()?.track("Group Selected", properties:["Group": self.groupObjects[index].name!])
            selectedGroupCompanyList.selectedGroup = self.groupObjects[index]
            self.navigationController?.pushViewController(selectedGroupCompanyList, animated: true)
        }
    }
    
    var memberObjects = [MemberObjects]()
    var groupObjects = [GroupObject]()
    
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
                    
                    if let response =  AnyObject as? [String: AnyObject] {
                        
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
                                
                            } else {
                                
                                //self.tabBarController?.tabBar.isHidden = true
                               self.addOverLay()
                                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                    initialSpringVelocity: 0.5, options: [], animations:
                                    {
                                        //self.selectGroupPopUpView.setY(0)
                                        self.slctGrpPopUpViewTopCnstrnt.constant = 0
                                    }, completion: nil)
                                
                                
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
    
    func getMembers() {
        
        if rechability.isConnectedToNetwork() {
            
            mfLoader.showActivityIndicator(self.view)
            let members = WLMembersList()
            members.getMemberList({(Void,  AnyObject) -> Void in
                
                self.mfLoader.hideActivityIndicator(self.view)
                
                self.memberObjects.removeAll()
                if let response =  AnyObject as? [String: AnyObject] {
                    
                    self.nextMemberURL = response["next"] as? String ?? ""
                    
                    if let result = response["results"] as? [[String : AnyObject]] {
                        
                        for member in result {
                            
                            let id = member["id"] as? Int ?? 0
                            let companies = member["companies"] as? Int ?? 0
                            let mutual = member["mutual"] as? Int ?? 0
                            let handle = member["handle"] as? String ?? ""
                            let short_bio = member["short_bio"] as? String ?? ""
                            let leads = member["leads"] as? Int ?? 0
                            let avatar = member["avatar"] as? String ?? ""
                            
                            if handle.count > 0 {
                                let memberObj = MemberObjects(companies: companies, handle: handle, id: id, mutual: mutual, short_bio: short_bio, leads: leads, avatar: avatar)
                                self.memberObjects.append(memberObj)
                            }
                        }
                        if self.memberObjects.count > 0 {
                            self.viewNoMembers.isHidden = true
                        } else {
                            self.viewNoMembers.isHidden = false
                        }
                        
                        self.tblMembers.reloadData()
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    self.viewNoMembers.isHidden = false
                    self.mfLoader.hideActivityIndicator(self.view)
                    
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
    
    func refresh(_ sender:AnyObject) {
        
        self.tblCompaniesList.delegate = nil
        self.tblCompaniesList.dataSource = nil
        
        if rechability.isConnectedToNetwork() {

            companiesObject.removeAll()
            tblCompaniesList.allowsSelection = false
            let companyModel = WLCompanyWishList()
            companyModel.getCompanyWishList({(Void,  AnyObject) -> Void in
                
                self.loader.removeLoader()
                
                if let response =  AnyObject as? [String : AnyObject] {
                    print(response)
                    self.nextCompanyFeedURL = response["next"] as? String ?? ""
                    
                    if let allCompanies = response["results"] as? [[String: AnyObject]] {
                        
                        
                        for companies in allCompanies {
                            
                            let id = companies["id"] as? Int ?? 0
                            let title = companies["title"] as? String ?? ""
                            let level = companies["level"] as? Int ?? 0
                            let icon = companies["icon"] as? String ?? ""
                            
                            let company = CompanyWishListObject(id: id, title: title, level: level, icon: icon)
                            self.companiesObject.append(company)
                        }
                        
                        self.tblCompaniesList.dataSource = self
                        self.tblCompaniesList.delegate = self
                        
                        if self.companiesObject.count != 0 {
                            
                            self.companyListView.isHidden = false
                            self.refreshControl.endRefreshing()
                            self.tblCompaniesList.reloadData()
                            self.tblCompaniesList.allowsSelection = true
                            
                        } else {
                            
                            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CompaniesViewController.getCompanies), userInfo: nil, repeats: false)
                        }
                        
                    } else {
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CompaniesViewController.getCompanies), userInfo: nil, repeats: false)
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
            })
        } else {
            
            refreshControl.endRefreshing()
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
    
    
    
    @IBAction func hideMemberIntro(_ sender: AnyObject) {
        
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.memberIntroView.setY(568)
                self.membrIntroViewTopCnstrnt.constant = 1000
            }, completion: nil)
    }
    
    @objc func hideMainIntro() {
        
      self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.introView.setY(568)
                self.introViewTopConstarint.constant = 1000
                
            }, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                self.tabBarController?.tabBar.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        //self.introView.setY(568)
                        self.introViewTopConstarint.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    @objc func respondToSwipeGestureForMember(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                self.tabBarController?.tabBar.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        //self.memberIntroView.setY(568)
                        self.membrIntroViewTopCnstrnt.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    func initFooterView() {
        
        footerView = UIView(frame: CGRect(x: 0,y: 0,width: 320,height: 40))
        
        let actInd = UIActivityIndicatorView(style: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: 150, y: 5, width: 20, height: 20)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        
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
    
    @objc func getCompanies() {
        
        if rechability.isConnectedToNetwork() {
            
            loader = WavesLoader.showLoaderWithPath(Paths.twitterPath())
            companiesObject.removeAll()
            let companyModel = WLCompanyWishList()
            companyModel.getCompanyWishList({(Void,  AnyObject) -> Void in
                
                self.loader.removeLoader()
                
                if let response =  AnyObject as? [String : AnyObject] {
                    
                    self.nextCompanyFeedURL = response["next"] as? String ?? ""
                    
                    if let notifications = response["notifications"] as? [String: AnyObject] {
                        
                        if let unread = notifications["unread"] as? Int {
                            
                            let tabArray = self.tabBarController?.tabBar.items as NSArray!
                            let tabItem = tabArray?.object(at: 1) as! UITabBarItem
                            
                            UIApplication.shared.applicationIconBadgeNumber = unread
                            
                            if unread > 0 {
                                
                                tabItem.badgeValue = "\(unread)"
                            } else {
                                tabItem.badgeValue = nil
                                
                            }
                            
                        }
                    }
                    
                    if let allCompanies = response["results"] as? [[String: AnyObject]] {
                        
                        
                        for companies in allCompanies {
                            
                            let id = companies["id"] as? Int ?? 0
                            let title = companies["title"] as? String ?? ""
                            let level = companies["level"] as? Int ?? 0
                            let icon = companies["icon"] as? String ?? ""
                            
                            let company = CompanyWishListObject(id: id, title: title, level: level, icon: icon)
                            self.companiesObject.append(company)
                        }
                        
                        if self.companiesObject.count != 0 {
                            self.loader.removeLoader()
                            self.companyListView.isHidden = false
                            self.tblCompaniesList.reloadData()
                            
                        } else {
                            
                            self.checkNetworkSelected()
                        }
                        
                    } else {
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CompaniesViewController.getCompanies), userInfo: nil, repeats: false)
                    }
                }
                
                self.checkStatus()
                
                }, errorCallback: {(Void, NSError) -> Void in
                    self.loader.removeLoader()
                    self.checkStatus()
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Something failed", subtitle: "The internet connection seems to be down. Please check that!", type: TSMessageNotificationType.error)
        }
    }
    
    func checkStatus() {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        let emailStatus = WLCheckEmailStatus()
        emailStatus.checkEmailStatus({(Void, AnyObject) -> Void in
            
            print("sucess")
            
            }, {(Void, NSError) -> Void in
                
                let resendEmailView = self.storyboard?.instantiateViewController(withIdentifier: "ResendEmailViewController") as! ResendEmailViewController
                resendEmailView.commingFromDashboard = true
                self.navigationController?.pushViewController(resendEmailView, animated: true)
        })
    }
    
    func checkNetworkSelected() {
        
        let chooseNetworkModel = WLChooseNetwork()
        chooseNetworkModel.fromMoreScreen = true
        chooseNetworkModel.chooseNetwork({(Void,  AnyObject) -> Void in
            
            print( AnyObject)
            if let response =  AnyObject as? [String: AnyObject] {
                if let status = response["network_status"] as? String {
                    
                    if status == "open" {
                        
                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CompaniesViewController.getCompanies), userInfo: nil, repeats: false)
                        
                    } else {
                        
                        let SwitchToOpenNetworkingView = self.storyboard?.instantiateViewController(withIdentifier: "SwitchToOpenNetworking") as! SwitchToOpenNetworkingViewController
                        self.navigationController?.pushViewController(SwitchToOpenNetworkingView, animated: true)
                    }
                }
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                print(NSError)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if timer != nil {
            timer?.invalidate()
        }
    }
    
    

    @IBAction func btnDismissIntroViewClicked(_ sender: AnyObject) {
        
        introView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        let loaderGIF = UIImage(named: "loader2")
        imgLoader.image = loaderGIF
        
        txtSearchCompanies.backgroundColor = UIColor(patternImage: UIImage(named: "SearchBarBG")!)
    }
    
    @IBAction func btnDismissIntroSubView(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introLayerView.setY(568)
                self.introSubView.setY(568)
            }, completion: {(finished: Bool) -> Void in
                
                self.introLayerView.isHidden = true
                self.introSubView.isHidden = true
        })
    }
    
    @IBAction func btnCompanysIntroTapped(_ sender: AnyObject) {
        
        imgIntroSubview.image = UIImage(named: "IntroCompnies")
        lbltitleIntroSubView.text = "Companies"
        txtVDescriptionIntroSubView.text = "This is a feed of all companies you can get an intro to. Start an intro request by selecting a company you'd like an intro to."
        setTextWithLineSpacing(txtVDescriptionIntroSubView, text: txtVDescriptionIntroSubView.text, lineSpacing: 4.0)
        txtVDescriptionIntroSubView.textAlignment = .center
        txtVDescriptionIntroSubView.textColor = UIColor(netHex: 0x5A6478)
        
        introLayerView.isHidden = false
        introSubView.isHidden = false
        
        self.introLayerView.setY(568)
        introSubView.setY(568)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introLayerView.setY(0)
                self.introSubView.setY(119.0)
            }, completion: nil)
    }
    
    @IBAction func btnConnectionIntroTapped(_ sender: AnyObject) {
        
        introLayerView.isHidden = false
        introSubView.isHidden = false
        imgIntroSubview.image = UIImage(named: "IntroConnections")
        lbltitleIntroSubView.text = "Connections"
        txtVDescriptionIntroSubView.text = "An indicator of how many other members have contacts at the company you want an intro to. 1 bar is < 10 and 5 bars represents > 100 other members have relationships at that company."
        setTextWithLineSpacing(txtVDescriptionIntroSubView, text: txtVDescriptionIntroSubView.text, lineSpacing: 4.0)
        txtVDescriptionIntroSubView.textAlignment = .center
        txtVDescriptionIntroSubView.textColor = UIColor(netHex: 0x5A6478)
        
        introLayerView.setY(568)
        introSubView.setY(568)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introLayerView.setY(0)
                self.introSubView.setY(119.0)
            }, completion: nil)
    }
    
    @IBAction func btnCompanyListIntoTapped(_ sender: AnyObject) {
        
        introLayerView.isHidden = false
        introSubView.isHidden = false
        imgIntroSubview.image = UIImage(named: "IntroCompanyList")
        lbltitleIntroSubView.text = "Company List"
        txtVDescriptionIntroSubView.text = "Each company name links you to a list of company employees you can get an intro to based on your network settings. Only the screen name of the contact owner is displayed until they opt in, then their real name and Profile info is shared."
        setTextWithLineSpacing(txtVDescriptionIntroSubView, text: txtVDescriptionIntroSubView.text, lineSpacing: 4.0)
        txtVDescriptionIntroSubView.textAlignment = .center
        txtVDescriptionIntroSubView.textColor = UIColor(netHex: 0x5A6478)
        
        introLayerView.setY(568)
        introSubView.setY(568)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introLayerView.setY(0)
                self.introSubView.setY(119.0)
            }, completion: nil)
    }
    
    @IBAction func btnNotificationIntroTapped(_ sender: AnyObject) {
        
        introLayerView.isHidden = false
        introSubView.isHidden = false
        imgIntroSubview.image = UIImage(named: "IntroNotification")
        lbltitleIntroSubView.text = "Notifications"
        txtVDescriptionIntroSubView.text = "Notifications are where all incoming and outgoing requests and responses are displayed. Respond to an Intro Request here."
        setTextWithLineSpacing(txtVDescriptionIntroSubView, text: txtVDescriptionIntroSubView.text, lineSpacing: 4.0)
        txtVDescriptionIntroSubView.textAlignment = .center
        txtVDescriptionIntroSubView.textColor = UIColor(netHex: 0x5A6478)
        
        introLayerView.setY(568)
        introSubView.setY(568)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introLayerView.setY(0)
                self.introSubView.setY(119.0)
            }, completion: nil)
    }
    
    @IBAction func btnMyAccountIntroTapped(_ sender: AnyObject) {
        
        introLayerView.isHidden = false
        introSubView.isHidden = false
        imgIntroSubview.image = UIImage(named: "IntroAccount")
        lbltitleIntroSubView.text = "My Account"
        txtVDescriptionIntroSubView.text = "Where you will find your Profile, Screen Name and other Settings to improve your experience."
        setTextWithLineSpacing(txtVDescriptionIntroSubView, text: txtVDescriptionIntroSubView.text, lineSpacing: 4.0)
        txtVDescriptionIntroSubView.textAlignment = .center
        txtVDescriptionIntroSubView.textColor = UIColor(netHex: 0x5A6478)
        
        introLayerView.setY(568)
        introSubView.setY(568)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introLayerView.setY(0)
                self.introSubView.setY(119.0)
            }, completion: nil)
    }
    
    @IBAction func btnMoreOptionIntroTapped(_ sender: AnyObject) {
        
        introLayerView.isHidden = false
        introSubView.isHidden = false
        imgIntroSubview.image = UIImage(named: "IntroMore")
        lbltitleIntroSubView.text = "More"
        txtVDescriptionIntroSubView.text = "Links to functions that improve, modify or personalize your WishList experience."
        setTextWithLineSpacing(txtVDescriptionIntroSubView, text: txtVDescriptionIntroSubView.text, lineSpacing: 4.0)
        txtVDescriptionIntroSubView.textAlignment = .center
        txtVDescriptionIntroSubView.textColor = UIColor(netHex: 0x5A6478)
        
        introLayerView.setY(568)
        introSubView.setY(568)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introLayerView.setY(0)
                self.introSubView.setY(119.0)
            }, completion: nil)
    }
    
    @objc func hideIntro() {
        
        introLayerView.isHidden = true
        introSubView.isHidden = true
    }
    
    @objc func hideIntroForMember() {
        
        self.tabBarController?.tabBar.isHidden = false
        memberIntroView.isHidden = true
    }
    
    func setTextWithLineSpacing(_ label:UITextView,text:String,lineSpacing:CGFloat) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        label.attributedText = attrString
    }
    
    func goToNetworkingScreen() {
        
        self.tabBarController?.tabBar.isHidden = false
        self.performSegue(withIdentifier: "SwitchToOpenNetworking", sender: self)
    }
}

extension CompaniesViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblCompaniesList {
            
            return companiesObject.count
        } else if tableView == tblMembers {
            
            return memberObjects.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch tableView {
        case tblCompaniesList:
            
            if companiesObject.count > 7 {
                
                if indexPath.row + 1 == companiesObject.count {
                    
                    if nextCompanyFeedURL.characters.count > 0 {
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblCompaniesList.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            let loadMoreCompanyFeed = WLMoreCompanyFeed()
                            loadMoreCompanyFeed.nextURL = nextCompanyFeedURL
                            loadMoreCompanyFeed.loadMoreCompanyFeed({(Void,  AnyObject) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                
                                if let response =  AnyObject as? [String : AnyObject] {
                                    
                                    self.nextCompanyFeedURL = response["next"] as? String ?? ""
                                    
                                    if let allCompanies = response["results"] as? [[String: AnyObject]] {
                                        
                                        self.companyListView.isHidden = false
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
            
        case tblMembers:
            
            if memberObjects.count > 7 {
                
                if indexPath.row + 1 == memberObjects.count {
                    
                    if nextMemberURL.characters.count > 0 {
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblMembers.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            let members = WLMembersList()
                            members.getMemberList({(Void,  AnyObject) -> Void in
                                
                                if let response =  AnyObject as? [String: AnyObject] {
                                    
                                    self.nextMemberURL = ""
                                    self.nextMemberURL = response["next"] as? String ?? ""
                                    
                                    if let result = response["results"] as? [[String : AnyObject]] {
                                        
                                        for member in result {
                                            
                                            let id = member["id"] as? Int ?? 0
                                            let companies = member["companies"] as? Int ?? 0
                                            let mutual = member["mutual"] as? Int ?? 0
                                            let handle = member["handle"] as? String ?? ""
                                            let short_bio = member["short_bio"] as? String ?? ""
                                            let leads = member["leads"] as? Int ?? 0
                                            let avatar = member["avatar"] as? String ?? ""
                                            
                                            let memberObj = MemberObjects(companies: companies, handle: handle, id: id, mutual: mutual, short_bio: short_bio, leads: leads, avatar: avatar)
                                            self.memberObjects.append(memberObj)
                                        }
                                        
                                        self.tblMembers.reloadData()
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
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblCompaniesList {
            
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
            
        } else if tableView == tblMembers {
            
            let cell = self.tblMembers.dequeueReusableCell(withIdentifier: "YourConnections", for: indexPath) as! YourConnectionsTableViewCell
            cell.selectionStyle = .none
            
            let member = memberObjects[indexPath.row]
            
            cell.lblConnectionTitle.text = member.handle
            
            cell.lblPosition.text = member.short_bio
            cell.lblConnectionCount.text = "\(member.leads!)"
            if member.avatar?.characters.count > 0 {
                let url = URL(string: WLAppSettings.getBaseUrl() + member.avatar!)
                if(url != nil) {
                    cell.imgMember.hnk_setImageFromURL(url!)
                }
            }
            
            cell.imgMember.makeThisRound
            
            
            
            return cell
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblCompaniesList {
            
            let connectionView = self.storyboard?.instantiateViewController(withIdentifier: "yourConnection") as! YourConnectionViewController
            connectionView.selectedCompany = companiesObject[indexPath.row]
            self.navigationController?.pushViewController(connectionView, animated: true)
            
        } else if tableView == tblMembers {
            
            let memberMatchingView = self.storyboard?.instantiateViewController(withIdentifier: "MemberMatchingViewController") as! MemberMatchingViewController
            memberMatchingView.selectedMemberObj = memberObjects[indexPath.row]
            self.navigationController?.pushViewController(memberMatchingView, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //EmailAFriend
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let companyName = companiesObject[indexPath.row].title
        print(companyName)
        
        let acceptAction = UITableViewRowAction(style: .normal, title: "             ") {action, index in
            
            let emailTitle = "I'd like to meet someone at \(companyName!). Can you help me?"
            let messageBody = "Hello,<br><br> I'm looking to make a connection with someone at \(companyName!). Please let me know if you can help me.<br><br> Save time networking for new opportunities. Join me on WhoAt's WishList today <a href='https://appsto.re/us/O3T-cb.i'>https://appsto.re/us/O3T-cb.i</a> <br><br> Sincerely,<br><br>"
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: true)
            
            self.present(mc, animated: true, completion: nil)
            self.tblCompaniesList.reloadData()
        }
        
        acceptAction.backgroundColor = UIColor(patternImage: UIImage(named: "EmailAFriend")!)
        
        return [acceptAction]
        
    }
    
}
