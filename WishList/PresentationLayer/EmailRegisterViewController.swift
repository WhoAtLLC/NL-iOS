//
//  EmailRegisterViewController.swift
//  WishList
//
//  Created by Dharmesh on 05/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel

class EmailRegisterViewController: UIViewController, TSMessageViewProtocol {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: HideShowPasswordTextField!
    @IBOutlet weak var lbl6Character: UILabel!
    
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgEyeIcon: UIButton!
    @IBOutlet var btnFacebook: FBSDKLoginButton!
    @IBOutlet weak var dummyFBLoginButton: UIButton!
    
    var fontNameFortxtPassword = UIFont()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.addTarget(self, action: #selector(EmailRegisterViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
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
            
            if FBSDKAccessToken.current().tokenString.characters.count > 0 {
                
                loader.showActivityIndicator(self.view)
                let registerWithFB = WLRegisterWithFB()
                registerWithFB.oauth_token = FBSDKAccessToken.current().tokenString
                registerWithFB.registerWithFB({(Void, AnyObject) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    if let response = AnyObject as? [String: AnyObject] {
                        
                        if let token = response["token"] as? String {
                            
                            WLUserSettings.setAuthToken(token)
                            let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
                            
                            UserDefaults.standard.set(strFirstName, forKey: "ffname")
                            UserDefaults.standard.set(strLastName, forKey: "flname")
                            UserDefaults.standard.set(email, forKey: "femail")
                            UserDefaults.standard.set(strPictureURL, forKey: "fpicture")
                            UserDefaults.standard.set(true, forKey: "floginattempt")
                            
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
                                
                                self.loginButtonDidLogOut(self.btnFacebook)
                                let alert = UIAlertController(title: "Alert", message: APIresult, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                })
            }
        }
    }
    
    func facebookInstalled() -> Bool {
        
        if UIApplication.shared.canOpenURL(URL(string: "fb://")!) {
            return true
        }
        return false
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.lbl6Character.isHidden = true
        
        if textField.text?.characters.count == 0 {
            
            //            imgEyeIcon.hidden = true
            //            lbl6Character.hidden = false
        } else {
            
            //            imgEyeIcon.hidden = false
            //            lbl6Character.hidden = true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.lbl6Character.isHidden = false
        return true
    }
    
    //    var isEncrypted = false
    
    @IBAction func btnEyeIconTapped(_ sender: AnyObject) {
        
        //        if !isEncrypted {
        //            txtPassword.secureTextEntry = false
        //        } else {
        //            txtPassword.secureTextEntry = true
        //        }
        //        isEncrypted = !isEncrypted
        //        txtPassword.font = fontNameFortxtPassword
        //        txtPassword.text = txtPassword.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        let titleString : NSMutableAttributedString = NSMutableAttributedString(string: btnTerms.titleLabel!.text!)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, btnTerms.titleLabel!.text!.characters.count))
        btnTerms.setAttributedTitle(titleString, for: UIControl.State())
        
        let titleStringPrivacy : NSMutableAttributedString = NSMutableAttributedString(string: btnPrivacy.titleLabel!.text!)
        titleStringPrivacy.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, btnPrivacy.titleLabel!.text!.characters.count))
        btnPrivacy.setAttributedTitle(titleStringPrivacy, for: UIControl.State())
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
    }
    
    @IBAction func registerButtonClick(_ sender: AnyObject) {
        
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        if txtEmail.text!.isEmail {
            
            if !txtPassword.text!.isEmpty {
                
                if txtPassword.text?.characters.count > 7 {
                    
                    RegisterApiCalling()
                } else {
                    self.displayAlert("", error: "Password should be at least 8 characters.", buttonText: "Ok")
                }
            } else {
                self.displayAlert("", error: "Please enter password.", buttonText: "Ok")
            }
        } else {
            self.displayAlert("", error: "Please enter valid email.", buttonText: "Ok")
        }
    }
    
    @IBAction func btnBackClicked(_ sender: AnyObject) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTermsClicked(_ sender: AnyObject) {
        
        let TermsandPrivacyView = self.storyboard?.instantiateViewController(withIdentifier: "TermsandPrivacy") as! TermsandPrivacyViewController
        TermsandPrivacyView.strTitle = "Terms & Conditions"
        TermsandPrivacyView.strURL = "https://s3.amazonaws.com/top500golf/assets/docs/Terms+and+Services+Agreement.pdf"
        self.navigationController?.pushViewController(TermsandPrivacyView, animated: true)
    }
    
    @IBAction func btnPrivacyClicked(_ sender: AnyObject) {
        
        let TermsandPrivacyView = self.storyboard?.instantiateViewController(withIdentifier: "TermsandPrivacy") as! TermsandPrivacyViewController
        TermsandPrivacyView.strTitle = "Privacy Policy"
        TermsandPrivacyView.strURL = "https://s3.amazonaws.com/top500golf/assets/docs/Top500_PrivacyPolicy.pdf"
        self.navigationController?.pushViewController(TermsandPrivacyView, animated: true)
    }
    
    func RegisterApiCalling(){
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            
            let rgModel = WLRegister()
            let emailStr = txtEmail.text!
            let passStr = txtPassword.text!
            
            rgModel.email = txtEmail.text ?? emailStr
            rgModel.password = txtPassword.text ?? passStr
            rgModel.register({ (Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                let response = AnyObject as! [String: AnyObject]
                print(response)
                if let token = response["token"] as? String {
                    
                    UserDefaults.standard.set(self.txtEmail.text!, forKey: "userEmail")
                    WLUserSettings.setAuthToken(token)
                    WLUserSettings.setEmail(self.txtEmail.text!)
                    let SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpViewController
                    self.navigationController?.pushViewController(SignUpView, animated: true)
                } else {
                    
                    if let email = response["email"] as? [String] {
                        let alert = UIAlertController(title: "Alert", message: email[0], preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
                
            }, errorCallback: { (Void, NSError) -> Void in
                print(NSError)
                
                
                if let userI = NSError.userInfo as? [String: AnyObject] {
                    
                    if let rowData = userI[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                        if let serializedData = (try? JSONSerialization.jsonObject(with: rowData, options: [])) as? [String: AnyObject] {
                                                        
                            if let email = serializedData["email"] as? [String] {
                                
                                if email[0] == "LoginUser with this email address already exists." {
                                    let alert = UIAlertController(title: "Alert", message: "Email already registered, please try a new one.", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
                
                loader.hideActivityIndicator(self.view)
                
            })
        } else {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if (textField == self.txtEmail){
            
            self.scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if (textField == self.txtPassword){
            
            self.scrollView .setContentOffset(CGPoint(x: 0, y: 50), animated: true)
            //            imgEyeIcon.hidden = false
            lbl6Character.isHidden = true
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtPassword {
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if newString == "" {
                //                lbl6Character.hidden = false
            } else {
                lbl6Character.isHidden = true
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtPassword {
            self.lbl6Character.isHidden = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if (textField == self.txtEmail){
            
            self.txtPassword.becomeFirstResponder()
        }
        else if (textField == self.txtPassword){
            
            self.txtPassword.resignFirstResponder()
            
        }
        // print("return")
        return false
    }
}

extension EmailRegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, textField string: String) -> Bool {
        return txtPassword.textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtPassword.textFieldDidEndEditing(textField)
    }
}

extension EmailRegisterViewController: HideShowPasswordTextFieldDelegate {
    func isValidPassword(_ password: String) -> Bool {
        return password.characters.count > 7
    }
}

extension EmailRegisterViewController {
    fileprivate func setupPasswordTextField() {
        txtPassword.passwordDelegate = self
        txtPassword.delegate = self
        txtPassword.borderStyle = .none
        txtPassword.clearButtonMode = .whileEditing
        txtPassword.layer.borderWidth = 0.5
        txtPassword.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        txtPassword.borderStyle = UITextField.BorderStyle.none
        txtPassword.clipsToBounds = true
        txtPassword.layer.cornerRadius = 0
        
        txtPassword.rightView?.tintColor = UIColor(red: 0.204, green: 0.624, blue: 0.847, alpha: 1)
        
        txtPassword.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 3))
        txtPassword.leftViewMode = .always
    }
}
