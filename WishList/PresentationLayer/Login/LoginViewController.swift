//
//  LoginViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/7/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel

class LoginViewController: UIViewController, TSMessageViewProtocol {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imgPasswordStatus: UIImageView!
    @IBOutlet weak var imgEmailStatus: UIImageView!
    @IBOutlet weak var lblLoginStatus: UILabel!
    @IBOutlet var btnFacebook: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        tfEmail.delegate = self
        tfPassword.delegate = self
        self.imgPasswordStatus.isHidden = true
        self.imgEmailStatus.isHidden = true
        self.lblLoginStatus.isHidden = true
        //        btnFacebook.layer.cornerRadius = 8
        //        btnFacebook.layer.masksToBounds = true
        //        configureFacebook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(pushSettings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
    }
    
    func facebookInstalled() -> Bool {
        if UIApplication.shared.canOpenURL(URL(string: "fb://")!) {
            return true
        }
        return false
    }
    
    //    func configureFacebook() {
    //        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
    //        btnFacebook.delegate = self
    //    }
    
    
    //    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    //        <#code#>
    //    }
    @IBAction func loginWithFB(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((FBSDKAccessToken.current()) != nil){
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if rechability.isConnectedToNetwork() {
                                    
                                    if FBSDKAccessToken.current() != nil {
                                        
                                        loader.showActivityIndicator(self.view)
                                        let registerWithFB = WLRegisterWithFB()
                                        registerWithFB.oauth_token = FBSDKAccessToken.current().tokenString
                                        registerWithFB.registerWithFB({(Void, AnyObject) -> Void in
                                            
                                            loader.hideActivityIndicator(self.view)
                                            if let response = AnyObject as? [String: AnyObject] {
                                                
                                                print(response)
                                                
                                                if let login = response["login"] as? Bool {
                                                    
                                                    if login {
                                                        
                                                        if let token = response["token"] as? String {
                                                            
                                                            WLUserSettings.setAuthToken(token)
                                                            
                                                            let email = (result as AnyObject).object(forKey: "email") as? String
                                                            if email?.characters.count > 0 {
                                                                UserDefaults.standard.set(email!, forKey: "userEmail")
                                                                WLUserSettings.setEmail(email!)
                                                                let mixPanel = Mixpanel.sharedInstance()
                                                                mixPanel?.identify(email!)
                                                                Mixpanel.sharedInstance()?.track("User Logged In", properties:nil)
                                                            }
                                                            
                                                            if let step = response["step"] as? String {
                                                                
                                                                switch step {
                                                                    
                                                                case "contacts":
                                                                    
                                                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                                                    UserDefaults.standard.set(false, forKey: "contactUploaded")
                                                                    UserDefaults.standard.set(false, forKey: "businessSelected")
                                                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                                                    
                                                                    let UploadContactsView = self.storyboard?.instantiateViewController(withIdentifier: "UploadContacts") as! HomeViewController
                                                                    self.navigationController?.pushViewController(UploadContactsView, animated: true)
                                                                    
                                                                case "completed":
                                                                    
                                                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                                                    UserDefaults.standard.set(true, forKey: "businessSelected")
                                                                    UserDefaults.standard.set(true, forKey: "networkSelected")
                                                                    
                                                                    let dashboardView = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
                                                                    self.navigationController?.pushViewController(dashboardView, animated: true)
                                                                    
                                                                case "registration_step_2":
                                                                    
                                                                    UserDefaults.standard.set(false, forKey: "profileComplete")
                                                                    UserDefaults.standard.set(false, forKey: "contactUploaded")
                                                                    UserDefaults.standard.set(false, forKey: "businessSelected")
                                                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                                                    
                                                                    let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
                                                                    SignUpView.isLoginWithFB = true
                                                                    self.navigationController?.pushViewController(SignUpView, animated: true)
                                                                    
                                                                case "companies":
                                                                    
                                                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                                                    UserDefaults.standard.set(false, forKey: "businessSelected")
                                                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                                                    
                                                                    let SetUpBusinessView = self.storyboard?.instantiateViewController(withIdentifier: "SetUpBusinessView") as! SetUpBusinessViewController
                                                                    self.navigationController?.pushViewController(SetUpBusinessView, animated: true)
                                                                    
                                                                case "network":
                                                                    
                                                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                                                    UserDefaults.standard.set(true, forKey: "businessSelected")
                                                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                                                    
                                                                    let SetUpNetworkView = self.storyboard?.instantiateViewController(withIdentifier: "ChooseNetworkViewController") as! ChooseNetworkViewController
                                                                    self.navigationController?.pushViewController(SetUpNetworkView, animated: true)
                                                                    
                                                                default:
                                                                    
                                                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                                                    UserDefaults.standard.set(true, forKey: "businessSelected")
                                                                    UserDefaults.standard.set(true, forKey: "networkSelected")
                                                                    
                                                                    let dashboardView = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
                                                                    self.navigationController?.pushViewController(dashboardView, animated: true)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }, errorCallback: {(Void, NSError) -> Void in
                                            
                                            loader.hideActivityIndicator(self.view)
                                            if let userI = NSError.userInfo as? [String: AnyObject] {
                                                
                                                let rowData = userI[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
                                                guard let test = rowData else {return}
                                                let serializedData = (try? JSONSerialization.jsonObject(with: test, options: [])) as? [String: AnyObject]
                                                
                                                if let APIresult = serializedData?["result"] as? String {
                                                    
                                                    if APIresult == "failure" {
                                                        
                                                        self.registerFBAPI(result as AnyObject)
                                                    }
                                                }
                                            }
                                        })
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func registerFBAPI(_ result: AnyObject) {
        
        let strFirstName = result.object(forKey: "first_name") as? String
        let strLastName = result.object(forKey: "last_name") as? String
        let email = result.object(forKey: "email") as? String
        let strPictureURL = ((result.object(forKey: "picture") as AnyObject).object(forKey: "data") as AnyObject).object(forKey: "url") as? String
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            let registerWithFB = WLRegisterWithFB()
            registerWithFB.oauth_token = FBSDKAccessToken.current().tokenString
            
            registerWithFB.registerWithFB({(Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                if let response = AnyObject as? [String: AnyObject] {
                    
                    if let token = response["token"] as? String {
                        
                        WLUserSettings.setAuthToken(token)
                        let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
                        
                        SignUpView.userEmail = email
                        SignUpView.userLastName = strLastName
                        SignUpView.userFirstName = strFirstName
                        SignUpView.userProfilePicture = strPictureURL
                        SignUpView.isLoginWithFB = true
                        
                        self.navigationController?.pushViewController(SignUpView, animated: true)
                    }
                }
            }, errorCallback: {(Void, NSError) -> Void in
                loader.hideActivityIndicator(self.view)
                if let userI = NSError.userInfo as? [String: AnyObject] {
                    
                    let rowData = userI[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data
                    guard let test = rowData else {return}
                    let serializedData = (try? JSONSerialization.jsonObject(with: test, options: [])) as? [String: AnyObject]
                    
                    if let APIresult = serializedData?["result"] as? String {
                        
                        if APIresult == "failure" {
                            
                            let alert = UIAlertController(title: "Alert", message: APIresult, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
            
        }
    }
    
    /*
     func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
     
     let loginManager = FBSDKLoginManager()
     loginManager.logOut()
     }
     */
    //MARK: - Button Actions
    @IBAction func btnBackTouchUpInside(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: AnyObject) {
        
        let forgetPasswordView = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPasswordViewController
        forgetPasswordView.emailText = tfEmail.text!
        self.navigationController?.pushViewController(forgetPasswordView, animated: true)
    }
    
    @IBAction func btnLoginTouchUpInside(_ sender: AnyObject) {
        
        self.tfEmail.resignFirstResponder()
        self.tfPassword.resignFirstResponder()
        
        if self.tfEmail.text?.characters.count == 0 {
            self.displayAlert("", error: "Please specify the email id.", buttonText: "Ok")
            
        } else if self.tfPassword.text?.characters.count == 0 {
            
            self.displayAlert("", error: "Please specify the password.", buttonText: "Ok")
            
        }
        else if !isValidEmail(self.tfEmail.text!) {
            self.displayAlert("", error: "Please specify a valid email id.", buttonText: "Ok")
        }
        else {
            
            if rechability.isConnectedToNetwork() {
                
                loader.showActivityIndicator(self.view)
                let user = WLUser()
                user.email = self.tfEmail.text ?? ""
                user.password = self.tfPassword.text ?? ""
                
                user.login({ (Void, AnyObject) -> Void in
                    
                    let response = AnyObject as? [String: AnyObject]
                    
                    if response?.count > 0 {
                        
                        if let token = response!["token"] as? String {
                            
                            UserDefaults.standard.set(self.tfEmail.text!, forKey: "userEmail")
                            
                            if let step = response!["step"] as? String {
                                
                                switch step {
                                    
                                case "contacts":
                                    
                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                    UserDefaults.standard.set(false, forKey: "contactUploaded")
                                    UserDefaults.standard.set(false, forKey: "businessSelected")
                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                    
                                    let UploadContactsView = self.storyboard?.instantiateViewController(withIdentifier: "UploadContacts") as! HomeViewController
                                    self.navigationController?.pushViewController(UploadContactsView, animated: true)
                                    
                                case "completed":
                                    
                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                    UserDefaults.standard.set(true, forKey: "businessSelected")
                                    UserDefaults.standard.set(true, forKey: "networkSelected")
                                    
                                    let dashboardView = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
                                    self.navigationController?.pushViewController(dashboardView, animated: true)
                                    
                                case "registration_step_2":
                                    
                                    UserDefaults.standard.set(false, forKey: "profileComplete")
                                    UserDefaults.standard.set(false, forKey: "contactUploaded")
                                    UserDefaults.standard.set(false, forKey: "businessSelected")
                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                    
                                    let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
                                    self.navigationController?.pushViewController(SignUpView, animated: true)
                                    
                                case "companies":
                                    
                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                    UserDefaults.standard.set(false, forKey: "businessSelected")
                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                    
                                    let SetUpBusinessView = self.storyboard?.instantiateViewController(withIdentifier: "SetUpBusinessView") as! SetUpBusinessViewController
                                    self.navigationController?.pushViewController(SetUpBusinessView, animated: true)
                                    
                                case "network":
                                    
                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                    UserDefaults.standard.set(true, forKey: "businessSelected")
                                    UserDefaults.standard.set(false, forKey: "networkSelected")
                                    
                                    let SetUpNetworkView = self.storyboard?.instantiateViewController(withIdentifier: "ChooseNetworkViewController") as! ChooseNetworkViewController
                                    self.navigationController?.pushViewController(SetUpNetworkView, animated: true)
                                    
                                default:
                                    
                                    UserDefaults.standard.set(true, forKey: "profileComplete")
                                    UserDefaults.standard.set(true, forKey: "contactUploaded")
                                    UserDefaults.standard.set(true, forKey: "businessSelected")
                                    UserDefaults.standard.set(true, forKey: "networkSelected")
                                    
                                    let dashboardView = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarViewController
                                    self.navigationController?.pushViewController(dashboardView, animated: true)
                                }
                            }
                            
                            loader.hideActivityIndicator(self.view)
                            WLUserSettings.setAuthToken(token)
                            WLUserSettings.setEmail(self.tfEmail.text!)
                            let mixPanel = Mixpanel.sharedInstance()
                            mixPanel?.identify(self.tfEmail.text!)
                            Mixpanel.sharedInstance()?.track("User Logged In", properties:nil)
                            
                        } else {
                            
                            //                            if let errorResponse = response!["non_field_errors"]{
                            //
                            //                                loader.hideActivityIndicator(self.view)
                            //                                let responseResult = errorResponse[0]
                            //                                showAlert("Alert", message: responseResult as! String, viewController: self)
                            //                                
                            //                            }
                        }
                    }
                }, errorCallback: { (Void, NSError) -> Void in
                    loader.hideActivityIndicator(self.view)
                    
                    let alert = UIAlertController(title: "Alert", message: "Username or Password incorrect.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            } else {
                
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}

extension LoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == self.tfEmail){
            
            self.tfPassword.becomeFirstResponder()
            
        } else if (textField == self.tfPassword){
            
            self.tfPassword.resignFirstResponder()
            
            
            btnLoginTouchUpInside(self)
            
        }
        return true
        
    }
}
