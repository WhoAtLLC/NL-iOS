//
//  StartRequestViewController.swift
//  WishList
//
//  Created by Dharmesh on 01/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

//import TSMessages

class StartRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TSMessageViewProtocol {

    @IBOutlet weak var btnTheirRequest: UIButton!
    @IBOutlet weak var btnCompanies: UIButton!
    @IBOutlet weak var btnMutualContacts: UIButton!
    
    @IBOutlet weak var theirRequestView: UIView!
    @IBOutlet weak var tblCompanies: UITableView!
    @IBOutlet weak var companiesView: UIView!
    @IBOutlet weak var mutualContactView: UIView!
    @IBOutlet weak var tblMutualContacts: UITableView!
    @IBOutlet weak var lblIntro: UILabel!
    
    @IBOutlet weak var companyIntroView: UIView!
    @IBOutlet weak var companyIntroViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblMutualContact: UILabel!
    
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblBioInProfileDetail: UILabel!
    @IBOutlet weak var lblUserNameInProfileDetail: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileSubView: UIView!
    
    @IBOutlet weak var tblProfileDetailMutualContacts: UITableView!
    @IBOutlet weak var lblMutualContactForProfile: UILabel!
    
    @IBOutlet weak var lblbusiness_additional: UITextView!
    @IBOutlet weak var lblbusiness_discussion: UITextView!
    @IBOutlet weak var lbl50CharBio: UILabel!
    
    @IBOutlet weak var lblIntroDiscuss: UILabel!
    @IBOutlet weak var lblJobTitleDiscuss: UILabel!
    
    @IBOutlet weak var txtDiscussion: KMPlaceholderTextView!
    @IBOutlet weak var introImage: UIImageView!
    
    
    var firstTime = UserDefaults.standard.bool(forKey: "firstTimeCompanySubIntro")
    var menuButtonArray = [UIButton]()
    var items: [String] = ["Amazon", "General Electric", "General Motors", "Goldman Sachs"]
    
    let contactName = ["David Einhorn", "Bill Collins", "Allen Lassiter", "Kevin Parke", "David Rambie"]
    let contactPosition = ["CEO", "CEO","Vice President", "", "Head Coach"]
    let contactDetail = ["Wind Energy Holding Co. Ltd", "Unilever", "AIG", "", "Miami Dolphins"]
    
    var introducreName: String?
    var selectedConnectionObject: ConnectionObject?
    var handle = ""
    var selectedMutualContact: MutualContactObject?
    
    
    var companyObjects = [CompanyObject]()
    var nextPageURL = ""
    
    var connectionObjects = [MutualConnectionObject]()
    
    var companiesLoaded = false
    var mutualContactLoaded = false
    
    var nextMutualContactURL = ""
    var id = 0
    var selectedCompany = ""
    
    var commingFromGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileViewTopConstraint.constant = 1000
        self.companyIntroViewTopConstraint.constant = 1000
        //self.companyIntroView.isHidden = true
        
        print(selectedConnectionObject)
        initFooterView()
        
        lblIntro.text = "How can you help \(handle) in return?"
        lblContact.text = introducreName!
        lblMutualContact.text = "by \(handle)"
        lblMutualContactForProfile.text = "Your Mutual Contacts with \(handle)"
        lblIntroDiscuss.text = "\(handle)'s Bio"
        lblJobTitleDiscuss.text =  "What \(handle) is looking for"
        
        self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
        self.imgProfilePicture.clipsToBounds = true
        self.imgProfilePicture.layer.borderWidth = 2
        self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
        
        menuButtonArray = [btnTheirRequest, btnCompanies, btnMutualContacts]
        tblCompanies.separatorStyle = .none
        tblMutualContacts.separatorStyle = .none
        tblProfileDetailMutualContacts.separatorStyle = .none
        
        theirRequestView.isHidden = false
        companiesView.isHidden = true
        mutualContactView.isHidden = true
        
        profileSubView.layer.cornerRadius = 10.0
        profileSubView.clipsToBounds = true
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            print("This is run on the background queue")
            self.getProfile()
            DispatchQueue.main.async(execute: { () -> Void in
                self.getMutualContacts()
            })
        })
        
    }
    
    
    func getProfile() {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        loader.showActivityIndicator(self.view)
        let theirProfile = WLTheirProfile()
        theirProfile.user = self.handle
        
        theirProfile.theirProfile({(Void,AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            if let response =  AnyObject as? [String : AnyObject] {
                
                let bio = response["bio"] as? String ?? ""
                let handle = response["handle"] as? String ?? ""
                let image = response["image"] as? String ?? ""
                let business_additional = response["business_additional"] as? String ?? ""
                let business_discussion = response["business_discussion"] as? String ?? ""
                let short_bio = response["short_bio"] as? String ?? ""
                
                self.lblBioInProfileDetail.text = bio
                self.lblUserNameInProfileDetail.text = handle
                self.lblbusiness_discussion.text = bio
                self.lbl50CharBio.text = short_bio
                self.txtDiscussion.text = business_discussion + "\n\n" + business_additional
                self.lblbusiness_additional.text = business_discussion + "\n\n" + business_additional
                
                if image.characters.count > 0 {
                    
                    if image != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && image != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png"{
                        
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
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
                print(NSError)
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
    
    @IBAction func btnCancleProfileviewTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(568)
                self.profileViewTopConstraint.constant = 1000
            }, completion: nil)
    }
    
    @IBAction func btnStartRequestTapped(_ sender: AnyObject) {
        
        let sendRequestView = self.storyboard?.instantiateViewController(withIdentifier: "SendRequest") as! SendRequestViewController
        
        sendRequestView.handle = handle
        sendRequestView.introducreName = introducreName!
        sendRequestView.selectedMutualContact = selectedMutualContact
        sendRequestView.selectedConnectionObject = selectedConnectionObject
        sendRequestView.id = id
        if commingFromGroup {
            sendRequestView.commingFromGroup = true
        }
        sendRequestView.selectedCompany = selectedCompany
        self.navigationController?.pushViewController(sendRequestView, animated: true)
    }
    
    @IBAction func showContactProfileTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isHidden = true
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(0)
                self.profileViewTopConstraint.constant = 0
            }, completion: { action in
            
        })
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelIntro(_ sender: AnyObject) {
        
        //companyIntroView.isHidden = true
        self.companyIntroViewTopConstraint.constant = 1000
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
        switch sender.currentTitle! {
            
            case "Their Interest":
                
                lblIntro.text = "How can you help \(handle) in return?"
            
                for menubutton in menuButtonArray {
                    
                    if menubutton.currentTitle! == "Their Interest" {
                        
                        menubutton.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
                    } else {
                        menubutton.setBackgroundImage(nil, for: UIControl.State())
                    }
                }
            
            theirRequestView.isHidden = false
            companiesView.isHidden = true
            mutualContactView.isHidden = true
            
            case "Companies":
                
                lblIntro.text = "These companies are interesting to \(handle)"
                firstTime =  UserDefaults.standard.bool(forKey: "firstTimeCompanySubIntro")
                if !firstTime {
                    
                    let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(StartRequestViewController.hideMainIntro))
                    introImage.isUserInteractionEnabled = true
                    introImage.addGestureRecognizer(tapForMainViewImage)
                    
                    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(StartRequestViewController.respondToSwipeGesture(_:)))
                    swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                    self.introImage.addGestureRecognizer(swipeLeft)
                    
                    companyIntroView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    //self.tabBarController?.tabBar.layer.zPosition = -1
                   // self.companyIntroViewTopConstraint.constant = 0
                    self.tabBarController?.tabBar.isHidden = true
                    UserDefaults.standard.set(true, forKey: "firstTimeCompanySubIntro")
                    firstTime = true
                    
                }
                
            
                for menubutton in menuButtonArray {
                    
                    if menubutton.currentTitle! == "Companies" {
                        
                        menubutton.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
                    } else {
                        menubutton.setBackgroundImage(nil, for: UIControl.State())
                    }
                }
            
                theirRequestView.isHidden = true
                companiesView.isHidden = false
                mutualContactView.isHidden = true
                
                if !companiesLoaded {
                    getCompanies()
                }
            
            case "Mutual Contacts":
                
                lblIntro.text = "These are your mutual contacts with \(handle)"
            
                for menubutton in menuButtonArray {
                    
                    if menubutton.currentTitle! == "Mutual Contacts" {
                        
                        menubutton.setBackgroundImage(UIImage(named: "MutualContactBG"), for: UIControl.State())
                    } else {
                        menubutton.setBackgroundImage(nil, for: UIControl.State())
                    }
                }
            
                theirRequestView.isHidden = true
                companiesView.isHidden = true
                mutualContactView.isHidden = false
                
                if !mutualContactLoaded {
                    getMutualContacts()
                }
            
            default:
            
                break
        }
    }
    
    @objc func hideMainIntro() {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
               // self.companyIntroView.setY(568)
                self.companyIntroViewTopConstraint.constant = 1000
            }, completion: nil)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                
               // self.tabBarController?.tabBar.layer.zPosition = 0
                self.tabBarController?.tabBar.isHidden = false
                
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        //self.companyIntroView.setY(568)
                        self.companyIntroViewTopConstraint.constant = 1000
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    func getCompanies() {
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            
            companyObjects.removeAll()
            let companyModel = WLCompanyList()
            companyModel.isContactCompanies = true
            companyModel.mutualContact = handle
            companyModel.companyList({ (Void,  AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                let response =  AnyObject as! [String: AnyObject]
                self.companiesLoaded = true
                
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
            
            loader.showActivityIndicator(self.view)
            connectionObjects.removeAll()
            let connections = WLConnection()
            connections.isMutualContacts = true
            connections.contactHandle = handle
            connections.getConnections({(Void,  AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                self.mutualContactLoaded = true
                
                if let responseMain =  AnyObject as? [String: AnyObject] {
                    
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
                        self.tblProfileDetailMutualContacts.reloadData()
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
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
        
        if tableView == self.tblProfileDetailMutualContacts {
            count =  connectionObjects.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblCompanies {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "companiesCell", for: indexPath) as! CompaniesTableViewCell
            
            cell.isUserInteractionEnabled = false
            let company = companyObjects[indexPath.row]
            cell.ibiCompanyName.text = company.title
            if company.profile_image_url?.characters.count > 0 {
                
                if let url = URL(string: company.profile_image_url!) {
                    
                    cell.imgCompany.hnk_setImageFromURL(url)
                }
                
            }
            
            return cell
            
        } else if tableView == tblMutualContacts {
            
            let cell = self.tblMutualContacts.dequeueReusableCell(withIdentifier: "mutulaContactsCell")! as! MutualContactsTableViewCell
            cell.isUserInteractionEnabled = false
            let contact = connectionObjects[indexPath.row]
            cell.lblContactName.text = contact.fullName
            cell.lblContactPosition.text = contact.title
            cell.lblContactCompany.text = contact.company
            
            if cell.lblContactPosition.text?.characters.count == 0 {
                cell.lblContactName.setY(20)
            } else {
                cell.lblContactName.setY(8)
            }
            
            return cell
            
        } else {
            
            let cell = self.tblMutualContacts.dequeueReusableCell(withIdentifier: "mutulaContactsCell")! as! MutualContactsTableViewCell
            cell.isUserInteractionEnabled = false
            let contact = connectionObjects[indexPath.row]
            cell.lblContactName.text = contact.fullName
            cell.lblContactPosition.text = contact.title
            cell.lblContactCompany.text = contact.company
            
            if cell.lblContactPosition.text?.characters.count == 0 {
                cell.lblContactName.setY(20)
            } else {
                cell.lblContactName.setY(8)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblProfileDetailMutualContacts || tableView == tblMutualContacts {
            return 62
        } else {
            
            return 70
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
                            companyModel.loadMoreCompanies({(Void,  AnyObject) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                if let response =  AnyObject as? [String: AnyObject] {
                                    
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
            
        } else if tableView == tblMutualContacts || tableView == tblProfileDetailMutualContacts {
            
            if rechability.isConnectedToNetwork() {
                
                if connectionObjects.count > 7 {
                    
                    if indexPath.row + 1 == connectionObjects.count {
                        
                        if nextMutualContactURL.characters.count > 0 {
                            
                            self.tblMutualContacts.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            let connections = WLConnection()
                            connections.nextMutualContactURL = nextMutualContactURL
                            connections.getConnections({(Void,  AnyObject) -> Void in
                                
                                (self.footerView.viewWithTag(10) as! UIActivityIndicatorView).stopAnimating()
                                
                                if let responseMain =  AnyObject as? [String: AnyObject] {
                                    
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
                                        self.tblProfileDetailMutualContacts.reloadData()
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
}
