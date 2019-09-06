//
//  ForgotPasswordViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/8/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
//import TSMessages

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate, TSMessageViewProtocol {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSend: UIBarButtonItem!
    @IBOutlet weak var lblEmail: UILabel!
    
    var emailText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfEmail.text = emailText
        
        self.lblErrorMessage.isHidden = true
        self.imgStatus.isHidden = true
        
        self.toolBar.removeFromSuperview()
        self.tfEmail.inputAccessoryView = self.toolBar
        
        tfEmail.addTarget(self, action:#selector(ForgotPasswordViewController.edited), for: UIControl.Event.editingChanged)
        tfEmail.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0xF9F9F9)
    }
    
    //MARK: - Button Actions
    
    @IBAction func btnBackTouchUpInside(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }

   
    @IBAction func btnSendClicked(_ sender: AnyObject) {
        
        tfEmail.resignFirstResponder()
        if(self.tfEmail.text?.characters.count == 0){
            self.displayAlert("", error: "Please specify the email id.", buttonText: "Ok")
        }else if (self.tfEmail.text?.lowercased() == "xxxxxx"){
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ChooseServerVC") as! ChooseServerVC
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if(!isValidEmail(self.tfEmail.text!)){
            self.displayAlert("", error: "Please specify a valid email id.", buttonText: "Ok")
        } else {
            
            if rechability.isConnectedToNetwork() {
                loader.showActivityIndicator(self.view)
                
                let fgModel = TGForgotPassword()
                let emailStr =  tfEmail.text!
                fgModel.email = tfEmail.text ?? emailStr
                fgModel.forgotpassword({ (Void, AnyObject) -> Void in
                    
                    loader.hideActivityIndicator(self.view)
                    self.lblErrorMessage.isHidden = true
                    let response = AnyObject as! [String: AnyObject]
                    if let _ = response["error"] as? String {
                        self.displayAlert("", error: "Please enter registerd email id.", buttonText: "Ok")
                    } else {
                        self.displayAlert("", error: "Email sent successfully. Please check your email.", buttonText: "Ok")
                    }
                    }, errorCallback: { (Void, NSError) -> Void in
                        print(NSError)
                        loader.hideActivityIndicator(self.view)
                        self.lblErrorMessage.isHidden = false
                })
            } else {
                TSMessage.showNotification(in: self, title: "Alert", subtitle: "The internet connection seems to be down. Please check!", type: TSMessageNotificationType.error)
            }
        }
        
        
    }
    
    //MARK: - Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        btnSendClicked(btnSend)
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblEmail.isHidden = true
    }
    
    @objc func edited() {
        if tfEmail.text == "" {
            
            lblEmail.isHidden = false
        } else {
            
            lblEmail.isHidden = true
        }
    }
}
