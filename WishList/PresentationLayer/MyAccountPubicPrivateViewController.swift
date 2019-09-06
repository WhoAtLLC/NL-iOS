//
//  MyAccountPubicPrivateViewController.swift
//  WishList
//
//  Created by MdSaleem on 16/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

//import TSMessages

class MyAccountPubicPrivateViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate, RSKImageCropViewControllerDelegate, TSMessageViewProtocol, CountorySelectedDelegate {
    
    @IBOutlet weak var ViewTable: UIView!
    @IBOutlet weak var tableViewtxtField: UITableView!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var privateView: UIView!
    @IBOutlet weak var publicView: UIView!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imgPublicProfile: UIImageView!
    @IBOutlet weak var tblPublic: UITableView!
    @IBOutlet weak var publicTableviewHolder: UIView!
    
    var fullNameTextField = UITextField()
    var titleTextField = UITextField()
    var companyTextField = UITextField()
    var phoneTextField = UITextField()
    var emailTextField = UITextField()
    var twitterTextField = UITextField()
    var linkedinTextField = UITextField()
    var tfLastName = UITextField()
    
    var txtScreenName = UITextField()
    var txtbio = KMPlaceholderTextView()
    var txtBusinessProfile = KMPlaceholderTextView()
    var txtdiscussion = UITextView()
    var txtjobtitle = UITextView()
    
    var lblBioCounter = UILabel()
    var lblBusinessProfileCounter = UILabel()
    var lbldiscussionCounter = UILabel()
    var lblJobTitleCounter = UILabel()
    
    var userInfo = [String: AnyObject]()
    var picker:UIImagePickerController?
    var pickedProfileImage : UIImage?
    var imageChanged = false
    var publicViewSelected = false
    var privateViewSelected = false
    
    var btnCountryCode = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true;
        if privateViewSelected {
            
            btnPrivate.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
            btnPublic.setBackgroundImage(nil, for: UIControl.State())
            privateView.isHidden = false
            publicView.isHidden = true
            privateViewSelected = true
            publicViewSelected = false
        } else {
            publicViewSelected = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyAccountPubicPrivateViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyAccountPubicPrivateViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.imgProfilePicture.layer.cornerRadius = self.imgProfilePicture.frame.size.width / 2
        self.imgProfilePicture.clipsToBounds = true
        self.imgProfilePicture.layer.borderWidth = 2
        self.imgProfilePicture.layer.borderColor = UIColor.white.cgColor
        
        self.imgPublicProfile.layer.cornerRadius = self.imgPublicProfile.frame.size.width / 2
        self.imgPublicProfile.clipsToBounds = true
        self.imgPublicProfile.layer.borderWidth = 2
        self.imgPublicProfile.layer.borderColor = UIColor.white.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyAccountPubicPrivateViewController.selectImage))
        imgProfilePicture.isUserInteractionEnabled = true
        imgProfilePicture.addGestureRecognizer(tapGesture)
        
        let tapGesturePublic = UITapGestureRecognizer(target: self, action: #selector(MyAccountPubicPrivateViewController.selectImagePublic))
        imgPublicProfile.isUserInteractionEnabled = true
        imgPublicProfile.addGestureRecognizer(tapGesturePublic)
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.picker = UIImagePickerController()
            self.picker?.delegate = self
            
        })
        
        if let imageURL = userInfo["image"] as? String {
            print("this is",imageURL)
            if imageURL.length > 0 {
                
                if imageURL != "http://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" && imageURL != "https://s3-us-west-1.amazonaws.com/wishlist.whoat.io/images/wishlist_logo_small.png" {
                    
                    if imageURL.contains("http") {
                        
                        if let checkedUrl = URL(string: imageURL) {
                            self.downloadImage(checkedUrl)
                        }
                    } else {
                        
                        if let checkedUrl = URL(string: WLAppSettings.getBaseUrl() + "/" + imageURL) {
                            print("check url",checkedUrl)
                            self.downloadImage(checkedUrl)
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error as NSError?)
            }) .resume()
    }
    
    func downloadImage(_ url: URL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ))
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
                self.imgPublicProfile.image = UIImage(data: data)
            }
        }
    }
    
    @objc func selectImage() {
        
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
    
    @objc func selectImagePublic() {
        
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
        
        imageChanged = true
        self.imgProfilePicture.image = croppedImage
        self.imgPublicProfile.image = croppedImage
        self.pickedProfileImage = croppedImage
        self.navigationController?.popViewController(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    func addDoneButtonOnKeyboard() -> UIToolbar
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(MyAccountPubicPrivateViewController.doneButtonAction))
        var items: [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }
    
    @objc func doneButtonAction(){
        
        self.tableViewtxtField.contentOffset.y = 0
        self.view.endEditing(true)
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        switch sender.currentTitle! {
        case "Public":
            
            self.view.endEditing(true)
            btnPublic.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
            btnPrivate.setBackgroundImage(nil, for: UIControl.State())
            publicView.isHidden = false
            privateView.isHidden = true
            publicViewSelected = true
            privateViewSelected = false
            
            
        case "Private":
            
            self.view.endEditing(true)
            btnPrivate.setBackgroundImage(UIImage(named: "TheirRequestSelected"), for: UIControl.State())
            btnPublic.setBackgroundImage(nil, for: UIControl.State())
            privateView.isHidden = false
            publicView.isHidden = true
            privateViewSelected = true
            publicViewSelected = false
            
        default:
            break
        }
    }
    

    @objc func openCountryCodeView() {
        
        let ContryCodeView = self.storyboard?.instantiateViewController(withIdentifier: "ContryCodeView") as! ContryCodeViewController
        ContryCodeView.delegate = self
        self.navigationController?.pushViewController(ContryCodeView, animated: true)
    }
    
    func userDidSelectCountoryCode(_ code: String) {
        
        btnCountryCode.setTitle(code, for: UIControl.State())
        
        switch code.characters.count {
            
        case 3:
            
            btnCountryCode.setX(13)
            btnCountryCode.setWidth(45)
            
        case 4:
            
            btnCountryCode.setX(10)
            btnCountryCode.setWidth(45)
            
        case 5:
            
            btnCountryCode.setX(9)
            btnCountryCode.setWidth(85)
            
        default:
            
            break
        }
    }
    
    @IBAction func  backButton(){
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func documentsPathForFileName(_ name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as NSString
        let fullPath = path.appendingPathComponent(name)
        
        return fullPath
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        
        if btnSave.titleLabel?.text == "Edit" {
            
            self.fullNameTextField.isUserInteractionEnabled = true
            self.tfLastName.isUserInteractionEnabled = true
            self.titleTextField.isUserInteractionEnabled = true
            self.companyTextField.isUserInteractionEnabled = true
            self.phoneTextField.isUserInteractionEnabled = true
            self.twitterTextField.isUserInteractionEnabled = true
            self.linkedinTextField.isUserInteractionEnabled = true
            self.imgProfilePicture.isUserInteractionEnabled = true
            self.txtBusinessProfile.isUserInteractionEnabled = true
            self.txtbio.isUserInteractionEnabled = true
            self.btnSave.setTitle("Save", for: UIControl.State())
            
        } else {
            
            if !rechability.isConnectedToNetwork() {
                
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
                return
            }
            
            self.view.endEditing(true)
            
            if fullNameTextField.text?.characters.count > 1 {
                
                if tfLastName.text?.characters.count > 1 {
                    
                    loader.showActivityIndicator(self.view)
                    
                    let updateAccount = WLUpdateAccountInfo()
                    updateAccount.first_name = fullNameTextField.text!
                    updateAccount.title = titleTextField.text!
                    if phoneTextField.text?.length > 0 {
                        
                        
                        updateAccount.phone = "\(btnCountryCode.currentTitle!) \(phoneTextField.text!)"
                        
                    } else {
                        
                        updateAccount.phone = ""
                    }
                    
                    updateAccount.twitter_url = ""
                    updateAccount.company = companyTextField.text!
                    updateAccount.last_name = tfLastName.text!
                    updateAccount.short_bio = txtbio.text!
                    updateAccount.bio = txtBusinessProfile.text!
                    print(txtdiscussion.text!)
                    updateAccount.business_discussion = txtdiscussion.text!
                    updateAccount.business_additional = txtjobtitle.text!
                    
                    if imageChanged {
                        
                        let compressedImage = pickedProfileImage?.highQualityJPEGNSData
                        let relativePath = "profileImage1.jpg"
                        let path = self.documentsPathForFileName(relativePath)
                        try? compressedImage!.write(to: URL(fileURLWithPath: path), options: [.atomic])
                        UserDefaults.standard.set(relativePath, forKey: "path1")
                        
                    } else {
                        
                        UserDefaults.standard.set(nil, forKey: "path1")
                    }
                    
                    updateAccount.updateProfile({(Void, AnyObject) -> Void in
                        
                       print(AnyObject)
                        
                        loader.hideActivityIndicator(self.view)
                        self.btnSave.setTitle("Edit", for: UIControl.State())
                        
                        self.fullNameTextField.isUserInteractionEnabled = false
                        self.tfLastName.isUserInteractionEnabled = false
                        self.titleTextField.isUserInteractionEnabled = false
                        self.companyTextField.isUserInteractionEnabled = false
                        self.phoneTextField.isUserInteractionEnabled = false
                        self.twitterTextField.isUserInteractionEnabled = false
                        self.linkedinTextField.isUserInteractionEnabled = false
                        self.imgProfilePicture.isUserInteractionEnabled = false
                        self.txtbio.isUserInteractionEnabled = false
                        self.txtBusinessProfile.isUserInteractionEnabled = false
                        self.imageChanged = false
                        
                        self.view.endEditing(true)
                        self.navigationController?.popViewController(animated: true)
                        
                        }, errorCallback: {(Void, NSError) -> Void in
                            
                            loader.hideActivityIndicator(self.view)
                            self.view.endEditing(true)
                            let alert = UIAlertController(title: "Alert", message: "Failed!!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    })
                    
                } else {
                    
                    let alert = UIAlertController(title: "Alert", message: "Last name should be at least 2 characters.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                
                let alert = UIAlertController(title: "Alert", message: "First name should be at least 2 characters.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    

    
    
    var isPhoneTextField = false
    var isKeyboardOut = false
    
    @objc func keyboardWillShow(_ sender: Foundation.Notification) {
        
        isKeyboardOut = true
        if publicViewSelected {

//            tblPublic.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
//           publicTableviewHolder.setY(-20)

        } else {

            if isPhoneTextField {
                isPhoneTextField = false
                tableViewtxtField.frame.size.height = 90
            } else {
                tableViewtxtField.frame.size.height = 140
            }
        }
    }
    
    @objc func keyboardWillHide(_ sender: Foundation.Notification) {

        isKeyboardOut = false
        if publicViewSelected {

//            tblPublic.setContentOffset(CGPoint.zero, animated: true)
//           publicTableviewHolder.setY(151)
        } else {
            tableViewtxtField.frame.size.height = 263
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isKeyboardOut {
            if privateViewSelected {
                
                tableViewtxtField.frame.size.height = 140
            }
        }
    }
    

    
    var allCellText = [String: AnyObject]()
    
}

extension MyAccountPubicPrivateViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case self.fullNameTextField:
            self.tfLastName.becomeFirstResponder()
        case self.tfLastName:
            self.titleTextField.becomeFirstResponder()
        case self.titleTextField:
            self.companyTextField.becomeFirstResponder()
        case self.companyTextField:
            self.companyTextField.resignFirstResponder()
            self.phoneTextField.becomeFirstResponder()
        default:
            break
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if (textField == self.fullNameTextField){
            
            self.tableViewtxtField.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
        }else if (textField == self.tfLastName){
            
            self.tableViewtxtField.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
            
        }
        else if (textField == self.titleTextField){
            
            self.tableViewtxtField.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
            
        }else if (textField == self.companyTextField){
            
            self.tableViewtxtField.setContentOffset(CGPoint(x: 0, y: 85), animated: true)
            
        }else if (textField == self.phoneTextField){
            
            isPhoneTextField = true
            self.tableViewtxtField.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
            
        case fullNameTextField:
            
            if textField.text?.length > 0 {
                
                allCellText["fName"] = textField.text as AnyObject
            }
            
        case tfLastName:
            
            if textField.text?.length > 0 {
                
                allCellText["lName"] = textField.text as AnyObject
            }
            
        case titleTextField:
            
            if textField.text?.length > 0 {
                
                allCellText["title"] = textField.text as AnyObject
            }
            
        case companyTextField:
            
            if textField.text?.length > 0 {
                
                allCellText["company"] = textField.text as AnyObject
            }
            
        case phoneTextField:
            
            if textField.text?.length > 0 {
                
                allCellText["phone"] = textField.text as AnyObject
            }
            
        default:
            
            break
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            
        case fullNameTextField:
            
            guard let text = fullNameTextField.text else { return true }
            let newLength = text.utf8.count + string.utf8.count - range.length
            return newLength <= 30
            
        case tfLastName:
            
            guard let text = tfLastName.text else { return true }
            let newLength = text.utf8.count + string.utf8.count - range.length
            return newLength <= 30
            
        case titleTextField:
            
            guard let text = titleTextField.text else { return true }
            let newLength = text.utf8.count + string.utf8.count - range.length
            return newLength <= 30
            
        case companyTextField:
            
            guard let text = companyTextField.text else { return true }
            let newLength = text.utf8.count + string.utf8.count - range.length
            return newLength <= 30
            
        case phoneTextField:
            
            //            guard let text = phoneTextField.text else { return true }
            //            let newLength = text.utf8.count + string.utf8.count - range.length
            //            return newLength <= 12
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString //"".join(components) as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
            
        default:
            
            return true
            
        }
        
    }
    
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if textView == self.txtbio {
//            tblPublic.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
//        }else if textView == self.txtBusinessProfile {
//            tblPublic.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
//        } else if textView == self.txtdiscussion {
//            tblPublic.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
//        }else if textView == self.txtjobtitle {
//            tblPublic.setContentOffset(CGPoint(x: 0, y: 220), animated: true)
//        }
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == txtbio {
            
            if text == "\n" {
                txtBusinessProfile.becomeFirstResponder()
                
            }
            let newLength = textView.text.characters.count + text.characters.count - range.length
            lblBioCounter.text =  "\(String(newLength)) of 50"
            return newLength <= 49
            
        } else if textView == txtdiscussion {
            
            if text == "\n" {
                txtjobtitle.becomeFirstResponder()
            }
            let newLength = textView.text.characters.count + text.characters.count - range.length
            lbldiscussionCounter.text =  "\(String(newLength)) of 200"
            return newLength <= 199
            
        } else if textView == txtjobtitle {
            
            if text == "\n" {
                self.view.endEditing(true)
            }
            let newLength = textView.text.characters.count + text.characters.count - range.length
            lblJobTitleCounter.text =  "\(String(newLength)) of 200"
            return newLength <= 199
            
        } else {
            
            if text == "\n" {
                self.view.endEditing(true)
            }
            let newLength = textView.text.characters.count + text.characters.count - range.length
            lblBusinessProfileCounter.text =  "\(String(newLength)) of 200"
            return newLength <= 199
        }
    }
}

extension MyAccountPubicPrivateViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblPublic {
            
            return 5
        } else {
            
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblPublic {
            
            switch indexPath.row {
                
            case 0:
                
                return 60
            case 1:
                
                return 78
            case 2:
                
                return 150
            case 3:
                
                return 150
            case 4:
                
                return 150
                
            default:
                
                break
            }
        } else {
            
            return 44
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell"+"\(indexPath.row)", for: indexPath)
        
        cell.selectionStyle = .none
        
        if tableView == tblPublic {
            
            switch indexPath.row {
                
            case 0:
                
                txtScreenName = cell.viewWithTag(1) as! UITextField
                txtScreenName.returnKeyType = .next
                var handle = userInfo["handle"] as? String ?? ""
                if handle != "" {
                    handle.replaceSubrange(handle.startIndex...handle.startIndex, with: String(handle[handle.startIndex]).capitalized)
                }
                txtScreenName.text = handle
                txtScreenName.autocapitalizationType = .words
                cell.isUserInteractionEnabled = false
                
            case 1:
                
                txtbio = cell.viewWithTag(2) as! KMPlaceholderTextView
                lblBioCounter = cell.viewWithTag(4) as! UILabel
                
                txtbio.returnKeyType = .next
                txtbio.autocapitalizationType = .sentences
                var bio = userInfo["short_bio"] as? String ?? ""
                if bio.length > 0 {
                    bio.replaceSubrange(bio.startIndex...bio.startIndex, with: String(bio[bio.startIndex]).capitalized)
                }
                if txtbio.text.length == 0 {
                    
                    txtbio.text = bio
                }
                
                txtbio.autocorrectionType = UITextAutocorrectionType.no
                txtbio.delegate = self
                lblBioCounter.text = "\(bio.characters.count) of 50"
                
            case 2:
                
                txtBusinessProfile = cell.viewWithTag(3) as! KMPlaceholderTextView
                lblBusinessProfileCounter = cell.viewWithTag(5) as! UILabel
                
                txtBusinessProfile.returnKeyType = .done
                txtBusinessProfile.autocapitalizationType = .sentences
                txtBusinessProfile.autocorrectionType = UITextAutocorrectionType.no
                var business_discussion = userInfo["bio"] as? String ?? ""
                if business_discussion.length > 0 {
                    business_discussion.replaceSubrange(business_discussion.startIndex...business_discussion.startIndex, with: String(business_discussion[business_discussion.startIndex]).capitalized)
                }
                
                if txtBusinessProfile.text.length == 0 {
                    txtBusinessProfile.text = business_discussion
                }
                
                txtBusinessProfile.delegate = self
                lblBusinessProfileCounter.text = "\(business_discussion.characters.count) of 200"
                
            case 3:
                
                txtdiscussion = cell.viewWithTag(6) as! UITextView
                lbldiscussionCounter = cell.viewWithTag(8) as! UILabel
                
                txtdiscussion.isScrollEnabled = true
                txtdiscussion.isUserInteractionEnabled = true
                txtdiscussion.returnKeyType = .next
                txtdiscussion.autocapitalizationType = .sentences
                txtdiscussion.autocorrectionType = UITextAutocorrectionType.no
                let business_discussion = userInfo["business_discussion"] as? String ?? ""
                
                if txtdiscussion.text.length == 0 {
                    
                    txtdiscussion.text = business_discussion
                }
                
                txtdiscussion.delegate = self
                lbldiscussionCounter.text = "\(business_discussion.characters.count) of 200"
            case 4:
                
                txtjobtitle = cell.viewWithTag(7) as! UITextView
                lblJobTitleCounter = cell.viewWithTag(9) as! UILabel
                
                txtjobtitle.returnKeyType = .done
                txtjobtitle.autocapitalizationType = .sentences
                txtjobtitle.autocorrectionType = UITextAutocorrectionType.no
                let business_discussion = userInfo["business_additional"] as? String ?? ""
                
                if txtjobtitle.text.length == 0 {
                    
                    txtjobtitle.text = business_discussion
                }
                
                txtjobtitle.delegate = self
                lblJobTitleCounter.text = "\(business_discussion.characters.count) of 200"
                
            default:
                
                break
            }
        } else {
            
            switch indexPath.row {
                
            case 0:
                
                fullNameTextField = cell.viewWithTag(101) as! UITextField
                fullNameTextField.returnKeyType = UIReturnKeyType.next
                fullNameTextField.autocorrectionType = UITextAutocorrectionType.no
                fullNameTextField.autocapitalizationType = .words
                
                if let firstName = allCellText["fName"] as? String {
                    fullNameTextField.text = firstName
                } else {
                    
                    let firstName = userInfo["first_name"] as? String ?? ""
                    fullNameTextField.text = firstName
                }
                
            case 1:
                
                tfLastName = cell.viewWithTag(901) as! UITextField
                
                tfLastName.returnKeyType = UIReturnKeyType.next
                tfLastName.autocorrectionType = UITextAutocorrectionType.no
                tfLastName.autocapitalizationType = .words
                
                if let lastName = allCellText["lName"] as? String {
                    tfLastName.text = lastName
                    
                } else {
                    let lastName = userInfo["last_name"] as? String ?? ""
                    tfLastName.text = lastName
                }
                
            case 2:
                titleTextField = cell.viewWithTag(201) as! UITextField
                titleTextField.returnKeyType = UIReturnKeyType.next
                titleTextField.autocorrectionType = UITextAutocorrectionType.no
                
                
                if let title = allCellText["title"] as? String {
                    titleTextField.text = title
                    
                } else {
                    
                    let title = userInfo["title"] as? String ?? ""
                    titleTextField.text = title
                }
                
            case 3:
                
                companyTextField = cell.viewWithTag(301) as! UITextField
                companyTextField.returnKeyType = UIReturnKeyType.next
                companyTextField.autocorrectionType = UITextAutocorrectionType.no
                
                if let company = allCellText["company"] as? String {
                    companyTextField.text = company
                    
                } else {
                    
                    companyTextField.text = userInfo["company"] as? String ?? ""
                }
                
            case 4:
                
                btnCountryCode = cell.viewWithTag(402) as! UIButton
                btnCountryCode.addTarget(self, action: #selector(MyAccountPubicPrivateViewController.openCountryCodeView), for: .touchUpInside)
                
                phoneTextField = cell.viewWithTag(401) as! UITextField
                phoneTextField.autocorrectionType = UITextAutocorrectionType.no
                phoneTextField.keyboardType = UIKeyboardType.numberPad
                phoneTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
                phoneTextField.textAlignment = NSTextAlignment.left
                phoneTextField.inputAccessoryView = addDoneButtonOnKeyboard()
                
                if let phone = allCellText["phone"] as? String {
                    
                    phoneTextField.text = phone
                    
                    
                } else {
                    
                    let phone = userInfo["phone"] as? String ?? ""
                    
                    do {
                        
                        let phoneNumber = try PhoneNumber(rawNumber: phone)
                        print(phoneNumber.nationalNumber)
                        btnCountryCode.setTitle("+\(phoneNumber.countryCode)", for: UIControl.State())
                        let nationalNumber = "\(phoneNumber.nationalNumber)"
                        
                        
                        phoneTextField.text = PartialFormatter().formatPartial(nationalNumber)
                    }
                    catch {
                        print("Generic parser error")
                    }
                }
                
            case 5:
                emailTextField = cell.viewWithTag(501) as! UITextField
                emailTextField.autocorrectionType = UITextAutocorrectionType.no
                emailTextField.isUserInteractionEnabled = false
                
                let email = userInfo["email"] as? String ?? ""
                if email.characters.count > 0 {
                    emailTextField.text = email
                }
                
            default:
                
                print("no cell found")
            }
        }
        return cell
    }
    
}
