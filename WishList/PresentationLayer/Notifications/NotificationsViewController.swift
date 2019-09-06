//
//  NotificationsViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/10/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel

//import TSMessages

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, TSMessageViewProtocol {

    @IBOutlet var tblNotification: UITableView!
    @IBOutlet var outgoingHeader: WLNotificationHeaderView!
    @IBOutlet var incomingHeader: WLNotificationHeaderView!
    @IBOutlet var archievedHeader: WLNotificationHeaderView!
    
    @IBOutlet weak var companiesIntroView: UIView!

    @IBOutlet weak var cmpniesIntroViewTopCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var introImage: UIImageView!
    
    var arrOutGoingNotification = NSMutableArray()
    var arrIncomingNotification = NSMutableArray()
    var arrArchivedNotification = NSMutableArray()
    
    var outboundObjects = [OutboundObject]()
    var inboundObjects = [InboundObject]()
    var archivedObject = [ArchivedObject]()
    
    var isFirstTime = UserDefaults.standard.bool(forKey: "NotificationFirstTime")
    
    var hidingNavBarManager: HidingNavigationBarManager?
    
    var introViewOutSide = false
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.getNotifications), name: NSNotification.Name(rawValue: "UpdateCounterForAppForegroundForNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.refreshNotifications(_:)), name:NSNotification.Name(rawValue: "RefreshNotificationsAPI"), object: nil)
        companiesIntroView.isHidden = false
        //companiesIntroView.setY(568)
        self.cmpniesIntroViewTopCnstrnt.constant = 1000

        self.tblNotification.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tblNotification)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        tblNotification.addSubview(refreshControl)
    }
    
    func setupUI(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1792, 2436, 2688:
                introImage.image = UIImage(named: "NotificationIntroImageX")
            default:
                introImage.image = UIImage(named: "NotificationIntroImage")
            }
        }
    }
    
    func updateCounterForAppForeground(_ notification: Foundation.Notification) {
        
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
    
    @objc func refreshNotifications(_ notification: Foundation.Notification){
        //Take Action on Notification
        getNotifications()
    }
    
    @objc func refresh(_ sender:AnyObject) {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            refreshControl.endRefreshing()
            return
        }
        
        let notifications = WLGetNotifications()
        notifications.getNotifications({(Void, AnyObject) -> Void in
            
            self.inboundObjects.removeAll()
            self.outboundObjects.removeAll()
            self.archivedObject.removeAll()
            
            if let response = AnyObject as? [String : AnyObject] {
                
                if let notifications = response["notifications"] as? [String: AnyObject] {
                    
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
                
                if let outbound = response["outbound"] as? [[String: AnyObject]] {
                    
                    for notification in outbound {
                        
                        let status = notification["status"] as? String ?? ""
                        let contactowner = notification["contactowner"] as? String ?? ""
                        let prospectname = notification["prospectname"] as? String ?? ""
                        let requestID = notification["requestID"] as? Int ?? 0
                        let highlight = notification["highlight"] as? Int ?? 0
                        let contactusername = notification["contactusername"] as? String ?? ""
                        let recipient_read = notification["recipient_read"] as? Int ?? 0
                        let prospectdesignation = notification["prospectdesignation"] as? [String] ?? [""]
                        let prospectcompanyname = notification["prospectcompanyname"] as? [String] ?? [""]
                        let contactcompanyname = notification["contactcompanyname"] as? [String] ?? [""]
                        let contactshortbio = notification["contactshortbio"] as? String ?? ""
                        let contactdesignation = notification["contactdesignation"] as? [String] ?? [""]
                        let category = notification["category"] as? String ?? ""
                        let companiesOffered = notification["companiesofInterest"] as? [AnyObject] ?? ["" as AnyObject]
                        
                        let outBoundObject = OutboundObject(status: status, contactowner: contactowner, prospectname: prospectname, requestID: requestID, highlight: highlight, contactusername: contactusername, recipient_read: recipient_read, prospectdesignation: 0 < prospectdesignation.count ? prospectdesignation[0] : "", prospectcompanyname: 0 < prospectcompanyname.count ? prospectcompanyname[0] : "", contactcompanyname: 0 < contactcompanyname.count ? contactcompanyname[0] : "", contactshortbio: contactshortbio, contactdesignation: 0 < contactdesignation.count ? contactdesignation[0] : "", category: category, companiesOffered: companiesOffered)
                        
                        self.outboundObjects.append(outBoundObject)
                    }
                }
                
                if let inbound = response["inbound"] as? [[String: AnyObject]] {
                    
                    for notification in inbound {
                        let status = notification["status"] as? String ?? ""
                        let requestorname = notification["requestorname"] as? String ?? ""
                        let requestorimage = notification["requestorimage"] as? String ?? ""
                        let requestordesignation = notification["requestordesignation"] as? [String] ?? [""]
                        let requestorcompanyname = notification["requestorcompanyname"] as? [String] ?? [""]
                        let prospectname = notification["prospectname"] as? String ?? ""
                        let prospectdesignation = notification["prospectdesignation"] as? [String] ?? [""]
                        let prospectcompanyname = notification["prospectcompanyname"] as? String ?? ""
                        let requestID = notification["requestID"] as? Int ?? 0
                        let highlight = notification["highlight"] as? Int ?? 0
                        let requestorusername = notification["requestorusername"] as? String ?? ""
                        let requestor_removed = notification["requestor_removed"] as! Bool
                        let category = notification["category"] as? String ?? ""
                        let companiesOffered = notification["companiesofInterest"] as? [AnyObject] ?? ["" as AnyObject]
                        
                        if status == "pending" {
                            
                            if !requestor_removed {
                                
                                let inBoundObject = InboundObject(status: status, requestorname: requestorname, requestorimage: requestorimage, requestordesignation: requestordesignation, requestorcompanyname: requestorcompanyname, prospectname: prospectname, prospectdesignation: prospectdesignation, prospectcompanyname: prospectcompanyname, requestID: requestID, highlight: highlight, requestorusername: requestorusername, category: category, companiesOffered: companiesOffered)
                                self.inboundObjects.append(inBoundObject)
                            }
                        } else {
                            
                            let inBoundObject = InboundObject(status: status, requestorname: requestorname, requestorimage: requestorimage, requestordesignation: requestordesignation, requestorcompanyname: requestorcompanyname, prospectname: prospectname, prospectdesignation: prospectdesignation, prospectcompanyname: prospectcompanyname, requestID: requestID, highlight: highlight, requestorusername: requestorusername, category: category, companiesOffered: companiesOffered)
                            self.inboundObjects.append(inBoundObject)
                        }
                    }
                }
                
                if let archived = response["archived"] as? [[String: AnyObject]] {
                    
                    for notification in archived {
                        
                        let status = notification["status"] as? String ?? ""
                        let contactowner = notification["contactowner"] as? String ?? ""
                        let prospectname = notification["prospectname"] as? String ?? ""
                        let requestID = notification["requestID"] as? Int ?? 0
                        let highlight = notification["highlight"] as? Int ?? 0
                        let contactusername = notification["contactusername"] as? String ?? ""
                        
                        let archivedObj = ArchivedObject(status: status, contactowner: contactowner, prospectname: prospectname, requestID: requestID, highlight: highlight, contactusername:  contactusername)
                        
                        self.archivedObject.append(archivedObj)
                    }
                }
                
                self.tblNotification.reloadData()
                self.refreshControl.endRefreshing()
            }
            
            
            }, errorCallback: {(Void, NSError) -> Void in
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // navigationController!.navigationBar.barTintColor = UIColor(netHex: 0x498CE7)
       // self.companiesIntroView.setY(568)
        self.cmpniesIntroViewTopCnstrnt.constant = 1000
        self.navigationController!.navigationBar.layer.zPosition = 0
        //self.tabBarController?.tabBar.layer.zPosition = 0
         self.tabBarController?.tabBar.isHidden = false
//        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        isFirstTime = UserDefaults.standard.bool(forKey: "NotificationFirstTime")
        if !isFirstTime {
            
            let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(NotificationsViewController.hideMainIntro))
            introImage.isUserInteractionEnabled = true
            introImage.addGestureRecognizer(tapForMainViewImage)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(NotificationsViewController.respondToSwipeGesture(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.introImage.addGestureRecognizer(swipeLeft)
            
            self.navigationController!.navigationBar.layer.zPosition = -1
            // self.tabBarController?.tabBar.layer.zPosition = -1
            self.tabBarController?.tabBar.isHidden = true
            isFirstTime = true
            
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5, options: [], animations:
                {
                    //self.companiesIntroView.setY(0)
                    self.cmpniesIntroViewTopCnstrnt.constant = 0
                    self.introViewOutSide = true
                }, completion: nil)
            UserDefaults.standard.set(true, forKey: "NotificationFirstTime")
        }
        
        getNotifications()
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    @objc func hideMainIntro() {
        
        self.navigationController!.navigationBar.layer.zPosition = 0
        //self.tabBarController?.tabBar.layer.zPosition = 0
       self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.companiesIntroView.setY(568)
                self.cmpniesIntroViewTopCnstrnt.constant = 1000
            }, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case .left:
                
                self.navigationController!.navigationBar.layer.zPosition = 0
                //self.tabBarController?.tabBar.layer.zPosition = 0
                self.tabBarController?.tabBar.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        //self.companiesIntroView.setY(568)
                        self.cmpniesIntroViewTopCnstrnt.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    var newOutboundObjects = [OutboundObject]()
    var newInboundObjects = [InboundObject]()

    func isSameForInBound (_ lhs: InboundObject, rhs: InboundObject) -> Bool {
        return lhs.status == rhs.status
    }
    
    func isSame (_ lhs: OutboundObject, rhs: OutboundObject) -> Bool {
        return lhs.status == rhs.status
    }
    
    func isSameReadStatus (_ lhs: OutboundObject, rhs: OutboundObject) -> Bool {
        return lhs.recipient_read == rhs.recipient_read
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        hidingNavBarManager?.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
//    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        hidingNavBarManager?.shouldScrollToTop()
//
//        return true
//    }
    
    @IBAction func btnCancelCompaniesIntro(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.companiesIntroView.setY(568)
                self.cmpniesIntroViewTopCnstrnt.constant = 1000
            }, completion: {action in
                
                self.navigationController!.navigationBar.layer.zPosition = 0
                //self.tabBarController?.tabBar.layer.zPosition = 0
                self.tabBarController?.tabBar.isHidden = false
        })
    }
    @IBAction func btnQuestionMarkTapped(_ sender: AnyObject) {
        
        if introViewOutSide {
            
            self.navigationController!.navigationBar.layer.zPosition = 0
            //self.tabBarController?.tabBar.layer.zPosition = 0
            self.tabBarController?.tabBar.isHidden = false
            
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5, options: [], animations:
                {
                    
                    //self.companiesIntroView.setY(568)
                    self.cmpniesIntroViewTopCnstrnt.constant = 1000
                }, completion: {action in
                    
                    self.introViewOutSide = false
                    
                    
            })
        } else {
            
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5, options: [], animations:
                {
                   // self.companiesIntroView.setY(0)
                    self.cmpniesIntroViewTopCnstrnt.constant = 0
                }, completion: {action in
                    
                    self.introViewOutSide = true
                    self.navigationController!.navigationBar.layer.zPosition = -1
                   // self.tabBarController?.tabBar.layer.zPosition = -1
                     self.tabBarController?.tabBar.isHidden = true
            })
        }
    }
    
    @objc func getNotifications() {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        loader.showActivityIndicator(self.view)
        let notifications = WLGetNotifications()
        notifications.getNotifications({(Void, AnyObject) -> Void in
            
//            print("API Response: \(AnyObject)")
            
            loader.hideActivityIndicator(self.view)
            
            self.inboundObjects.removeAll()
            self.outboundObjects.removeAll()
            self.archivedObject.removeAll()
            self.newInboundObjects.removeAll()
            self.newOutboundObjects.removeAll()
            
            if let response = AnyObject as? [String : AnyObject] {
                print("response",response)
                if let notifications = response["notifications"] as? [String: AnyObject] {
                    
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
                
                if let outbound = response["outbound"] as? [[String: AnyObject]] {
                    
                    for notification in outbound {
                        
                        let status = notification["status"] as? String ?? ""
                        let contactowner = notification["contactowner"] as? String ?? ""
                        let prospectname = notification["prospectname"] as? String ?? "N/A"
                        let requestID = notification["requestID"] as? Int ?? 0
                        let highlight = notification["highlight"] as? Int ?? 0
                        let contactusername = notification["contactusername"] as? String ?? ""
                        let recipient_read = notification["recipient_read"] as? Int ?? 0
                        let prospectdesignation = notification["prospectdesignation"] as? [String] ?? [""]
                        let prospectcompanyname = notification["prospectcompanyname"] as? [String] ?? [""]
                        let contactcompanyname = notification["contactcompanyname"] as? [String] ?? [""]
                        let contactshortbio = notification["contactshortbio"] as? String ?? ""
                        let contactdesignation = notification["contactdesignation"] as? [String] ?? [""]
                        let category = notification["category"] as? String ?? ""
                        let companiesOffered = notification["companiesofInterest"] as? [AnyObject] ?? ["" as AnyObject]
                        
                        let outBoundObject = OutboundObject(status: status, contactowner: contactowner, prospectname: prospectname, requestID: requestID, highlight: highlight, contactusername: contactusername, recipient_read: recipient_read, prospectdesignation: 0 < prospectdesignation.count ? prospectdesignation[0] : "", prospectcompanyname: 0 < prospectcompanyname.count ? prospectcompanyname[0] : "", contactcompanyname: 0 < contactcompanyname.count ? contactcompanyname[0] : "", contactshortbio: contactshortbio, contactdesignation: 0 < contactdesignation.count ? contactdesignation[0] : "", category: category, companiesOffered: companiesOffered)
                        
                        self.outboundObjects.append(outBoundObject)
                    }
                }
                
                if let inbound = response["inbound"] as? [[String: AnyObject]] {
                    
                    for notification in inbound {
                        
                        let status = notification["status"] as? String ?? ""
                        let requestorname = notification["requestorname"] as? String ?? ""
                        let requestorimage = notification["requestorimage"] as? String ?? ""
                        let requestordesignation = notification["requestordesignation"] as? [String] ?? [""]
                        let requestorcompanyname = notification["requestorcompanyname"] as? [String] ?? [""]
                        let prospectname = notification["prospectname"] as? String ?? ""
                        let prospectdesignation = notification["prospectdesignation"] as? [String] ?? [""]
                        let prospectcompanyname = notification["prospectcompanyname"] as? String ?? "N/A"
                        let requestID = notification["requestID"] as? Int ?? 0
                        let highlight = notification["highlight"] as? Int ?? 0
                        let requestorusername = notification["requestorusername"] as? String ?? ""
                        let requestor_removed = notification["requestor_removed"] as! Bool
                        let category = notification["category"] as? String ?? ""
                        let companiesOffered = notification["companiesofInterest"] as? [AnyObject] ?? ["" as AnyObject]
                        
                        if status == "pending" {
                            
                            if !requestor_removed {
                                
                                let inBoundObject = InboundObject(status: status, requestorname: requestorname, requestorimage: requestorimage, requestordesignation: requestordesignation, requestorcompanyname: requestorcompanyname, prospectname: prospectname, prospectdesignation: prospectdesignation, prospectcompanyname: prospectcompanyname, requestID: requestID, highlight: highlight, requestorusername: requestorusername,category: category, companiesOffered: companiesOffered)
                                self.inboundObjects.append(inBoundObject)
                            }
                        } else {
                            
                            let inBoundObject = InboundObject(status: status, requestorname: requestorname, requestorimage: requestorimage, requestordesignation: requestordesignation, requestorcompanyname: requestorcompanyname, prospectname: prospectname, prospectdesignation: prospectdesignation, prospectcompanyname: prospectcompanyname, requestID: requestID, highlight: highlight, requestorusername: requestorusername, category: category, companiesOffered: companiesOffered)
                            self.inboundObjects.append(inBoundObject)
                        }
                    }
                }
                
                if let archived = response["archived"] as? [[String: AnyObject]] {
                    
                    for notification in archived {
                        
                        let status = notification["status"] as? String ?? ""
                        let contactowner = notification["contactowner"] as? String ?? ""
                        let prospectname = notification["prospectname"] as? String ?? "N/A"
                        let requestID = notification["requestID"] as? Int ?? 0
                        let highlight = notification["highlight"] as? Int ?? 0
                        let contactusername = notification["contactusername"] as? String ?? ""
                        
                        let archivedObj = ArchivedObject(status: status, contactowner: contactowner, prospectname: prospectname, requestID: requestID, highlight: highlight, contactusername:  contactusername)
                        
                        self.archivedObject.append(archivedObj)
                    }
                }
                
                if requestIDGlobal.length > 0 {
                    
                    for notificationObject in self.inboundObjects {
                        
                        let ID = "\(notificationObject.requestID!)"
                        
                        if requestIDGlobal == ID {
                            
                            requestIDGlobal = ""
                            let selectedIncommingRequest = notificationObject
                            
                            if selectedIncommingRequest.category == "match" {
                                
                                let incommigRequestDetailViewForMemberMatching = self.storyboard?.instantiateViewController(withIdentifier: "IncommingNotificationDetailForMemberMatchingViewController") as! IncommingNotificationDetailForMemberMatchingViewController
                                incommigRequestDetailViewForMemberMatching.inboundObject = notificationObject
                                incommigRequestDetailViewForMemberMatching.selectedRequestID = selectedIncommingRequest.requestID!
                                self.navigationController?.pushViewController(incommigRequestDetailViewForMemberMatching, animated: true)
                                
                            } else {
                                
                                let incommigRequestDetailView = self.storyboard?.instantiateViewController(withIdentifier: "incomming") as! IncomingRequestDetailViewController
                                incommigRequestDetailView.inboundObject = notificationObject
                                incommigRequestDetailView.selectedRequestID = selectedIncommingRequest.requestID!
                                self.navigationController?.pushViewController(incommigRequestDetailView, animated: true)
                            }
                        }
                    }
                    
                    for notificationObject in self.outboundObjects {
                        
                        let ID = "\(notificationObject.requestID!)"
                        
                        if requestIDGlobal == ID {
                            
                            requestIDGlobal = ""
                            let object = notificationObject
                            if object.category == "match" {
                                
                                let outGoingRequestDetailView = self.storyboard?.instantiateViewController(withIdentifier: "outGoing") as! OutGoingViewController
                                outGoingRequestDetailView.outboundObject = notificationObject
                                outGoingRequestDetailView.selectedRequestID = notificationObject.requestID!
                                outGoingRequestDetailView.isArchived = false
                                outGoingRequestDetailView.isMemberMatch = true
                                self.navigationController?.pushViewController(outGoingRequestDetailView, animated: true)
                                
                            } else {
                                
                                let outGoingRequestDetailView = self.storyboard?.instantiateViewController(withIdentifier: "outGoing") as! OutGoingViewController
                                outGoingRequestDetailView.outboundObject = notificationObject
                                outGoingRequestDetailView.selectedRequestID = notificationObject.requestID!
                                outGoingRequestDetailView.isArchived = false
                                self.navigationController?.pushViewController(outGoingRequestDetailView, animated: true)
                            }
                        }
                    }
                    self.tblNotification.reloadData()
                    return
                } else {
                    
                    self.tblNotification.reloadData()
                }
            }
            
            
            }, errorCallback: {(Void, NSError) -> Void in
        
                loader.hideActivityIndicator(self.view)
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationOutGoingCell") as! NotificationOutGoingCell
            cell.selectionStyle = .none
            
            cell.lblProspectDesignation.isHidden = false
            cell.lblProspectCompanyName.isHidden = false
            cell.lblContactOwnerDetail.isHidden = false
            cell.lblContactCompany.isHidden = false
            cell.lblContactTitle.isHidden = false
            
            cell.imgContactPerson.makeThisRound
            var defaultImage = UIImage(named: "PersonLogo")
            //     let roundImage = defaultImage.image
            cell.imgContactPerson.image = defaultImage
            
            let object = outboundObjects[indexPath.row]
            
            if object.category == "match" {
                
                cell.lblOuGoingProspectName.setY(17)
                
                if object.recipient_read == 0 {
                    
                    cell.lblOutGoinghOwner.font = UIFont(name: "Gotham-Bold", size: cell.lblOutGoinghOwner.font.pointSize)
                    cell.lblOutGoinghOwner.textColor = UIColor(netHex: 0x5A9EEC)
                    
                } else {
                    
                    cell.lblOutGoinghOwner.font = UIFont(name: "Gotham-Book", size: cell.lblOutGoinghOwner.font.pointSize)
                    cell.lblOutGoinghOwner.textColor = UIColor(netHex: 0x464B4B)
                    
                }
                cell.lblOuGoingProspectName.textColor = UIColor(netHex: 0x464B4B)
                cell.lblProspectDesignation.textColor = UIColor(netHex: 0x464B4B)
                cell.lblProspectDesignation.font = UIFont(name: "Gotham-Book", size: cell.lblOuGoingProspectName.font.pointSize)
                cell.lblProspectCompanyName.textColor = UIColor(netHex: 0x464B4B)
                cell.lblProspectCompanyName.font = UIFont(name: "Gotham-Book", size: cell.lblOuGoingProspectName.font.pointSize)
                
                switch object.companiesOffered!.count {
                case 3:
                    
                    for i in 0..<object.companiesOffered!.count {
                        
                        let company = object.companiesOffered![i] as? [AnyObject]
                        
                        switch i {
                            
                        case 0:
                            
                            cell.lblOuGoingProspectName.text = company![0] as? String ?? ""
                            
                        case 1:
                            
                            cell.lblProspectDesignation.text = company![0] as? String ?? ""
                            
                        case 2:
                            
                            cell.lblProspectCompanyName.text = company![0] as? String ?? ""
                            
                        default:
                            break
                        }
                    }
                    
                case 2:
                    
                    for i in 0..<object.companiesOffered!.count {
                        
                        let company = object.companiesOffered![i] as? [AnyObject]
                        
                        switch i {
                        case 0:
                            
                            cell.lblOuGoingProspectName.text = company![0] as? String ?? ""
                            
                        case 1:
                            
                            cell.lblProspectDesignation.text = company![0] as? String ?? ""
                            
                        default:
                            
                            cell.lblProspectCompanyName.text = ""
                        }
                    }
                    
                case 1:
                    
                    for i in 0..<object.companiesOffered!.count {
                        
                        let company = object.companiesOffered![i] as? [AnyObject]
                        print(company)
                        
                        switch i {
                        case 0:
                            
                            cell.lblOuGoingProspectName.text = company![0] as? String ?? ""
                            
                        default:
                            
                            cell.lblProspectCompanyName.text = ""
                            cell.lblProspectDesignation.text = ""
                        }
                    }
                    
                default:
                    
                    for i in 0..<object.companiesOffered!.count {
                        
                        let company = object.companiesOffered![i] as? [AnyObject]
                        print(company)
                        
                        switch i {
                        case 0:
                            
                            cell.lblOuGoingProspectName.text = company![0] as? String ?? ""
                            
                        case 1:
                            
                            cell.lblProspectDesignation.text = company![0] as? String ?? ""
                            
                        case 2:
                            
                            cell.lblProspectCompanyName.text = "..."
                            
                        default:
                            break
                        }
                    }
                }
                
            } else {
                
                cell.lblOuGoingProspectName.setY(11)
                
                cell.lblOuGoingProspectName.text = object.prospectname
                cell.lblProspectCompanyName.text = object.prospectcompanyname
                cell.lblProspectDesignation.text = object.prospectdesignation
                
                if object.recipient_read == 0 {
                    
                    cell.lblOutGoinghOwner.font = UIFont(name: "Gotham-Bold", size: cell.lblOutGoinghOwner.font.pointSize)
                    cell.lblOutGoinghOwner.textColor = UIColor(netHex: 0x5A9EEC)
                    cell.lblOuGoingProspectName.textColor = UIColor(netHex: 0x5A9EEC)
                    
                } else {
                    
                    cell.lblOutGoinghOwner.font = UIFont(name: "Gotham-Book", size: cell.lblOutGoinghOwner.font.pointSize)
                    cell.lblOutGoinghOwner.textColor = UIColor(netHex: 0x464B4B)
                    cell.lblOuGoingProspectName.textColor = UIColor(netHex: 0x464B4B)
                }
            }
            
            switch object.status! {
                
            case "accepted" :
                
                cell.lblOutGoinghOwner.text = object.contactowner
                cell.btnOutGoingStatus.setImage(UIImage(named: "RequestAccepted"), for: UIControl.State())
                cell.lblContactOwnerDetail.isHidden = true
                cell.lblContactTitle.isHidden = false
                cell.lblContactCompany.isHidden = false
                cell.lblContactCompany.text = object.contactcompanyname
                cell.lblContactTitle.text = object.contactdesignation
                
            case "declined":
                
                cell.lblOutGoinghOwner.text = object.contactusername
                cell.btnOutGoingStatus.setImage(UIImage(named: "RequestCancelled"), for: UIControl.State())
                cell.lblContactOwnerDetail.text = object.contactshortbio
                cell.lblContactOwnerDetail.isHidden = false
                cell.lblContactTitle.isHidden = true
                cell.lblContactCompany.isHidden = true
                
                
            case "pending":
                
                cell.lblOutGoinghOwner.text = object.contactusername
                cell.lblContactOwnerDetail.text = object.contactshortbio
                cell.lblContactOwnerDetail.isHidden = false
                cell.lblContactTitle.isHidden = true
                cell.lblContactCompany.isHidden = true
                if object.recipient_read == 0 {
                    
                    cell.btnOutGoingStatus.setImage(UIImage(named: "HighlitedPending"), for: UIControl.State())
                } else {
                    
                    cell.btnOutGoingStatus.setImage(UIImage(named: "StatusPending"), for: UIControl.State())
                }
                
                
            default:
                
                break
                
            }
            
            return cell
            
        } else {
            
            if indexPath.section == 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
                
                let object = inboundObjects[indexPath.row]
                
                if object.category == "match" {
                    
                    
                    cell.lblProspectName.setY(6)
                    
                    if object.highlight == 1 {
                        
                        cell.lblRequesterName.font = UIFont(name: "Gotham-Bold", size: cell.lblRequesterName.font.pointSize)
                        cell.lblRequesterName.textColor = UIColor(netHex: 0x5A9EEC)
                        
                    } else {
                        
                        cell.lblRequesterName.font = UIFont(name: "Gotham-Book", size: cell.lblRequesterName.font.pointSize)
                        cell.lblRequesterName.textColor = UIColor(netHex: 0x464B4B)
                    }
                    
                    cell.lblProspectName.textColor = UIColor(netHex: 0x464B4B)
                    cell.lblProspectPosition.textColor = UIColor(netHex: 0x464B4B)
                    cell.lblProspectPosition.font = UIFont(name: "Gotham-Book", size: cell.lblProspectName.font.pointSize)
                    cell.lblProspectAddress.textColor = UIColor(netHex: 0x464B4B)
                    cell.lblProspectAddress.font = UIFont(name: "Gotham-Book", size: cell.lblProspectName.font.pointSize)
                    
                    switch object.companiesOffered!.count {
                        
                    case 3:
                        
                        for i in 0..<object.companiesOffered!.count {
                            
                            let company = object.companiesOffered![i] as? [AnyObject]
                            
                            switch i {
                            case 0:
                                
                                cell.lblProspectName.text = company![0] as? String ?? ""
                                
                            case 1:
                                
                                cell.lblProspectPosition.text = company![0] as? String ?? ""
                                
                            case 2:
                                
                                cell.lblProspectAddress.text = company![0] as? String ?? ""
                                
                            default:
                                break
                            }
                        }
                        
                    case 2:
                        
                        for i in 0..<object.companiesOffered!.count {
                            
                            let company = object.companiesOffered![i] as? [AnyObject]
                            
                            switch i {
                            case 0:
                                
                                cell.lblProspectName.text = company![0] as? String ?? ""
                                
                            case 1:
                                
                                cell.lblProspectPosition.text = company![0] as? String ?? ""
                                
                            default:
                                
                                cell.lblProspectAddress.text = ""
                            }
                        }
                        
                    case 1:
                        
                        for i in 0..<object.companiesOffered!.count {
                            
                            let company = object.companiesOffered![i] as? [AnyObject]
                            print(company)
                            
                            switch i {
                            case 0:
                                
                                cell.lblProspectName.text = company![0] as? String ?? ""
                                
                            default:
                                
                                cell.lblProspectPosition.text = ""
                                cell.lblProspectAddress.text = ""
                            }
                        }
                        
                    default:
                        
                        for i in 0..<object.companiesOffered!.count {
                            
                            let company = object.companiesOffered![i] as? [AnyObject]
                            
                            switch i {
                            case 0:
                                
                                cell.lblProspectName.text = company![0] as? String ?? ""
                                
                            case 1:
                                
                                cell.lblProspectPosition.text = company![0] as? String ?? ""
                                
                            case 2:
                                
                                cell.lblProspectAddress.text = "..."
                                
                            default:
                                break
                            }
                        }
                    }
                } else {
                    
                    cell.lblProspectName.setY(6)
                    
                    cell.lblProspectName.text = object.prospectname
                    
                    if object.highlight == 1 {
                        
                        cell.lblRequesterName.font = UIFont(name: "Gotham-Bold", size: cell.lblRequesterName.font.pointSize)
                        cell.lblRequesterName.textColor = UIColor(netHex: 0x5A9EEC)
                        cell.lblProspectName.textColor = UIColor(netHex: 0x5A9EEC)
                        
                    } else {
                        
                        cell.lblRequesterName.font = UIFont(name: "Gotham-Book", size: cell.lblRequesterName.font.pointSize)
                        cell.lblRequesterName.textColor = UIColor(netHex: 0x464B4B)
                        cell.lblProspectName.textColor = UIColor(netHex: 0x464B4B)
                    }
                    
                    if object.prospectdesignation?.count > 0 {
                        cell.lblProspectPosition.text = object.prospectdesignation![0]
                    } else {
                        cell.lblProspectPosition.text = ""
                    }
                    
                    cell.lblProspectAddress.text = object.prospectcompanyname!
                }
                
                cell.selectionStyle = .none
                
                cell.btnStatus.isHidden = false
                cell.lblRequesterName.text = object.requestorname
                if object.requestordesignation?.count > 0 {
                    cell.lblRequsterPosition.text = object.requestordesignation![0]
                } else {
                    cell.lblRequsterPosition.text = ""
                }
                
                if object.requestorcompanyname?.count > 0 {
                    cell.lblRequesterAddress.text = object.requestorcompanyname![0]
                } else {
                    cell.lblRequesterAddress.text = ""
                }
                
                cell.imgRequesterName.makeThisRound
                
                if object.requestorimage?.length > 0 {
                    cell.imgRequesterName.hnk_setImageFromURL(URL(string:  WLAppSettings.getBaseUrl() + "/" + object.requestorimage!)!)
                } else {
                    cell.imgRequesterName.image = UIImage(named: "PersonLogo")
                }
                
                switch object.status! {
                    
                case "accepted" :
                    
                    cell.btnStatus.setImage(UIImage(named: "RequestAccepted"), for: UIControl.State())
                    
                case "declined":
                    
                    cell.btnStatus.setImage(UIImage(named: "RequestCancelled"), for: UIControl.State())
                    
                case "pending":
                    
                    
                    if object.highlight == 1 {
                        
                        cell.btnStatus.setImage(UIImage(named: "HighlitedPending"), for: UIControl.State())
                    } else {
                        
                        cell.btnStatus.setImage(UIImage(named: "StatusPending"), for: UIControl.State())
                    }
                    
                    
                default:
                    
                    break
                    
                }
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationOutGoingCell") as! NotificationOutGoingCell
                cell.selectionStyle = .none
                
                let object = archivedObject[indexPath.row]
                
                cell.lblOutGoinghOwner.text = object.contactowner
                cell.lblOuGoingProspectName.text = object.prospectname
                cell.lblProspectDesignation.text = ""
                cell.lblProspectCompanyName.text = ""
                cell.lblContactOwnerDetail.text = ""
                cell.lblContactCompany.text = ""
                
                cell.lblProspectDesignation.isHidden = true
                cell.lblProspectCompanyName.isHidden = true
                cell.lblContactOwnerDetail.isHidden = true
                cell.lblContactCompany.isHidden = true
                cell.lblContactTitle.isHidden = true
                
                switch object.status! {
                    
                case "accepted" :
                    
                    cell.lblOutGoinghOwner.text = object.contactowner
                    cell.btnOutGoingStatus.setImage(UIImage(named: "RequestAccepted"), for: UIControl.State())
                    
                case "declined":
                    
                    cell.lblOutGoinghOwner.text = object.contactusername
                    cell.btnOutGoingStatus.setImage(UIImage(named: "RequestCancelled"), for: UIControl.State())
                    
                case "pending":
                    
                    cell.lblOutGoinghOwner.text = object.contactusername
                    if object.highlight == 1 {
                        
                        cell.btnOutGoingStatus.setImage(UIImage(named: "HighlitedPending"), for: UIControl.State())
                    } else {
                        
                        cell.btnOutGoingStatus.setImage(UIImage(named: "StatusPending"), for: UIControl.State())
                    }
                    
                    
                default:
                    
                    break
                    
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        switch indexPath.section {
            
        case 0:
            
            let notificationObject = self.outboundObjects[indexPath.row]
            
            switch notificationObject.status! {
                
                case "accepted", "declined":
                
                    let archivedAction = UITableViewRowAction(style: .normal, title: "Archive") {action, index in
                        
                        if !rechability.isConnectedToNetwork() {
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        loader.showActivityIndicator(self.view)
                        let notificationAction = WLNotificationAction()
                        notificationAction.notificationID = notificationObject.requestID!
                        notificationAction.notificatioAction = "archive"
                        notificationAction.performNotificationAction({(Void, Any) -> Void in
                            
                            loader.hideActivityIndicator(self.view)
                            
                            self.getNotifications()
                            Mixpanel.sharedInstance()?.track("Request Archived", properties:nil)
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                loader.hideActivityIndicator(self.view)
                                
                                self.getNotifications()
                                print(NSError)
                        })
                    }
                    
                    archivedAction.backgroundColor = UIColor(netHex: 0x4076BA)
                    
                    return [archivedAction]
                
                case "pending":
                    
                    let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") {action, index in
                        
                        if !rechability.isConnectedToNetwork() {
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        loader.showActivityIndicator(self.view)
                        let notificationAction = WLNotificationAction()
                        notificationAction.notificationID = notificationObject.requestID!
                        notificationAction.notificatioAction = "delete"
                        notificationAction.performNotificationAction({(Void, Any) -> Void in
                            
                            loader.hideActivityIndicator(self.view)
                            
                            self.getNotifications()
                            Mixpanel.sharedInstance()?.track("Request Deleted", properties:nil)
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                loader.hideActivityIndicator(self.view)
                                
                                self.getNotifications()
                                print(NSError)
                        })
                    }
                    
                    deleteAction.backgroundColor = UIColor(patternImage: UIImage(named: "topArchive")!)
                    
                    return [deleteAction]
                
                default:
                
                    break
            }
            
        case 1:
            
            let notificationObject = self.inboundObjects[indexPath.row]
            
            switch notificationObject.status! {
                
                case "accepted", "declined":
                
                    let archivedAction = UITableViewRowAction(style: .normal, title: "Archive") {action, index in
                        
                        if !rechability.isConnectedToNetwork() {
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        let selectedIncommingRequest = self.inboundObjects[indexPath.row]
                        
                        loader.showActivityIndicator(self.view)
                        let notificationAction = WLNotificationAction()
                        notificationAction.notificationID = selectedIncommingRequest.requestID!
                        notificationAction.notificatioAction = "archive"
                        notificationAction.performNotificationAction({(Void, Any) -> Void in
                            
                            loader.hideActivityIndicator(self.view)
                            
                            self.getNotifications()
                            Mixpanel.sharedInstance()?.track("Request Archived", properties:nil)
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                loader.hideActivityIndicator(self.view)
                                
                                self.getNotifications()
                                print(NSError)
                        })
                    }
                    
                    archivedAction.backgroundColor = UIColor(netHex: 0x4076BA)
                
                    return [archivedAction]
                
                case "pending":
                
                    let acceptAction = UITableViewRowAction(style: .normal, title: "        ") {action, index in
                        
                        if !rechability.isConnectedToNetwork() {
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        let selectedIncommingRequest = self.inboundObjects[indexPath.row]
                        
                        loader.showActivityIndicator(self.view)
                        let notificationAction = WLNotificationAction()
                        notificationAction.notificationID = selectedIncommingRequest.requestID!
                        notificationAction.notificatioAction = "accept"
                        notificationAction.performNotificationAction({(Void, Any) -> Void in
                            
                            loader.hideActivityIndicator(self.view)
                            self.getNotifications()
                            Mixpanel.sharedInstance()?.track("Request Accepted", properties:nil)
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                loader.hideActivityIndicator(self.view)
                                
                                self.getNotifications()
                                print(NSError)
                        })
                    }
                    
                    acceptAction.backgroundColor = UIColor(patternImage: UIImage(named: "Accept")!)
                    
                    
                    let blockAction = UITableViewRowAction(style: .default, title: "        ") {action, index  in
                        
//                        if !rechability.isConnectedToNetwork() {
//                            return
//                        }
//                        
//                        let selectedIncommingRequest = self.inboundObjects[indexPath.row]
//                        
//                        loader.showActivityIndicator(self.view)
//                        let notificationAction = WLNotificationAction()
//                        notificationAction.notificationID = selectedIncommingRequest.requestID!
//                        notificationAction.notificatioAction = "decline"
//                        notificationAction.performNotificationAction({(Void, Any) -> Void in
//                            
//                            loader.hideActivityIndicator(self.view)
//                            self.getNotifications()
//                            
//                            }, errorCallback: {(Void, NSError) -> Void in
//                                
//                                loader.hideActivityIndicator(self.view)
//                                print(NSError)
//                        })
                        
                    }
                    
                    blockAction.backgroundColor = UIColor(patternImage: UIImage(named: "Block")!)
                    
                    
                    let declineAction = UITableViewRowAction(style: .default, title: "        ") {action, index in
                        
                        
                        if !rechability.isConnectedToNetwork() {
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        let selectedIncommingRequest = self.inboundObjects[indexPath.row]
                        
                        loader.showActivityIndicator(self.view)
                        let notificationAction = WLNotificationAction()
                        notificationAction.notificationID = selectedIncommingRequest.requestID!
                        notificationAction.notificatioAction = "decline"
                        notificationAction.performNotificationAction({(Void, Any) -> Void in
                            
                            loader.hideActivityIndicator(self.view)
                            
                            self.getNotifications()
                            Mixpanel.sharedInstance()?.track("Request Declined", properties:nil)
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                loader.hideActivityIndicator(self.view)
                                
                                self.getNotifications()
                                print(NSError)
                        })
                        
                    }
                    
                    declineAction.backgroundColor = UIColor(patternImage: UIImage(named: "Decline")!)
                    
                    return [blockAction,declineAction,acceptAction]
                
                default:
                
                    break
            }
            
        case 2:
            
            let notificationObject = self.archivedObject[indexPath.row]
            
            let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") {action, index in
                
                if !rechability.isConnectedToNetwork() {
                    TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                    return
                }
                
                loader.showActivityIndicator(self.view)
                let notificationAction = WLNotificationAction()
                notificationAction.notificationID = notificationObject.requestID!
                notificationAction.notificatioAction = "delete"
                notificationAction.performNotificationAction({(Void, Any) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    self.getNotifications()
                    Mixpanel.sharedInstance()?.track("Request Deleted", properties:nil)
                    
                    }, errorCallback: {(Void, NSError) -> Void in
                        
                        loader.hideActivityIndicator(self.view)
                        
                        self.getNotifications()
                        print(NSError)
                })
            }
            
            deleteAction.backgroundColor = UIColor(patternImage: UIImage(named: "topArchive")!)
            
            return [deleteAction]
            
        default:
            
            return [UITableViewRowAction()]
        }
        
        return [UITableViewRowAction()]
    }
    
    func heightNeededForText(_ text :NSString , font : UIFont , width: CGFloat, sizeFont: CGFloat,lineBreakMode : NSLineBreakMode)->CGFloat {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        let sizeText : CGSize = text.boundingRect(with: CGSize(width: width, height: 10000), options:NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        return sizeText.height

    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else if indexPath.section == 1 {
            return 80
        } else {
            
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        // remove bottom extra 20px space.
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if section == 0 {
            return outboundObjects.count
        } else if section == 1 {
            return inboundObjects.count
        } else if section == 2 {
            return archivedObject.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            
            let object = outboundObjects[indexPath.row]
            if object.category == "match" {
                
                let outGoingRequestDetailView = self.storyboard?.instantiateViewController(withIdentifier: "outGoing") as! OutGoingViewController
                outGoingRequestDetailView.outboundObject = outboundObjects[indexPath.row]
                outGoingRequestDetailView.selectedRequestID = outboundObjects[indexPath.row].requestID!
                outGoingRequestDetailView.isArchived = false
                outGoingRequestDetailView.isMemberMatch = true
                self.navigationController?.pushViewController(outGoingRequestDetailView, animated: true)
                
            } else {
                
                let outGoingRequestDetailView = self.storyboard?.instantiateViewController(withIdentifier: "outGoing") as! OutGoingViewController
                outGoingRequestDetailView.outboundObject = outboundObjects[indexPath.row]
                outGoingRequestDetailView.selectedRequestID = outboundObjects[indexPath.row].requestID!
                outGoingRequestDetailView.isArchived = false
                self.navigationController?.pushViewController(outGoingRequestDetailView, animated: true)
            }
            
        case 1:
            
            let selectedIncommingRequest = inboundObjects[indexPath.row]
            
            if selectedIncommingRequest.category == "match" {
                
                let incommigRequestDetailViewForMemberMatching = self.storyboard?.instantiateViewController(withIdentifier: "IncommingNotificationDetailForMemberMatchingViewController") as! IncommingNotificationDetailForMemberMatchingViewController
                incommigRequestDetailViewForMemberMatching.inboundObject = inboundObjects[indexPath.row]
                incommigRequestDetailViewForMemberMatching.selectedRequestID = selectedIncommingRequest.requestID!
                self.navigationController?.pushViewController(incommigRequestDetailViewForMemberMatching, animated: true)
                
            } else {
                
                let incommigRequestDetailView = self.storyboard?.instantiateViewController(withIdentifier: "incomming") as! IncomingRequestDetailViewController
                incommigRequestDetailView.inboundObject = inboundObjects[indexPath.row]
                incommigRequestDetailView.selectedRequestID = selectedIncommingRequest.requestID!
                self.navigationController?.pushViewController(incommigRequestDetailView, animated: true)
            }
        case 2:
            let outGoingRequestDetailView = self.storyboard?.instantiateViewController(withIdentifier: "outGoing") as! OutGoingViewController
            outGoingRequestDetailView.archivedObject = archivedObject[indexPath.row]
            outGoingRequestDetailView.selectedRequestID = archivedObject[indexPath.row].requestID!
            outGoingRequestDetailView.isArchived = true
            self.navigationController?.pushViewController(outGoingRequestDetailView, animated: true)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
             return self.outgoingHeader
        } else if section == 1 {
            return incomingHeader
        } else{
            return archievedHeader
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
           return 35
            
        } else {
            return 60
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
