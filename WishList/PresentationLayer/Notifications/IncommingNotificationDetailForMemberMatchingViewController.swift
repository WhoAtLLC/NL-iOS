//
//  IncommingNotificationDetailForMemberMatchingViewController.swift
//  WishList
//
//  Created by Dharmesh on 14/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel


class IncommingNotificationDetailForMemberMatchingViewController: UIViewController, TSMessageViewProtocol, UITextViewDelegate {
    
    @IBOutlet weak var txtHow: UITextView!
    @IBOutlet weak var txtWhy: UITextView!
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var lblRequester: UILabel!
    @IBOutlet weak var lblLeadsTitle: UILabel!
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmationViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtComment: KMPlaceholderTextView!
    @IBOutlet weak var lblConform: UILabel!
    @IBOutlet weak var btnConform: UIButton!
    
    @IBOutlet weak var btnDeclined: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileSubView: UIView!
    
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblProfileType: UIView!
    
    @IBOutlet weak var whyTitle: UILabel!
    @IBOutlet weak var howTitle: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var businessCommentView: UIView!
    @IBOutlet weak var imgBusinessCommentBG: UIImageView!
    @IBOutlet weak var txtCommentOfRequest: UITextView!
    
    @IBOutlet weak var btnReason: UIButton!
    @IBOutlet weak var btnCompanies: UIButton!
    @IBOutlet weak var btnMutualContact: UIButton!
    
    @IBOutlet weak var companiesView: UIView!
    @IBOutlet weak var tblCompaniesView: UITableView!
    @IBOutlet weak var lblCompaniesUserCanHelp: UILabel!
    
    @IBOutlet weak var mutualContactView: UIView!
    @IBOutlet weak var tblMutualContact: UITableView!
    
    @IBOutlet weak var txtFullBio: UITextView!
    @IBOutlet weak var txtWhatIWantToDiscuss: UITextView!
    @IBOutlet weak var lblContact: UILabel!
    
    var inboundObject: InboundObject?
    var selectedRequestID = 0
    
    var companiesOfIntrust = [String]()
    var companiesImages = [String]()
    var footerView = UIView()
    var nextURLForTheirRequest = ""
    var theirWishListForUser = [MyWishListForUserObject]()
    var connectionObjects = [MutualConnectionObject]()
    var nextMutualContactURL = ""
    let connections = WLConnection()
    let getTheirWishListForUser = WLGetTheirWishListForUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblCompaniesView.delegate = self
        tblCompaniesView.dataSource = self
        
        tblMutualContact.delegate = self
        tblMutualContact.dataSource = self
        
        tblCompanies.delegate = self
        tblCompanies.dataSource = self
        
        
        btnReason.isSelected = true
        tblCompaniesView.separatorStyle = .none
        tblMutualContact.separatorStyle = .none
        
        scrollView.isHidden = false
        companiesView.isHidden = true
        mutualContactView.isHidden = true
        
        txtWhatIWantToDiscuss.isEditable = false
        txtFullBio.isEditable = false
        
        self.tblCompanies.separatorStyle = .none
        let fullNameArr = inboundObject!.requestorname!.characters.split{$0 == " "}.map(String.init)
        
        whyTitle.text = "Why \(fullNameArr[0]) wants to meet you"
        howTitle.text = "How \(fullNameArr[0]) can help you in return"
        
        if inboundObject?.requestorname?.characters.count > 0 {
            
            lblLeadsTitle.text = "Companies \(fullNameArr[0]) can introduce you to"//"Companies \(fullNameArr[0]) wants to meet"
            lblCompaniesUserCanHelp.text = "Companies \(fullNameArr[0]) wants to meet"
        }
        
        self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
        self.imgProfilePicture.clipsToBounds = true
        self.imgProfilePicture.layer.borderWidth = 2
        self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
        
        profileSubView.layer.cornerRadius = 10.0
        profileSubView.clipsToBounds = true
        
        if inboundObject?.status == "accepted" || inboundObject?.status == "declined"{
            
            btnDeclined.isHidden = true
            btnAccept.isHidden = true
        }
        
        if inboundObject?.status == "accepted" {
            
            lblContact.text = "Contact"
            
        } else if inboundObject?.status == "declined" {
            
            lblContact.text = "Profile"
        } else {
            
            lblContact.text = "Contact"
        }
        initFooterView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        getRequestDetail(selectedRequestID)
        lblRequester.text = inboundObject?.requestorname
        
        confirmationView.backgroundColor = UIColor.clear.withAlphaComponent(0.82)
        txtComment.delegate = self
        txtComment.returnKeyType = UIReturnKeyType.done
        
        scrollView.contentSize = CGSize(width: 320, height: 650)
        
        if inboundObject?.status == "accepted" {
            imgBusinessCommentBG.image = UIImage(named: "AcceptedReqCommentBG")
        } else if inboundObject?.status == "declined" {
            
            imgBusinessCommentBG.image = UIImage(named: "DeclinedCommentBG")
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
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
        switch sender.currentTitle! {
        case "Reason":
            
            btnReason.isSelected = true
            btnCompanies.isSelected = false
            btnMutualContact.isSelected = false
            
            scrollView.isHidden = false
            companiesView.isHidden = true
            mutualContactView.isHidden = true
            
        case "Companies":
            
            btnReason.isSelected = false
            btnCompanies.isSelected = true
            btnMutualContact.isSelected = false
            
            scrollView.isHidden = true
            companiesView.isHidden = false
            mutualContactView.isHidden = true
            
            if theirWishListForUser.count == 0 {
                getTheirWishList()
            }
            
        case "Mutual Contacts":
            
            btnReason.isSelected = false
            btnCompanies.isSelected = false
            btnMutualContact.isSelected = true
            
            scrollView.isHidden = true
            companiesView.isHidden = true
            mutualContactView.isHidden = false
            
            if mutualContactsArray.count == 0 {
                
                getMutualContacts()
            }
            
        default:
            
            break
        }
    }
    
    func getTheirWishList() {
        
        loader.showActivityIndicator(self.view)
        getTheirWishListForUser.handle = inboundObject!.requestorusername!
        getTheirWishListForUser.getTheirWishListForUser({(Void, AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            if let response = AnyObject as? [String: AnyObject] {
                
                self.nextURLForTheirRequest = response["next"] as? String ?? ""
                
                if let results = response["results"] as? [[String: AnyObject]] {
                    
                    for company in results {
                        
                        let id = company["id"] as? Int ?? 0
                        let title = company["title"] as? String ?? ""
                        let mutual = company["mutual"] as? Int ?? 0
                        let leads = company["leads"] as? Int ?? 0
                        
                        let compObj = MyWishListForUserObject(id: id, mutual: mutual, title: title, leads: leads)
                        
                        self.theirWishListForUser.append(compObj)
                    }
                }
                
                self.tblCompaniesView.reloadData()
                
            }
            
        }, errorCallback: {(Void, NSError) -> Void in
            
            loader.hideActivityIndicator(self.view)
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancleProfileView(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(568)
                self.profileViewTopConstraint.constant = 1000
        }, completion: nil)
    }
    
    @IBAction func btnProfileTapped(_ sender: AnyObject) {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isHidden = true
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(0)
                self.profileViewTopConstraint.constant = 0
        }, completion: {(value: Bool) in
            
            loader.showActivityIndicator(self.view)
            let theirProfile = WLTheirProfile()
            theirProfile.user = self.inboundObject!.requestorusername!
            theirProfile.theirProfile({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                if let response = AnyObject as? [String : AnyObject] {
                    
                    let firstName = response["first_name"] as? String ?? ""
                    let lastName = response["last_name"] as? String ?? ""
                    let phoneNumber = response["phone"] as? String ?? ""
                    let email = response["email"] as? String ?? ""
                    let image = response["image"] as? String ?? ""
                    let title = response["title"] as? String ?? ""
                    let bio = response["bio"] as? String ?? ""
                    let discussion = response["business_discussion"] as? String ?? ""
                    let additional = response["business_additional"] as? String ?? ""
                    
                    self.txtFullBio.text = bio
                    self.txtWhatIWantToDiscuss.text = discussion + "\n\n" + additional
                    
                    if image != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && image != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" {
                        
                        if image.contains("http") {
                            
                            if let checkedUrl = URL(string: image) {
                                self.downloadImage(checkedUrl)
                            }
                        } else {
                            
                            if let checkedUrl = URL(string: WLAppSettings.getBaseUrl() + "/" + image) {
                                self.downloadImage(checkedUrl)
                            }
                        }
                    }
                    
                    
                    self.lblUserName.text = firstName + " " + lastName
                    self.lblPhoneNumber.text = phoneNumber
                    self.lblEmail.text = email
                    self.lblPosition.text = title
                    self.lblPosition.sizeToFit()
                }
                
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
                print(NSError)
            })
        })
    }
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error as! NSError)
        }) .resume()
    }
    
    func downloadImage(_ url: URL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
                self.imgProfilePicture.clipsToBounds = true
                self.imgProfilePicture.layer.borderWidth = 2
                self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
                self.imgProfilePicture.image = UIImage(data: data)
            }
        }
    }
    
    func getRequestDetail(_ requestID: Int) {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        loader.showActivityIndicator(self.view)
        let inBoundRequestDetailObject = WLGetInBoundeRequestDetail()
        inBoundRequestDetailObject.requestID = requestID
        inBoundRequestDetailObject.getInBoundDetail({(Void, AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            
            print(AnyObject)
            
            if let response = AnyObject as? [String: AnyObject] {
                
                let whyIntroReason = response["whyIntroReason"] as? String ?? ""
                let howIntroReason = response["howIntroReason"] as? String ?? ""
                
                if let comments = response["comments"] as? [[String: AnyObject]] {
                    
                    if comments.count > 0 {
                        
                        print(comments)
                        if let comment = comments[0] as? [String: String] {
                            let abc = comment["comment"]
                            print(abc)
                            if abc!.length > 0 {
                                
                                self.txtCommentOfRequest.text = abc
                                self.businessCommentView.isHidden = false
                                
                            } else {
                                
                                self.businessCommentView.isHidden = true
                            }
                        }
                    } else {
                        self.businessCommentView.isHidden = true
                    }
                    
                    if self.txtCommentOfRequest.text.characters.count == 0 {
                        
                        self.tblCompanies.setHeight(270)
                    }
                }
                
                if let companies = response["companiesofInterest"] as? [[String: AnyObject]] {
                    
                    for company in companies {
                        
                        let title = company["title"] as! String
                        let profile_image_url = company["profile_image_url"] as! String
                        
                        self.companiesOfIntrust.append(title)
                        self.companiesImages.append(profile_image_url)
                    }
                    self.tblCompanies.reloadData()
                }
                
                self.txtHow.text = whyIntroReason
                self.txtWhy.text = howIntroReason
                
                self.txtHow.flashScrollIndicators()
                self.txtWhy.flashScrollIndicators()
            }
            
        }, errorCallback: {(Void, NSError) -> Void in
            
            loader.hideActivityIndicator(self.view)
            print(NSError)
        })
    }
    
    @IBAction func btnDeclinedRequestTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isHidden = true
        txtComment.text = ""
        lblConform.text = "Confirm You Decline This Request"
        txtComment.placeholder = "(Optional) Add any comment you'd like them to receive. Your real name will not be revealed."
        btnConform.tag = 0
        btnConform.setImage(UIImage(named: "OutGoingDecline"), for: UIControl.State())
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.confirmationView.setY(0)
                self.confirmationViewTopConstraint.constant = 0
        }, completion: nil)
        
    }
    
    @IBAction func btnAcceptRequestTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isHidden = true
        self.view.endEditing(true)
        txtComment.text = ""
        btnConform.tag = 1
        lblConform.text = "Confirm You Accept This Request"
        txtComment.placeholder = "Add a comment if desired. Your Private Profile info is shared, but not the contact data of the person you're introducing."
        btnConform.setImage(UIImage(named: "OutGoingAccept"), for: UIControl.State())
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.confirmationView.setY(0)
                self.confirmationViewTopConstraint.constant = 0
        }, completion: nil)
    }
    
    @IBAction func btnCancelPopUpTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        self.view.endEditing(true)
        lblConform.text = "test"
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.confirmationView.setY(568)
                self.confirmationViewTopConstraint.constant = 1000
        }, completion: nil)
    }
    
    @IBAction func btnConfirmOrDeclineTapped(_ sender: UIButton) {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                // self.confirmationView.setY(568)
                self.confirmationViewTopConstraint.constant = 1000
        }, completion: {action in
            
            loader.showActivityIndicator(self.view)
            let notificationAction = WLNotificationAction()
            notificationAction.notificationID = self.selectedRequestID
            print(self.txtComment.text!)
            notificationAction.comment = self.txtComment.text!
            self.txtComment.text = ""
            if sender.tag == 0 {
                notificationAction.notificatioAction = "decline"
                Mixpanel.sharedInstance()?.track("Request Declined", properties:nil)
            } else {
                notificationAction.notificatioAction = "accept"
                Mixpanel.sharedInstance()?.track("Request Accepted", properties:nil)
            }
            
            notificationAction.performNotificationAction({(Void, Any) -> Void in
                
                loader.hideActivityIndicator(self.view)
                self.navigationController?.popViewController(animated: true)
                
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
                self.navigationController?.popViewController(animated: true)
                print(NSError)
            })
        })
    }
    
    var mutualContactsArray = [String]()
    var mutualContactPosition = [String]()
    var mutualContactCompany = [String]()
    var mutualContactLoaded = false
    
    func getMutualContacts() {
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            let getMutual = WLMutualForNotificationDetail()
            getMutual.ID = selectedRequestID
            getMutual.getMutualContactForNotificationDetail({(Void, AnyObject) -> Void in
                
                self.mutualContactsArray.removeAll()
                self.mutualContactPosition.removeAll()
                self.mutualContactCompany.removeAll()
                
                loader.hideActivityIndicator(self.view)
                if let response = AnyObject as? [String: AnyObject] {
                    
                    self.nextMutualContactURL = response["next"] as? String ?? ""
                    
                    if let mutualcontacts = response["results"] as? [[String : AnyObject]] {
                        
                        for contact in mutualcontacts {
                            
                            print(contact)
                            let first_name = contact["first_name"] as? String ?? ""
                            let middle_name = contact["middle_name"] as? String ?? ""
                            let last_name = contact["last_name"] as? String ?? ""
                            let company = contact["company"] as? String ?? ""
                            let title = contact["title"] as? String ?? ""
                            
                            self.mutualContactsArray.append(first_name + " " + middle_name + " " + last_name)
                            self.mutualContactPosition.append(title)
                            self.mutualContactCompany.append(company)
                        }
                        
                        self.tblMutualContact.reloadData()
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
}
extension IncommingNotificationDetailForMemberMatchingViewController : UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblCompanies:
            return companiesOfIntrust.count
            
        case tblCompaniesView:
            
            return theirWishListForUser.count
            
        case tblMutualContact:
            
            return mutualContactsArray.count
            
        default:
            
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case tblCompanies:
            
            let cell = self.tblCompanies.dequeueReusableCell(withIdentifier: "cell")! as! IncomingCompaniesTableViewCell
            cell.selectionStyle = .none
            cell.lblCompanyName.text = self.companiesOfIntrust[indexPath.row]
//            cell.imgCompany.hnk_setImageFromURL(URL(string: companiesImages[indexPath.row])!)
            
            return cell
            
        case tblCompaniesView:
            
            let cell = tblCompaniesView.dequeueReusableCell(withIdentifier: "cell") as! MyWishlistTableViewCell
            
            cell.selectionStyle = .none
            let companyObj = theirWishListForUser[indexPath.row]
            
            cell.lblCompanieName.text = companyObj.title
            cell.lblCount.text = "\(companyObj.leads!)"
            
            return cell
            
        case tblMutualContact:
            
            let cell = self.tblMutualContact.dequeueReusableCell(withIdentifier: "mutulaContactsCell")! as! MutualContactsTableViewCell
            cell.isUserInteractionEnabled = false
            cell.lblContactName.text = mutualContactsArray[indexPath.row]
            cell.lblContactPosition.text = mutualContactPosition[indexPath.row]
            cell.lblContactCompany.text = mutualContactCompany[indexPath.row]
            
            if cell.lblContactPosition.text?.characters.count == 0 {
                cell.lblContactName.setY(20)
            } else {
                cell.lblContactName.setY(8)
            }
            
            return cell
            
        default:
            
            return UITableViewCell()
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch tableView {
            
        case tblCompaniesView:
            
            if theirWishListForUser.count > 7 {
                
                if indexPath.row + 1 == theirWishListForUser.count {
                    
                    if nextURLForTheirRequest.characters.count > 0 {
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblCompaniesView.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            getTheirWishListForUser.handle = inboundObject!.requestorusername!
                            getTheirWishListForUser.getTheirWishListForUser({(Void, AnyObject) -> Void in
                                
                                loader.hideActivityIndicator(self.view)
                                if let response = AnyObject as? [String: AnyObject] {
                                    
                                    self.nextURLForTheirRequest = response["next"] as? String ?? ""
                                    
                                    if let results = response["results"] as? [[String: AnyObject]] {
                                        
                                        for company in results {
                                            
                                            let id = company["id"] as? Int ?? 0
                                            let title = company["title"] as? String ?? ""
                                            let mutual = company["mutual"] as? Int ?? 0
                                            let leads = company["leads"] as? Int ?? 0
                                            
                                            let compObj = MyWishListForUserObject(id: id, mutual: mutual, title: title, leads: leads)
                                            
                                            self.theirWishListForUser.append(compObj)
                                        }
                                    }
                                    
                                    self.tblCompaniesView.reloadData()
                                    
                                }
                                
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                print(NSError)
                                
                            })
                            
                        } else {
                            
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                        }
                    }
                }
            }
            
        case tblMutualContact:
            
            if rechability.isConnectedToNetwork() {
                
                if connectionObjects.count > 7 {
                    
                    if indexPath.row + 1 == connectionObjects.count {
                        
                        if nextMutualContactURL.characters.count > 0 {
                            
                            self.tblMutualContact.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
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
                                        
                                        self.tblMutualContact.reloadData()
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
            
        default:
            break
        }
    }
}

