//
//  IncomingRequestDetailViewController.swift
//  WishList
//
//  Created by Dharmesh on 06/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel

class IncomingRequestDetailViewController: UIViewController, UITextViewDelegate, TSMessageViewProtocol,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnCompanies: UIButton!
    @IBOutlet weak var btnMutualContacts: UIButton!
    
    @IBOutlet weak var businessView: UIView!
    @IBOutlet weak var companiesView: UIView!
    @IBOutlet weak var mutualContactView: UIView!
    
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var tblMutualContacts: UITableView!
    
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var conformationViewTopCnstrnt: NSLayoutConstraint!

    @IBOutlet weak var confirmationSubView: UIView!
    @IBOutlet weak var lblConform: UILabel!
    @IBOutlet weak var txtComment: KMPlaceholderTextView!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnConform: UIButton!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileSubView: UIView!
    
    @IBOutlet weak var txtHow: UITextView!
    
    @IBOutlet weak var txtWhy: UITextView!
    
    @IBOutlet weak var lblRequestor: UILabel!
    @IBOutlet weak var lblProspect: UILabel!
    
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    
    //Profile View
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblProfileType: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    
    var companiesOfIntrust = [String]()
    var companiesImages = [String]()
    
    var mutualContactsArray = [String]()
    var mutualContactPosition = [String]()
    var mutualContactCompany = [String]()
    var menuButtons = [UIButton]()
    
    @IBOutlet weak var businessCommentView: UIView!
    @IBOutlet weak var imgBusinessCommentBG: UIImageView!
    @IBOutlet weak var txtCommentOfRequest: UITextView!
    
    @IBOutlet weak var txtWhatIWantToDiscuss: UITextView!
    @IBOutlet weak var txtBioFull: UITextView!
    @IBOutlet weak var lblContact: UILabel!
    
    var overLayView : UIView?
    var selectedRequestID = 0
    
    var inboundObject: InboundObject?
    var requesterFirstName = ""
    var nextMutualContactListURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.conformationViewTopCnstrnt.constant = 1000
        self.profileViewTopConstraint.constant = 1000
        initFooterView()
        
        self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
        self.imgProfilePicture.clipsToBounds = true
        self.imgProfilePicture.layer.borderWidth = 2
        self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
        
        if inboundObject?.status == "accepted" || inboundObject?.status == "declined" {
            
            btnDecline.isHidden = true
            btnAccept.isHidden = true
            
        } else {
            
            tblMutualContacts.setHeight(313)
        }
        
        if inboundObject?.status == "accepted" {
            imgBusinessCommentBG.image = UIImage(named: "AcceptedReqCommentBG")
            lblContact.text = "Contact"
        } else if inboundObject?.status == "declined" {
            
            imgBusinessCommentBG.image = UIImage(named: "DeclinedCommentBG")
            lblContact.text = "Profile"
        } else {
            
            lblContact.text = "Contact"
        }
        
        lblRequestor.text = inboundObject?.requestorname
        lblProspect.text = inboundObject?.prospectname
        
        txtComment.delegate = self
        txtComment.returnKeyType = UIReturnKeyType.done
        confirmationView.backgroundColor = UIColor.clear.withAlphaComponent(0.82)
        profileView.backgroundColor = UIColor.clear.withAlphaComponent(0.82)
        
        confirmationSubView.layer.cornerRadius = 10.0
        confirmationSubView.clipsToBounds = true
        
        profileSubView.layer.cornerRadius = 10.0
        profileSubView.clipsToBounds = true
        
        menuButtons = [btnBusiness, btnCompanies, btnMutualContacts]
        tblCompanies.separatorStyle = .none
        tblMutualContacts.separatorStyle = .none
        
        businessView.isHidden = false
        companiesView.isHidden = true
        mutualContactView.isHidden = true
        
        if inboundObject?.requestorname?.characters.count > 0 {
            
            let whitespace = CharacterSet.whitespaces
            
            let phrase = inboundObject?.requestorname
            let range = phrase!.rangeOfCharacter(from: whitespace)
            
            // range will be nil if no whitespace is found
            if let _ = range {
                print("whitespace found")
                let fullNameArr = inboundObject!.requestorname!.characters.split{$0 == " "}.map(String.init)
                requesterFirstName = fullNameArr[0]
                lblInfo.text = "How \(requesterFirstName) can help you in return"
            }
        }
    }
    
    func addOverLay(){
        
        var h :CGFloat = 100
       
        overLayView = UIView(frame: CGRect(x: 0, y: self.view.height , width: self.view.width, height: h))
        overLayView?.backgroundColor = UIColor.black.withAlphaComponent(0.82)
        
        self.tabBarController?.view.addSubview(overLayView!)
    }
    
    func removeOverLay(){
        
        overLayView?.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        getRequestDetail(selectedRequestID)
    }
    
    var mutualContactLoaded = false
    
    func getMutual() {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        loader.showActivityIndicator(self.view)
        let getMutual = WLMutualForNotificationDetail()
        getMutual.ID = selectedRequestID
        getMutual.getMutualContactForNotificationDetail({(Void, AnyObject) -> Void in
            
            self.mutualContactLoaded = true
            loader.hideActivityIndicator(self.view)
            
            if let response = AnyObject as? [String: AnyObject] {
                
                self.nextMutualContactListURL = response["next"] as? String ?? ""
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
                    print(self.mutualContactsArray.count)
                    self.tblMutualContacts.reloadData()
                }
                
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
                print(NSError)
        })
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
        
        if tableView == tblMutualContacts {
            
            if mutualContactsArray.count > 7 {
                
                if indexPath.row + 1 == mutualContactsArray.count {
                    
                    if nextMutualContactListURL.characters.count > 0 {
                        
                        if !rechability.isConnectedToNetwork() {
                            
                            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                            return
                        }
                        
                        self.tblMutualContacts.tableFooterView = footerView
                        (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                        
                        let getMutual = WLMutualForNotificationDetail()
                        getMutual.ID = selectedRequestID
                        getMutual.nextURL = nextMutualContactListURL
                        getMutual.getMutualContactForNotificationDetail({(Void, AnyObject) -> Void in
                            
                            (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                            
                            if let response = AnyObject as? [String: AnyObject] {
                                
                                self.nextMutualContactListURL = response["next"] as? String ?? ""
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
                                    print(self.mutualContactsArray.count)
                                    self.tblMutualContacts.reloadData()
                                }
                                
                            }
                            
                            }, errorCallback: {(Void, NSError) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                print(NSError)
                        })
                    }
                }
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
            
            if let response = AnyObject as? [String: AnyObject] {
                print(response)
                let whyIntroReason = response["whyIntroReason"] as? String ?? ""
                print(whyIntroReason)
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
                
                self.txtHow.text = howIntroReason
                self.txtWhy.text = whyIntroReason
                
                self.txtWhy.flashScrollIndicators()
                self.txtHow.flashScrollIndicators()
            
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
        
                loader.hideActivityIndicator(self.view)
                print(NSError)
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == txtComment {
            if textView.text == "Add a comment if desired. Your Private Profile info is shared, but not the contact data of the person you're introducing." || textView.text == "(Optional) Add any comment you'd like them to receive. Your real name will not be revealed." {
                textView.text = ""
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            self.view.endEditing(true)
        }
        lblCommentCount.text = "\(textView.text.characters.count) of 300"
        return textView.text.characters.count + (text.characters.count - range.length) <= 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.tblCompanies {
            count = companiesOfIntrust.count
        }
        
        if tableView == self.tblMutualContacts {
            count =  mutualContactsArray.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblCompanies {
            
            let cell = self.tblCompanies.dequeueReusableCell(withIdentifier: "cell")! as! IncomingCompaniesTableViewCell
            cell.selectionStyle = .none
            cell.lblCompanyName.text = self.companiesOfIntrust[indexPath.row]
            if let url = URL(string: companiesImages[indexPath.row]) {
            cell.imgCompany?.hnk_setImageFromURL(url)
            }
            return cell
        } else {
            
            let cell = self.tblMutualContacts.dequeueReusableCell(withIdentifier: "cell")! as! IncommingMutualContactsTableViewCell
            cell.selectionStyle = .none
            cell.lblContactName.text = mutualContactsArray[indexPath.row]
            cell.lblContactPosition.text = mutualContactPosition[indexPath.row]
            cell.lblContactCompany.text = mutualContactCompany[indexPath.row]
            
            if cell.lblContactPosition.text?.characters.count == 0 {
                cell.lblContactName.setY(20)
            } else {
                cell.lblContactName.setY(8)
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblMutualContacts {
            return 62
        }
        
        return 70
    }
    
    @IBAction func btnConfirmOrDeclineTapped(_ sender: UIButton) {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
       // self.tabBarController?.tabBar.layer.zPosition = 0
        //self.tabBarController?.tabBar.isHidden = false
       removeOverLay()
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.confirmationView.setY(568)
                self.conformationViewTopCnstrnt.constant = 1000
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
                        print(NSError)
                })
        })
    }
    
    @IBAction func btnCancleProfileView(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
         //self.tabBarController?.tabBar.isHidden = false
        removeOverLay()
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(568)
                self.profileViewTopConstraint.constant = 1000
            }, completion: nil)
    }
    
    @IBAction func btnCancelTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
       // self.tabBarController?.tabBar.isHidden = true
        addOverLay()
        txtComment.text = ""
        lblConform.text = "Confirm You Decline This Request"
        txtComment.placeholder = "(Optional) Add any comment you'd like them to receive. Your real name will not be revealed."
        btnConform.tag = 0
        btnConform.setImage(UIImage(named: "OutGoingDecline"), for: UIControl.State())
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.confirmationView.setY(0)
                self.conformationViewTopCnstrnt.constant = 0
            }, completion: nil)
        
    }
    
    @IBAction func btnAcceptTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
        //self.tabBarController?.tabBar.isHidden = true
        addOverLay()
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
                self.conformationViewTopCnstrnt.constant = 0
            }, completion: nil)
    }
    
    @IBAction func btnCancelPopUpTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        //self.tabBarController?.tabBar.isHidden = false
        removeOverLay()
        self.view.endEditing(true)
        lblConform.text = "test"
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.confirmationView.setY(568)
                self.conformationViewTopCnstrnt.constant = 1000
            }, completion: nil)
    }
    
    @IBAction func menuBtnTapped(_ sender: UIButton) {
        
        for button in menuButtons {
            
            if button.currentTitle == sender.currentTitle {
                
                button.setBackgroundImage(UIImage(named: "OutGoingBusinessBtn"), for: UIControl.State())
            } else {
                button.setBackgroundImage(nil, for: UIControl.State())
            }
        }
        
        switch sender.currentTitle! {
            
        case "Business":
            
            businessView.isHidden = false
            companiesView.isHidden = true
            mutualContactView.isHidden = true
            lblInfo.text = "How \(requesterFirstName) can help you in return"
            
        case "Companies":
            
            businessView.isHidden = true
            companiesView.isHidden = false
            mutualContactView.isHidden = true
            lblInfo.text = "Companies \(requesterFirstName) can help you with"
            
        case "Mutual Contacts":
            
            businessView.isHidden = true
            companiesView.isHidden = true
            mutualContactView.isHidden = false
            lblInfo.text = "Your mutual contacts with \(requesterFirstName)"
            if !mutualContactLoaded {
                getMutual()
            }
            
            
        default:
            
            break
            
        }
    }
    
    @IBAction func btnProfileTapped(_ sender: AnyObject) {
        
        if !rechability.isConnectedToNetwork() {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
       // self.tabBarController?.tabBar.layer.zPosition = -1
       //self.tabBarController?.tabBar.isHidden = true
        addOverLay()
        
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
                        
                        self.txtBioFull.text = bio
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
            completion(data, response, error as NSError? )
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
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
