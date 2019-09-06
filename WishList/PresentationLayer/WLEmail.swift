//
//  WLEmail.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit
import AddressBook

class WLEmail: WLModel {
    
    var emailAddress : String? = ""
    var emailDomain : String? = ""
    var emailType : String? = ""
    var emailIsVerified : NSNumber?
    var emailIsPrimary : NSNumber?
        {
        get {
            return self.emailIsPrimary
        }
        set {
            self.emailIsPrimary = newValue
        }
    }
    
    var emailIsVerifiedValue : Bool?
        {
        get {
            return self.emailIsVerifiedValue
        }
        set {
            self.emailIsVerified = newValue as! NSNumber
        }
    }
    var emailIsPrimaryValue : Bool?
    
    //INIT WITH ADDRESS BOOK REF
    //===================================================================================================
    func initWithEmailsRef(_ emailsRef : ABMultiValue?)->NSArray?
    {
        let emails = NSMutableArray()
        if emailsRef != nil {
            let count : CFIndex = ABMultiValueGetCount(emailsRef)
            
            for i in 0..<count
            {
                let email = WLEmail()
                if (ABMultiValueCopyLabelAtIndex(emailsRef, i) != nil){
                
                    let locLabel : CFString = ABMultiValueCopyLabelAtIndex(emailsRef, i).takeUnretainedValue() 
                      email.emailType = locLabel as String
                } else {
                
                email.emailType = ""
                }
              
                
                if let emailName = ABMultiValueCopyValueAtIndex(emailsRef, i).takeRetainedValue() as? String
                {
                    email.emailAddress = emailName
                }
                emails.add(email)
            }
        }
        return emails
    }
    
    //INIT WITH DICTIONARY
    //===================================================================================================
    fileprivate func initWithDictionary(_ dictionary : NSDictionary)-> NSObject {
        self.emailAddress = getObjectIn(dictionary, keyName: "label", defaultValue: "") as? String
        self.emailType = getObjectIn(dictionary, keyName: "tag", defaultValue: "") as? String
        self.emailDomain = getObjectIn(dictionary, keyName: "domain", defaultValue: "") as? String
        self.emailIsPrimary = getObjectIn(dictionary, keyName: "primary", defaultValue: 0) as? NSNumber
        self.emailIsVerified = getObjectIn(dictionary, keyName: "verified", defaultValue: "") as? NSNumber
        return self
    }
    
    
    fileprivate func initWithDictionaries(_ dictionaries : NSArray)-> NSArray {
        let array = NSMutableArray()
        
        for dict in dictionaries{
            array.add(dict)
        }
        return array
    }
    
    //SERIALIZE
    //==================================================================================================
    
    func serialize()-> NSDictionary
    {
        let dict = NSMutableDictionary()
        if self.emailAddress  != nil{
            dict.setValue(self.emailAddress, forKey: "value")
        }
        if self.emailType  != nil{
            dict.setValue(self.emailType?.removeSpecialCharacters(), forKey: "label")
        }
        if self.emailDomain  != nil{
            dict.setValue(self.emailDomain, forKey: "domain")
        }
        if self.emailIsPrimary  != nil{
            dict.setValue((self.emailIsPrimaryValue == true) ? 1 : 0, forKey: "primary")
        }
        if self.emailIsVerified  != nil{
            dict.setValue((self.emailIsVerifiedValue == true) ? 1 : 0, forKey: "verified")
        }
        return dict
    }
    
    
    //SEND RESET PASSWORD EMAIL
    //==================================================================================================
    
    func sendResetPasswordToEmail(_ email : String ,successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.reset_PASSWORD)
        return task
    }
    
    //SEND INVITE PREVIEW EMAIL
    //==================================================================================================
    
    func sendInvitePreviewWithSuccess(_ successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.send_INVITE_PREVIEW)
        return task
    }
    
    //SEND VALIDATION EMAIL
    //==================================================================================================
    
    
    func sendValidationToEmail(_ email : String ,successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.send_VALIDATION)
        return task
    }
    
    //GET SIMILAR DOMAINS
    //==================================================================================================
    
    func similarDomainsWithSuccess(_ successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.get_SIMILAR_DOMAINS)
        return task
    }
    
    //IS FREEMAIL
    //==================================================================================================
    
    func isFreemail(_ email : String ,successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.is_FREEMAIL)
        return task
    }
    
}
