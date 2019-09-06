//
//  MemberMatchingViewController.swift
//  WishList
//
//  Created by Dharmesh on 09/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
//import TSMessages

class MemberMatchingViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var lblMutualContactName: UILabel!
    @IBOutlet weak var btnMyWishList: UIButton!
    @IBOutlet weak var btnTheirWishList: UIButton!
    @IBOutlet weak var btnMutualContatcs: UIButton!

    @IBOutlet weak var tblMyWishList: UITableView!
    @IBOutlet weak var myWishListView: UIView!
    @IBOutlet weak var lblMyWishListTitle: UILabel!
    
    
    @IBOutlet weak var theirWishListView: UIView!
    @IBOutlet weak var tblTheirWishList: UITableView!
    @IBOutlet weak var lblTheirWishListTitle: UILabel!
    
    @IBOutlet weak var mutualContactView: UIView!
    @IBOutlet weak var tblMutualContact: UITableView!

    @IBOutlet weak var lbl50CharBio: UILabel!
    
    @IBOutlet weak var btnMutualContact: UIButton!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblBioInProfileDetail: UILabel!
    @IBOutlet weak var lblUserNameInProfileDetail: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileSubView: UIView!
    
    @IBOutlet weak var currentSegmentXposition: NSLayoutConstraint!
    @IBOutlet weak var tblProfileDetailMutualContacts: UITableView!
    @IBOutlet weak var lblMutualContactForProfile: UILabel!
    
    @IBOutlet weak var lblSortBio: UILabel!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    @IBOutlet weak var lblYourMutualContactWith: UILabel!
    @IBOutlet weak var txtMyDiscussion: KMPlaceholderTextView!
    
    var selectedMemberObj: MemberObjects?
    var myWishListForUser = [MyWishListForUserObject]()
    var theirWishListForUser = [MyWishListForUserObject]()
    var connectionObjects = [MutualConnectionObject]()
    
    var nextURLForMyWishList = ""
    var nextURLForTheirRequest = ""
    var nextMutualContactURL = ""
    
    var footerView = UIView()
    
    var myCompanies = [Int]()
    
    var totalMutualContacts = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblMutualContactName.text = selectedMemberObj?.handle?.capitalized
        
        lblYourMutualContactWith.text = "Your Mutual Contacts with \(selectedMemberObj!.handle!)"
        
        self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
        self.imgProfilePicture.clipsToBounds = true
        self.imgProfilePicture.layer.borderWidth = 2
        self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
        
        tblProfileDetailMutualContacts.separatorStyle = .none
        
        profileSubView.layer.cornerRadius = 10.0
        profileSubView.clipsToBounds = true
        
        if selectedMemberObj!.mutual! > 100 {
            
            btnMutualContact.setTitle("Mutual Contacts 100+", for: UIControl.State())
        } else {
            btnMutualContact.setTitle("Mutual Contacts \(selectedMemberObj!.mutual!)", for: UIControl.State())
        }

        
        tblMyWishList.separatorStyle = .none
        tblTheirWishList.separatorStyle = .none
        tblMutualContact.separatorStyle = .none
        
        initFooterView()
        
        myWishListView.isHidden = false
        theirWishListView.isHidden = true
        mutualContactView.isHidden = true
        
        lblTheirWishListTitle.text = "Companies you can help \(selectedMemberObj!.handle!) with."
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            print("This is run on the background queue")
            
            self.getMutualContacts()
            self.getProfile()
            
            DispatchQueue.main.async(execute: { () -> Void in
                print("This is run on the main queue, after the previous code in outer block")
                
                self.getMyWishList()
            })
        })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.profileView.isHidden = true
    }
    
    @IBAction func btnWishlistTheirwishlistMutual(_ sender: UIButton) {
        
        let xPosition = sender.frame.origin.x
        
        if sender.tag == 1{

            myWishListView.isHidden = false
            theirWishListView.isHidden = true
            mutualContactView.isHidden = true
        }else if sender.tag == 2{

            myWishListView.isHidden = true
            theirWishListView.isHidden = false
            mutualContactView.isHidden = true
            
            if theirWishListForUser.count == 0 {
                getTheirWishList()
            }
        }else{
            
            myWishListView.isHidden = true
            theirWishListView.isHidden = true
            mutualContactView.isHidden = false
            
            if connectionObjects.count == 0 {
                
                getMutualContacts()
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.currentSegmentXposition.constant = xPosition
            self.view.layoutIfNeeded()
        }
       
    }
    
    
    func getProfile() {
        
        if !rechability.isConnectedToNetwork() {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            return
        }
        
        let theirProfile = WLTheirProfile()
        theirProfile.user = selectedMemberObj!.handle!
        
        theirProfile.theirProfile({(Void, AnyObject) -> Void in
            
            if let response = AnyObject as? [String : AnyObject] {
                
                let bio = response["bio"] as? String ?? ""
                let handle = response["handle"] as? String ?? ""
                let image = response["image"] as? String ?? ""
                let short_bio = response["short_bio"] as? String ?? ""
                let discussion = response["business_discussion"] as? String ?? ""
                let additional = response["business_additional"] as? String ?? ""
                
                self.lblBioInProfileDetail.text = bio
                self.lblUserNameInProfileDetail.text = handle
                self.lbl50CharBio.text = short_bio
                self.lblSortBio.text = short_bio
                self.txtMyDiscussion.text = discussion + "\n\n" + additional
                
                if image != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && image != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" {
                    
                    if image.characters.count > 0 {
                        
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
                
                self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2
                self.imgUserProfile.clipsToBounds = true
                self.imgUserProfile.layer.borderWidth = 2
                self.imgUserProfile.layer.borderColor = UIColor.white.cgColor
                self.imgUserProfile.image = UIImage(data: data)

            }
        }
    }
    
    @IBAction func btnProfileInfoTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = -1
        self.tabBarController?.tabBar.isHidden = true
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(0)
                self.profileView.isHidden = false
            }, completion: { action in
                
        })
    }
    
    @IBAction func btnCancleProfileviewTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                //self.profileView.setY(568)
                self.profileView.isHidden = true
            }, completion: nil)
    }
    
    func initFooterView() {
        
        footerView = UIView(frame: CGRect(x: 0,y: 0,width: 320,height: 40))
        
        let actInd = UIActivityIndicatorView(style: .gray)
        actInd.tag = 10
        actInd.frame = CGRect(x: 150, y: 5, width: 20, height: 20)
        actInd.hidesWhenStopped = true
        footerView.addSubview(actInd)
        
    }
    
    @IBAction func btnStartRequestTapped(_ sender: AnyObject) {
        
        let sendRequestView = self.storyboard?.instantiateViewController(withIdentifier: "SendRequest") as! SendRequestViewController
        
        sendRequestView.handle = selectedMemberObj!.handle!
        sendRequestView.commingFromMemberMatching = true
        sendRequestView.myCompaniesForMemberMatching = myCompanies
        sendRequestView.introducreName = selectedMemberObj!.handle!
        self.navigationController?.pushViewController(sendRequestView, animated: true)
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblMyWishList:
            return myWishListForUser.count
            
        case tblTheirWishList:
            
            return theirWishListForUser.count
            
        case tblMutualContact:
            
            return connectionObjects.count
            
        case tblProfileDetailMutualContacts:
            
            return connectionObjects.count
            
        default:
            0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
            
        case tblMyWishList:
            let cell = tblMyWishList.dequeueReusableCell(withIdentifier: "cell") as! MyWishlistTableViewCell
            
            cell.selectionStyle = .none
            let companyObj = myWishListForUser[indexPath.row]
            
            cell.lblCompanieName.text = companyObj.title
            cell.lblCount.text = "\(companyObj.leads!)"
            
            return cell
            
        case tblTheirWishList:
            
            let cell = tblTheirWishList.dequeueReusableCell(withIdentifier: "cell") as! MyWishlistTableViewCell
            
            cell.selectionStyle = .none
            let companyObj = theirWishListForUser[indexPath.row]
            
            cell.lblCompanieName.text = companyObj.title
            cell.lblCount.text = "\(companyObj.leads!)"
            
            return cell
            
        case tblMutualContact:
            
            let cell = self.tblMutualContact.dequeueReusableCell(withIdentifier: "mutulaContactsCell")! as! MutualContactsTableViewCell
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
            
        case tblProfileDetailMutualContacts:
            
            let cell = self.tblProfileDetailMutualContacts.dequeueReusableCell(withIdentifier: "cell")! as! MutualContactsTableViewCell
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
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if tableView == tblProfileDetailMutualContacts {
            return 62
        } else {
            
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        
        switch tableView {
            
        case tblMyWishList:
            
            if myWishListForUser.count > 7 {
                
                if indexPath.row + 1 == myWishListForUser.count {
                    
                    if nextURLForMyWishList.characters.count > 0 {
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblMyWishList.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            let myWishList = WLMyWishListForUser()
                            myWishList.handle = selectedMemberObj!.handle!
                            myWishList.getMyWishListForUser({(Void, AnyObject) -> Void in
                                
                                loader.hideActivityIndicator(self.view)
                                
                                if let response = AnyObject as? [String: AnyObject] {
                                    
                                    self.nextURLForMyWishList = response["next"] as? String ?? ""
                                    if let results = response["results"] as? [[String: AnyObject]] {
                                        
                                        for company in results {
                                            
                                            let id = company["id"] as? Int ?? 0
                                            let title = company["title"] as? String ?? ""
                                            let mutual = company["mutual"] as? Int ?? 0
                                            let leads = company["leads"] as? Int ?? 0
                                            
                                            self.totalMutualContacts = self.totalMutualContacts + leads
                                            
                                            let compObj = MyWishListForUserObject(id: id, mutual: mutual, title: title, leads: leads)
                                            
                                            self.myCompanies.append(id)
                                            
                                            self.myWishListForUser.append(compObj)
                                        }
                                    }
                                    
                                    self.lblMyWishListTitle.text = "\(self.selectedMemberObj!.handle!) has \(self.totalMutualContacts) contacts at these companies."
                                    self.tblMyWishList.reloadData()
                                    
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
            }
            
        case tblTheirWishList:
            
            if theirWishListForUser.count > 7 {
                
                if indexPath.row + 1 == theirWishListForUser.count {
                    
                    if nextURLForTheirRequest.characters.count > 0 {
                        
                        if rechability.isConnectedToNetwork() {
                            
                            self.tblTheirWishList.tableFooterView = footerView
                            (footerView.viewWithTag(10) as! UIActivityIndicatorView).startAnimating()
                            
                            let getTheirWishListForUser = WLGetTheirWishListForUser()
                            getTheirWishListForUser.handle = selectedMemberObj!.handle!
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
                                    
                                    self.tblTheirWishList.reloadData()
                                    
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
            
        case tblMutualContact, tblProfileDetailMutualContacts:
            
            if rechability.isConnectedToNetwork() {
                
                if connectionObjects.count > 7 {
                    
                    if indexPath.row + 1 == connectionObjects.count {
                        
                        if nextMutualContactURL.characters.count > 0 {
                            
                            self.tblMutualContact.tableFooterView = footerView
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
                                        
                                        self.tblMutualContact.reloadData()
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
            
        default:
            break
        }
    }
    
    func getMyWishList() {
        
        loader.showActivityIndicator(self.view)
        let myWishList = WLMyWishListForUser()
        myWishList.handle = selectedMemberObj!.handle!
        myWishList.getMyWishListForUser({(Void, AnyObject) -> Void in
            
            loader.hideActivityIndicator(self.view)
            
            if let response = AnyObject as? [String: AnyObject] {
                
                self.nextURLForMyWishList = response["next"] as? String ?? ""
                
                if let results = response["results"] as? [[String: AnyObject]] {
                    
                    self.totalMutualContacts = 0
                    
                    for company in results {
                        
                        let id = company["id"] as? Int ?? 0
                        let title = company["title"] as? String ?? ""
                        let mutual = company["mutual"] as? Int ?? 0
                        let leads = company["leads"] as? Int ?? 0
                        
                        self.totalMutualContacts = self.totalMutualContacts + leads
                        
                        self.myCompanies.append(id)
                        
                        let compObj = MyWishListForUserObject(id: id, mutual: mutual, title: title,leads: leads)
                        
                        self.myWishListForUser.append(compObj)
                    }
                }
                
                self.lblMyWishListTitle.text = "\(self.selectedMemberObj!.handle!) has \(self.totalMutualContacts) contacts at these companies."
                self.tblMyWishList.reloadData()
                
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
                print(NSError)
        
        })
    }
    
    func getTheirWishList() {
        
        loader.showActivityIndicator(self.view)
        let getTheirWishListForUser = WLGetTheirWishListForUser()
        getTheirWishListForUser.handle = selectedMemberObj!.handle!
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
                
                self.tblTheirWishList.reloadData()
                
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                loader.hideActivityIndicator(self.view)
        
        })
    }
    
    func getMutualContacts() {
        
        if rechability.isConnectedToNetwork() {
            
            let connections = WLConnection()
            connections.isMutualContacts = true
            connections.contactHandle = selectedMemberObj!.handle!
            connections.getConnections({(Void, AnyObject) -> Void in
                
                self.connectionObjects.removeAll()
                
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
                        self.tblProfileDetailMutualContacts.reloadData()
                    }
                }
                
                }, errorCallback: {(Void, NSError) -> Void in
                    
                    print(NSError)
            })
        } else {
            
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
}
