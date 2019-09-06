//
//  OutGoingViewController.swift
//  WishList
//
//  Created by Dharmesh on 06/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit


//import TSMessages

class OutGoingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TSMessageViewProtocol {

    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnCompanies: UIButton!
    @IBOutlet weak var btnMutualContacts: UIButton!
    @IBOutlet weak var lblSelectedBtnIntro: UILabel!
    
    @IBOutlet weak var businessView: UIView!
    @IBOutlet weak var companiesView: UIView!
    @IBOutlet weak var mutualContactView: UIView!
    @IBOutlet weak var businessCommentView: UIView!
    @IBOutlet weak var imgBusinessCommentBG: UIImageView!
    @IBOutlet weak var txtComment: UITextView!
    
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var tblMutualContacts: UITableView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileSubView: UIView!
    
    @IBOutlet weak var txtHow: UITextView!
    @IBOutlet weak var txtWhy: UITextView!
    
    @IBOutlet weak var lblRequestor: UILabel!
    @IBOutlet weak var lblProspect: UILabel!
    
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblIntroduce: UILabel!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var lblBio: UILabel!
    
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    
    @IBOutlet weak var lblReminderOfWhy: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblYourCommentsInReturn: UILabel!
    @IBOutlet weak var lblShortBio: UILabel!
    @IBOutlet weak var lblProfileType: UILabel!
    @IBOutlet weak var txtDiscussion: KMPlaceholderTextView!
    
    @IBOutlet weak var lblContact: UILabel!
    
    var menuButtonArray = [UIButton]()
    
    var outboundObject: OutboundObject?
    var archivedObject: ArchivedObject?
    var selectedRequestID = 0
    
    var companiesOfIntrust = [String]()
    var companiesImages = [String]()
    
    var mutualContactsArray = [String]()
    var mutualContactPosition = [String]()
    var mutualContactCompany = [String]()
    
    var isArchived = false
    var isMemberMatch = false
    var nextMutualContactListURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileViewTopConstraint.constant = 1000
       
        initFooterView()
        self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
        self.imgProfilePicture.clipsToBounds = true
        self.imgProfilePicture.layer.borderWidth = 2
        self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
        
        if isArchived {
            
            lblRequestor.text = archivedObject?.contactowner
            lblProspect.text = archivedObject?.prospectname
            
            print(archivedObject?.prospectname)
            
            if archivedObject?.prospectname?.characters.count > 0 {
                
                if let prospectName = archivedObject?.prospectname {
                    let fullNameArr = prospectName.characters.split{$0 == " "}.map(String.init)
                    lblReminderOfWhy.text = "Reminder of why you want the intro to \(fullNameArr[0])"
                }
            }
            
            if archivedObject?.status == "declined" {
                
                imgBusinessCommentBG.image = UIImage(named: "DeclinedCommentBG")
                lblIntroduce.text = "Declined your request to meet"
                btnProfile.setImage(UIImage(named: "PriveteProfileIcon"), for: UIControl.State())
                lblProfileType.text = "Public Profile"
                
            }
            
            if archivedObject?.status == "pending" {
                
                btnProfile.setImage(UIImage(named: "PriveteProfileIcon"), for: UIControl.State())
                lblProfileType.text = "Public Profile"
            }
            
            if archivedObject?.status == "accepted" {
                
                imgBusinessCommentBG.image = UIImage(named: "AcceptedReqCommentBG")
                lblProfileType.text = "Private Profile"
                lblIntroduce.text = "Accepted your request to meet"
                lblContact.text = "Contact"
                
            }
            
            lblSelectedBtnIntro.text = "How you offered to help \(archivedObject!.contactowner!)"
            lblYourCommentsInReturn.text = "Your comments on how you offered to help \(archivedObject!.contactusername!) in return"
            
        } else {
            
            
            lblRequestor.text = outboundObject?.contactowner
            print(outboundObject?.prospectname)
            lblProspect.text = outboundObject?.prospectname
            
            if let prospectName = outboundObject?.prospectname {
                
                if isMemberMatch {
                    
                    lblReminderOfWhy.text = "Reminder of why you want the intro to \(prospectName)"
                } else {
                    
                    let fullNameArr = prospectName.characters.split{$0 == " "}.map(String.init)
                    lblReminderOfWhy.text = "Reminder of why you want the intro to \(fullNameArr[0])"
                }
            }
            
            if outboundObject?.status == "declined" {
                
                lblIntroduce.text = "Declined your request to meet"
                btnProfile.setImage(UIImage(named: "PriveteProfileIcon"), for: UIControl.State())
                imgBusinessCommentBG.image = UIImage(named: "DeclinedCommentBG")
                lblProfileType.text = "Public Profile"
            }
            
            if outboundObject?.status == "pending" {
                
                btnProfile.setImage(UIImage(named: "PriveteProfileIcon"), for: UIControl.State())
                lblProfileType.text = "Public Profile"
            }
            
            if outboundObject?.status == "accepted" {
                
                imgBusinessCommentBG.image = UIImage(named: "AcceptedReqCommentBG")
                lblProfileType.text = "Private Profile"
                lblIntroduce.text = "Accepted your request to meet"
                lblContact.text = "Contact"
            }
            
            lblSelectedBtnIntro.text = "How you offered to help \(outboundObject!.contactowner!)"
            lblYourCommentsInReturn.text = "Your comments on how you offered to help \(outboundObject!.contactusername!) in return"
        }
        
        menuButtonArray = [btnBusiness, btnCompanies, btnMutualContacts]
        tblCompanies.separatorStyle = .none
        tblMutualContacts.separatorStyle = .none
        
        profileSubView.layer.cornerRadius = 10.0
        profileSubView.clipsToBounds = true
        
        businessView.isHidden = false
        companiesView.isHidden = true
        mutualContactView.isHidden = true
        txtHow.isUserInteractionEnabled = false
        
        getMutual()
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
    
    var mutualContactLoaded = false
    
    func getMutual() {
        
        let getMutual = WLMutualForNotificationDetail()
        getMutual.ID = selectedRequestID
        getMutual.getMutualContactForNotificationDetail({(Void, AnyObject) -> Void in
            
            self.mutualContactLoaded = true
            
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
                
                print(NSError)
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == tblMutualContacts {
            
            if mutualContactsArray.count > 7 {
                
                print(mutualContactsArray.count)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.setNavigationBarHidden(true, animated: animated)
        
        getRequestDetail(selectedRequestID)
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
                
                let howIntroReason = response["howIntroReason"] as? String ?? ""
                let whyIntroReason = response["whyIntroReason"] as? String ?? ""
                if let comments = response["comments"] as? [[String: AnyObject]] {
                    
                    if comments.count > 0 {
                        
                        if let comment = comments[0]["comment"] as? String {
                            
                            if comment.length > 0 {
                                
                                self.txtComment.text = comment
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
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
                print(NSError)
        })
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
            let cell = self.tblCompanies.dequeueReusableCell(withIdentifier: "cell")! as! OutGoingCompaniesTableViewCell
            cell.selectionStyle = .none
            cell.lblCompanyName.text = self.companiesOfIntrust[indexPath.row]
            
            if let url = URL(string: companiesImages[indexPath.row]) {
                cell.imgCompany?.hnk_setImageFromURL(url)
            }
            return cell
        } else if tableView == tblMutualContacts {
            
            let cell = self.tblMutualContacts.dequeueReusableCell(withIdentifier: "cell")! as! OutGoingMutualContactsTableViewCell
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
        } else {
            
            let cell = self.tblMutualContacts.dequeueReusableCell(withIdentifier: "cell")! as! OutGoingMutualContactsTableViewCell
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
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
        for button in menuButtonArray {
            
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
                
            
            case "Companies":
            
                businessView.isHidden = true
                companiesView.isHidden = false
                mutualContactView.isHidden = true
            
            case "Mutual Contacts":
            
                businessView.isHidden = true
                companiesView.isHidden = true
                mutualContactView.isHidden = false
            
                if !mutualContactLoaded {
                    getMutual()
                }
            
            default:
                break
        }
    }
    
    @IBAction func btnCancleProfileTapped(_ sender: AnyObject) {

        //self.tabBarController?.tabBar.layer.zPosition = 0
          self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(568)
                self.profileViewTopConstraint.constant = 1000
                
            }, completion: nil)
    }
    
    @IBAction func btnProfileTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
          self.tabBarController?.tabBar.isHidden = true
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(0)
                self.profileViewTopConstraint.constant = 0
            }, completion: {(value: Bool) in
                
                if !rechability.isConnectedToNetwork() {
                    TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                    return
                }
                
                loader.showActivityIndicator(self.view)
                let theirProfile = WLTheirProfile()
                if self.isArchived {
                    theirProfile.user = self.archivedObject!.contactusername!
                } else {
                    theirProfile.user = self.outboundObject!.contactusername!
                }
                
                theirProfile.theirProfile({(Void, AnyObject) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    if let response = AnyObject as? [String : AnyObject] {
                        
                        if self.isArchived {
                            
                            switch self.archivedObject!.status! {
                                
                            case "declined", "pending" :
                                
                                
                                let image = response["image"] as? String ?? ""
                                let handle = response["handle"] as? String ?? ""
                                let short_bio = response["short_bio"] as? String ?? ""
                                let bio = response["bio"] as? String ?? ""
                                let discussion = response["business_discussion"] as? String ?? ""
                                let additional = response["business_additional"] as? String ?? ""
                                
                                self.txtDiscussion.text = discussion + "\n\n" + additional
                                self.bioView.isHidden = false
                                self.lblBio.text = bio
                                self.lblBio.sizeToFit()
                                self.lblShortBio.text = short_bio
                                self.lblUserName.text = handle
                                
                                if image != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && image != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" {
                                    
                                    if image.length > 0 {
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
                                }
                                
                                self.imgPhone.isHidden = true
                                self.imgEmail.isHidden = true
                                
                            case "accepted":
                                
                                let firstName = response["first_name"] as? String ?? ""
                                let lastName = response["last_name"] as? String ?? ""
                                let email = response["email"] as? String ?? ""
                                let phoneNumber = response["phone"] as? String ?? ""
                                let image = response["image"] as? String ?? ""
                                let bio = response["bio"] as? String ?? ""
                                let short_bio = response["short_bio"] as? String ?? ""
                                
                                let discussion = response["business_discussion"] as? String ?? ""
                                let additional = response["business_additional"] as? String ?? ""
                                
                                self.txtDiscussion.text = discussion + "\n\n" + additional
                                self.lblUserName.text = firstName + " " + lastName
                                self.lblPhoneNumber.text = phoneNumber
                                self.lblEmail.text = email
                                self.lblShortBio.text = short_bio
                                self.lblShortBio.sizeToFit()
                                self.lblBio.text = bio
                                self.lblBio.sizeToFit()
                                self.bioView.setY(171)
                                
                                if firstName.characters.count == 0 && lastName.characters.count == 0 {
                                    
                                    let handle = response["handle"] as? String ?? ""
                                    self.lblUserName.text = handle
                                    
                                } else {
                                    self.lblUserName.text = firstName + " " + lastName
                                }
                                
                                self.lblPhoneNumber.text = phoneNumber
                                self.lblEmail.text = email
                                
                                if phoneNumber.characters.count > 0 {
                                    
                                    self.imgPhone.isHidden = false
                                } else {
                                    self.imgPhone.isHidden = true
                                }
                                
                                if email.characters.count > 0 {
                                    
                                    self.imgEmail.isHidden = false
                                } else {
                                    self.imgEmail.isHidden = true
                                }
                                
                                if image != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && image != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png"{
                                    
                                    if image.length > 0 {
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
                                }
                                
                                
                            default:
                                
                                break
                                
                            }
                            
                        } else {
                            
                            switch self.outboundObject!.status! {
                                
                            case "declined", "pending" :
                                
                                print("declined")
                                let image = response["image"] as? String ?? ""
                                let handle = response["handle"] as? String ?? ""
                                let short_bio = response["short_bio"] as? String ?? ""
                                let bio = response["bio"] as? String ?? ""
                                let discussion = response["business_discussion"] as? String ?? ""
                                let additional = response["business_additional"] as? String ?? ""
                                
                                self.txtDiscussion.text = discussion + "\n\n" + additional
                                self.bioView.isHidden = false
                                self.lblBio.text = bio
                                self.lblBio.sizeToFit()
                                self.lblUserName.text = handle
                                self.lblShortBio.text = short_bio
                                
                                if image != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && image != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png"{
                                    
                                    if image.length > 0 {
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
                                }
                                
                                self.imgPhone.isHidden = true
                                self.imgEmail.isHidden = true
                                
                            case "accepted":
                                
                                let firstName = response["first_name"] as? String ?? ""
                                let lastName = response["last_name"] as? String ?? ""
                                let email = response["email"] as? String ?? ""
                                let phoneNumber = response["phone"] as? String ?? ""
                                let image = response["image"] as? String ?? ""
                                let bio = response["bio"] as? String ?? ""
                                let short_bio = response["short_bio"] as? String ?? ""
                                
                                let discussion = response["business_discussion"] as? String ?? ""
                                let additional = response["business_additional"] as? String ?? ""
                                
                                self.txtDiscussion.text = discussion + "\n\n" + additional
                                
                                self.lblUserName.text = firstName + " " + lastName
                                self.lblPhoneNumber.text = phoneNumber
                                self.lblEmail.text = email
                                self.lblShortBio.text = short_bio
                                self.lblShortBio.sizeToFit()
                                self.lblBio.text = bio
                                self.lblBio.sizeToFit()
                                self.bioView.setY(171)
                                
                                if phoneNumber.characters.count > 0 {
                                    
                                    self.imgPhone.isHidden = false
                                } else {
                                    self.imgPhone.isHidden = true
                                }
                                
                                if email.characters.count > 0 {
                                    
                                    self.imgEmail.isHidden = false
                                } else {
                                    self.imgEmail.isHidden = true
                                }
                                
                                if image != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && image != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png"{
                                    
                                    if image.length > 0 {
                                        
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
                                }
                                
                            default:
                                
                                break
                                
                            }
                        }
                    }
                    
                    }, errorCallback: {(Void, NSError) -> Void in
                        
                        loader.hideActivityIndicator(self.view)
                        print(NSError)
                })
        })
    }
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error as? NSError)
            }) .resume()
    }
    
    
    func downloadImage(_ url: URL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        print(url)
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async { () -> Void in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                if data.count > 0 {
                    self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
                    self.imgProfilePicture.clipsToBounds = true
                    self.imgProfilePicture.layer.borderWidth = 2
                    self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
                    self.imgProfilePicture.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
}
