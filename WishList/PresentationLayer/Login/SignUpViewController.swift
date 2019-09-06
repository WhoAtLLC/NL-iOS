//
//  SignUpViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/7/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import Mixpanel


class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, TSMessageViewProtocol {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfScreenName: UITextField!
    
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    
    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var lblScreenNameCondition: UILabel!
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lastSeperaterLine: UILabel!
    @IBOutlet weak var lastSeparatorLineTopConstraint: NSLayoutConstraint!
    
    
    var picker:UIImagePickerController?
    var pickedProfileImage: UIImage?
    
    var isLoginWithFB = false
    var userFirstName: String?
    var userLastName: String?
    var userEmail: String?
    var userProfilePicture: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .default
        
        let titleString : NSMutableAttributedString = NSMutableAttributedString(string: btnTerms.titleLabel!.text!)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, btnTerms.titleLabel!.text!.characters.count))
        btnTerms.setAttributedTitle(titleString, for: UIControl.State())
        
        let titleStringPrivacy : NSMutableAttributedString = NSMutableAttributedString(string: btnPrivacy.titleLabel!.text!)
        titleStringPrivacy.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, btnPrivacy.titleLabel!.text!.characters.count))
        btnPrivacy.setAttributedTitle(titleStringPrivacy, for: UIControl.State())
        
        imgPhoto.contentMode = UIView.ContentMode.scaleAspectFill
        imgPhoto.layer.masksToBounds = false
        imgPhoto.layer.cornerRadius = self.imgPhoto.frame.height / 2
        imgPhoto.clipsToBounds = true
        tfEmail.placeholder = "Email"
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.picker = UIImagePickerController()
            self.picker?.delegate = self
            
        })
        
        if isLoginWithFB {
            
            let firstName = UserDefaults.standard.object(forKey: "ffname") as? String ?? ""
            let lastName = UserDefaults.standard.object(forKey: "flname") as? String ?? ""
            let email = UserDefaults.standard.object(forKey: "femail") as? String ?? ""
            let picture = UserDefaults.standard.object(forKey: "fpicture") as? String ?? ""
            
            userEmail = email
            userProfilePicture = picture
            
            tfLastName.text = lastName
            tfFirstName.text = firstName
            if userProfilePicture?.characters.count > 0 {
                imgPhoto.makeThisRound
               imgPhoto.hnk_setImageFromURL(URL(string: userProfilePicture!)!)
            }
            
            if userEmail?.characters.count == 0 {
                
                tfScreenName.returnKeyType = .next
                
            } else {
                
                if userEmail?.characters.count > 0 {
                    
                    tfEmail.text = userEmail!
                    tfEmail.isUserInteractionEnabled = false
                    tfScreenName.returnKeyType = .done
                    tfEmail.isHidden = false
                }
            }
            
        } else {
            
            tfEmail.isHidden = true
            //lastSeperaterLine.setY(296)
            lastSeparatorLineTopConstraint.constant = 1000
            tfScreenName.returnKeyType = .done
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
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
    
    // MARK: - Text Field Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if (textField == self.tfFirstName){
            
            self.scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else if (textField == self.tfLastName){
           
             self.scrollView .setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        else if (textField == self.tfScreenName){
           
            self.scrollView .setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        } else if (textField == self.tfEmail){
            
            self.scrollView .setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == self.tfFirstName){
            
            self.tfLastName.becomeFirstResponder()
        }
        else if (textField == self.tfLastName){
            
            self.tfScreenName.becomeFirstResponder()
            
        } else if (textField == self.tfScreenName){
        
            if !isLoginWithFB {
                
                self.tfScreenName.resignFirstResponder()
                self.scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                
            } else {
                
                if userEmail?.characters.count > 0 {
                    
                    self.tfScreenName.resignFirstResponder()
                    self.scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    textField.resignFirstResponder()
                    
                } else {
                    
                    self.tfEmail.becomeFirstResponder()
                }
            }
           
        } else {
            
            self.scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.tfScreenName){
            
            if(textField.text?.characters.count == 0 && string.characters.count == 1){
                
                self.lblScreenName.isHidden = true;
                self.lblScreenNameCondition.isHidden = true;
            }
            else if(textField.text?.characters.count == 1 && string.characters.count == 0){
                
                self.lblScreenName.isHidden = false;
                self.lblScreenNameCondition.isHidden = false;
            }
            
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 20
        }
        
        return true;
    }
    
    // MARK: - Button actions
    
    @IBAction func btnBackTouchUpInside(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func photoTapped(_ sender: AnyObject) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default)
        {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            {
                UIAlertAction in
                
        }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func btnRegisterTouchUpInside(_ sender: AnyObject) {
        
        let spaceCount = tfScreenName.text!.characters.filter{$0 == " "}.count
        
        if self.tfFirstName.text?.characters.count == 0 {
            
            self.displayAlert("", error: "Please enter your first name.", buttonText: "Ok")
        }
        else if (self.tfLastName.text?.characters.count == 0){
            self.displayAlert("", error: "Please enter your last name.", buttonText: "Ok")

        }
        else if (self.tfScreenName.text?.characters.count == 0){
            self.displayAlert("", error: "Please enter your desired screen name.", buttonText: "Ok")
            
        } else if tfScreenName.text?.characters.count < 4 {
            self.displayAlert("", error: "Screen Name should be at least 4 characters.", buttonText: "Ok")
        } else if tfFirstName.text?.characters.count < 2 {
            self.displayAlert("", error: "First Name should be at least 2 characters.", buttonText: "Ok")
        } else if tfLastName.text?.characters.count < 2 {
            self.displayAlert("", error: "Last Name should be at least 2 characters.", buttonText: "Ok")
        } else if spaceCount > 1 {
            self.displayAlert("", error: "Username must have no more than 1 space.", buttonText: "Ok")
            
        } else if isLoginWithFB {
            
            if tfEmail.text?.characters.count > 0 {
                
                if !tfEmail.text!.isEmail {
                    
                    self.displayAlert("", error: "Please Enter Valid Email.", buttonText: "Ok")
                } else {
                    
                    profileApiCalling()
                }
            } else {
                
                self.displayAlert("", error: "Please Enter Email.", buttonText: "Ok")
            }
            
        } else {
            profileApiCalling()
        }
    }
    
    func profileApiCalling(){
        
        if rechability.isConnectedToNetwork() {
            
            loader.showActivityIndicator(self.view)
            
            let profileModel = WLProfile()
            profileModel.firstname = tfFirstName.text!
            profileModel.lastname = tfLastName.text!
            profileModel.handle = tfScreenName.text!
            
            if isLoginWithFB {
                
                profileModel.userEmail = tfEmail.text!
                pickedProfileImage = imgPhoto.image
            }
            
            if pickedProfileImage != nil {
                
                let compressedImage = pickedProfileImage?.highQualityJPEGNSData
                let relativePath = "profileImage.jpg"
                let path = self.documentsPathForFileName(relativePath)
                try? compressedImage!.write(to: URL(fileURLWithPath: path), options: [.atomic])
                UserDefaults.standard.set(relativePath, forKey: "path")
                
            } else {
                
                UserDefaults.standard.set(nil, forKey: "path")
            }
            
            profileModel.profile({ (Void, AnyObject) -> Void in
                
                loader.hideActivityIndicator(self.view)
                
                UserDefaults.standard.set(nil, forKey: "ffname")
                UserDefaults.standard.set(nil, forKey: "flname")
                UserDefaults.standard.set(nil, forKey: "femail")
                UserDefaults.standard.set(nil, forKey: "fpicture")
                UserDefaults.standard.set(false, forKey: "floginattempt")
                
                let dict = AnyObject as! [String: AnyObject]
                print(dict)
                if dict.count > 0 {
                    if let user = dict["user"] as? Int {
                        let handle = dict["handle"] as! String
                        print(user)
                        WLUserSettings.setUser("\(user)")
                        WLUserSettings.setHandle(handle)
                        
                        if self.isLoginWithFB {
                            
                            if self.userEmail?.characters.count > 0 {
                                
                                UserDefaults.standard.set(self.userEmail!, forKey: "userEmail")
                                WLUserSettings.setEmail(self.userEmail)
                            }
                        }
                        
                        let mixPanel = Mixpanel.sharedInstance()
                        mixPanel?.createAlias(WLUserSettings.getEmail()!, forDistinctID: (mixPanel?.distinctId)!)
                        mixPanel?.people.set([
                            "$email": WLUserSettings.getEmail()!,
                            "$first_name": self.tfFirstName.text!,
                            "$last_name": self.tfLastName.text!,
                            "$created": Date(),
                            "$name": "\(self.tfFirstName.text!) \(self.tfLastName.text!)",
                            ]);
                        mixPanel?.identify(WLUserSettings.getEmail()!)
                        Mixpanel.sharedInstance()?.track("Sign UP", properties:["UserName": WLUserSettings.getEmail()!])
                        
                        UserDefaults.standard.set(true, forKey: "profileComplete")
                        let UploadContactsView = self.storyboard?.instantiateViewController(withIdentifier: "UploadContacts") as! HomeViewController
                        self.navigationController?.pushViewController(UploadContactsView, animated: true)
                    } else {
                        
                        print(dict)
                        if let message = dict["message"] as? String {
                            self.displayAlert("", error: message, buttonText: "Ok")
                        }
                    }
                }
                
                }, errorCallback: { (Void, NSError) -> Void in
                    print(NSError)
                    loader.hideActivityIndicator(self.view)
                    if let userI = NSError.userInfo as? [String: AnyObject] {
                        
                        if let rowData = userI[AFNetworkingOperationFailingURLResponseDataErrorKey] as? Data {
                            if let serializedData = (try? JSONSerialization.jsonObject(with: rowData, options: [])) as? [String: AnyObject] {
                                
                                if let title = serializedData["handle"] as? [String] {
                                    
                                    if title[0] == "This field must be unique." {
                                        let alert = UIAlertController(title: "Alert", message: "Screen name must be unique.", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
            })
            
        } else {
            TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
        }
    }
    
    func documentsPathForFileName(_ name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as NSString
        let fullPath = path.appendingPathComponent(name)
        
        return fullPath
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //MARK: - Image Picker Controller 
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker!.sourceType = UIImagePickerController.SourceType.camera
            self .present(picker!, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        pickedProfileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        
        let imageCropVC = RSKImageCropViewController(image: pickedProfileImage!)
        imageCropVC.delegate = self
        self.navigationController?.pushViewController(imageCropVC, animated: true)
    }
    
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        self.imgPhoto.layer.cornerRadius = self.imgPhoto.frame.size.width / 2
        self.imgPhoto.clipsToBounds = true
        self.imgPhoto.layer.borderWidth = 2
        self.imgPhoto.layer.borderColor = UIColor.white.cgColor
        self.imgPhoto.image = croppedImage
        self.pickedProfileImage = croppedImage
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
