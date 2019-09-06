//
//  MyAccountProfileViewViewController.swift
//  WishList
//
//  Created by MdSaleem on 17/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import MessageUI
import Mixpanel
//import TSMessages

class MyAccountProfileViewViewController: UIViewController,UIActionSheetDelegate, TSMessageViewProtocol {
    
    @IBOutlet weak var privateView: UIView!
    @IBOutlet weak var publicView: UIView!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgUserPicture: UIImageView!
    
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgPublicProfilePicture: UIImageView!
    @IBOutlet weak var lblPublicUserName: UILabel!
    @IBOutlet weak var txtViewPublicProfileBio: KMPlaceholderTextView!
    @IBOutlet weak var lblShortBio: UILabel!
    @IBOutlet weak var txtWhatIWantToDiscuss: UITextView!
    
    
    var userDict = [String: AnyObject]()
    var privateSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtViewPublicProfileBio.isEditable = false
        txtWhatIWantToDiscuss.isEditable = false
        
        self.imgUserPicture.layer.cornerRadius = self.imgUserPicture.frame.size.width / 2
        self.imgUserPicture.clipsToBounds = true
        self.imgUserPicture.layer.borderWidth = 2
        self.imgUserPicture.layer.borderColor = UIColor.white.cgColor
        
        self.imgPublicProfilePicture.layer.cornerRadius = self.imgPublicProfilePicture.frame.size.width / 2
        self.imgPublicProfilePicture.clipsToBounds = true
        self.imgPublicProfilePicture.layer.borderWidth = 2
        self.imgPublicProfilePicture.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        
        getProfile()
    }
    
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        switch sender.currentTitle! {
        case "Public":
            
            btnPublic.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
            btnPrivate.setBackgroundImage(nil, for: UIControl.State())
            privateView.isHidden = true
            publicView.isHidden = false
            privateSelected = false
            
        case "Private":
            
            btnPrivate.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
            btnPublic.setBackgroundImage(nil, for: UIControl.State())
            privateView.isHidden = false
            publicView.isHidden = true
            privateSelected = true
            
        default:
            break
            
        }
    }
    
    @IBAction func editProfileAction(_ sender: AnyObject) {
        let navigation = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountPubicPrivateViewController") as? MyAccountPubicPrivateViewController
        navigation?.userInfo = userDict
        if privateSelected {
            navigation?.privateViewSelected = true
        }
        self.navigationController?.pushViewController(navigation!, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
                
                self.userDict = dict
                let first_name = dict["first_name"] as? String ?? ""
                let last_name = dict["last_name"] as? String ?? ""
                let phone = dict["phone"] as? String ?? "N/A"
                let email = dict["email"] as? String ?? "N/A"
                let profilePicture = dict["image"] as? String ?? ""
                let title = dict["title"] as? String ?? ""
                var handle = dict["handle"] as? String ?? ""
                let bio = dict["bio"] as? String ?? ""
                let short_bio = dict["short_bio"] as? String ?? ""
                let company = dict["company"] as? String ?? ""
                let discussion = dict["business_discussion"] as? String ?? ""
                let business_additional = dict["business_additional"] as? String ?? ""
                print(discussion)
                
                self.lblTitle.text = title
                self.lblName.text = first_name + " " + last_name
                self.lblAddress.text = company
                self.lblShortBio.text = short_bio
                
                if phone.characters.count > 0 {
                    self.lblPhone.text = phone
                    self.imgPhone.isHidden = false
                } else {
                    self.lblPhone.text = ""
                    self.imgPhone.isHidden = true
                }
                
                if email.characters.count > 0 {
                    self.lblEmail.text = email
                    self.imgEmail.isHidden = false
                } else {
                    self.lblEmail.text = ""
                    self.imgEmail.isHidden = true
                }
                
                self.txtWhatIWantToDiscuss.text = discussion + "\n\n" + business_additional
                print(self.txtWhatIWantToDiscuss)
                
                if handle != ""
                {
                    handle.replaceSubrange(handle.startIndex...handle.startIndex, with: String(handle[handle.startIndex]).capitalized)
                    
                }
                
                self.lblPublicUserName.text = handle
                self.txtViewPublicProfileBio.text = bio
                
                print(profilePicture)
                if profilePicture != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && profilePicture != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" {
                    
                    if profilePicture.contains("http") {
                        
                        if let checkedUrl = URL(string: profilePicture) {
                            self.downloadImage(checkedUrl)
                        }
                    } else {
                        
                        if let checkedUrl = URL(string: WLAppSettings.getBaseUrl() + "/" + profilePicture) {
                            self.downloadImage(checkedUrl)
                        }
                    }
                }
            }
            
            }, errorCallback: { (Void, NSError) -> Void in
                print(NSError)
                loader.hideActivityIndicator(self.view)
        })
        
    }
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error as NSError?)
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
                self.imgUserPicture.layer.cornerRadius = self.imgUserPicture.frame.size.width / 2
                self.imgUserPicture.clipsToBounds = true
                self.imgUserPicture.layer.borderWidth = 2
                self.imgUserPicture.layer.borderColor = UIColor.white.cgColor
                self.imgUserPicture.image = UIImage(data: data)
                
                self.imgPublicProfilePicture.layer.cornerRadius = self.imgUserPicture.frame.size.width / 2
                self.imgPublicProfilePicture.clipsToBounds = true
                self.imgPublicProfilePicture.layer.borderWidth = 2
                self.imgPublicProfilePicture.layer.borderColor = UIColor.white.cgColor
                self.imgPublicProfilePicture.image = UIImage(data: data)
                
            }
        }
    }
}
