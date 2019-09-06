//
//  WLContact.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit
import AddressBook


enum ContactSource {
    case contactSourceBlank
    case contactSourceFriend
    case contactSourceOrganization
    case contactSourcePersonal
    case contactSourceGroup
}

enum FriendStatus {
    case friendStatusUnknown
    case friendStatusPending
    case friendStatusIsFriend
    case friendStatusIsNotFriend
}

enum MemberStatus {
    case memberStatusUnknown
    case memberStatusPending
    case memberStatusIsMember
    case memberStatusNotMember
}


class WLContact: WLModel {
    
    //PROPS
    var contactLabel : String? = ""
    var contactFirstName : String? = ""
    var contactMiddleName : String? = ""
    var contactLastName : String? = ""
    var contactNickname : String? = ""
    var contactAppleID : String? = ""
    var contactAvatar : String? = ""
    var contactIsHidden : NSNumber? = 0
    var contactMemberStatus : NSNumber? = 0
    var contactSource : NSNumber? = 0
    var contactFriendStatus : NSNumber? = 0
    var dateCreated : String? = ""
    var contactModifiedDate : String? = ""
    var contactJobTitle : String? = ""
    var contactCompany : String? = ""
    
    var contactIsInvitable : NSNumber? {
        
        get {
            return (self.contactIsInvitable != nil) ? self.contactIsInvitable : 0
        }
        
        set {
            self.contactIsInvitable = newValue
        }
    }
    
    //DERIVED
    var contactIsHiddenValue : Bool?
        {
        get {
            return (self.contactIsHiddenValue != nil) ? self.contactIsHiddenValue : false
        }
        
        set {
            self.contactIsHiddenValue = newValue
        }
    }
    var contactSourceUnsigned : UInt?
        {
        get{
            return (self.contactSourceUnsigned != nil) ? self.contactSourceUnsigned : 0
        }
        
        set{
            self.contactSourceUnsigned = newValue
        }
    }
    var contactMemberStatusEnum : MemberStatus?
        {
        get{
            return (self.contactMemberStatusEnum != nil) ? self.contactMemberStatusEnum : .memberStatusUnknown
        }
        
        set{
            self.contactMemberStatusEnum = newValue
        }
    }
    var contactFriendStatusEnum : FriendStatus?{
        get{
            return (self.contactFriendStatusEnum != nil) ? self.contactFriendStatusEnum : .friendStatusUnknown
        }
        
        set{
            self.contactFriendStatusEnum = newValue
        }
        
    }
    var contactIsInvitableValue : Bool?
        {
        get {
            return (self.contactIsInvitableValue != nil) ? self.contactIsInvitableValue : false
        }
        
        set {
            self.contactIsInvitableValue = newValue
        }
    }
    
    //RELATIONSHIPS
    var contactTitle : WLTitle?
    var contactOrganization : WLOrganization?
    var contactPhones : NSArray?
    var contactEmails : NSArray?
    var contactAddresses : NSArray?
    var contactSocialProfiles : NSArray?
    var contactUrls : NSArray?
    var contactNetworks : NSArray?
    var contactStreams : NSArray?
    
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    //INIT WITH ADDRESS BOOK REF
    //===================================================================================================
    func initWithAddressBookRecord(_ recordRef : ABRecord?) -> WLContact
    {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        
        if let contactLabel = ABRecordCopyCompositeName(recordRef)
        {
            self.contactLabel = convertCfTypeToString1(contactLabel)
        }
        
        if let contactFirstName = ABRecordCopyValue(recordRef, kABPersonFirstNameProperty)
        {
            self.contactFirstName = convertCfTypeToString(contactFirstName)
        }
        
        if let contactMiddleName = ABRecordCopyValue(recordRef, kABPersonMiddleNameProperty)
        {
            self.contactMiddleName = convertCfTypeToString(contactMiddleName)
        }
        
        if let contactCompany = ABRecordCopyValue(recordRef, kABPersonOrganizationProperty)
        {
            self.contactCompany = convertCfTypeToString(contactCompany)!
        }
        
        if let contactJobTitle = ABRecordCopyValue(recordRef, kABPersonJobTitleProperty)
        {
            self.contactJobTitle = convertCfTypeToString(contactJobTitle)
        }
        
        if let contactLastName = ABRecordCopyValue(recordRef, kABPersonLastNameProperty)
        {
            self.contactLastName = convertCfTypeToString(contactLastName)
        }
        
        if let contactOrganization = ABRecordCopyValue(recordRef, kABPersonOrganizationProperty)
        {
            let org = WLOrganization()
            org.organization = convertCfTypeToString(contactOrganization)
            self.contactOrganization = org
        }
        
        if let contactJobTitle = ABRecordCopyValue(recordRef, kABPersonJobTitleProperty)
        {
            let title = WLTitle()
            title.title = convertCfTypeToString(contactJobTitle)
            self.contactTitle = title
        }
        
        self.contactAppleID = "\(ABRecordGetRecordID(recordRef))"
        
        if let contactCreatedDate = ABRecordCopyValue(recordRef, kABPersonCreationDateProperty)
        {
            
            self.dateCreated = convertCfTypeToString(contactCreatedDate)
        }
        
        if let contactModifiedDate = ABRecordCopyValue(recordRef, kABPersonModificationDateProperty)
        {
            self.contactModifiedDate = convertCfTypeToString(contactModifiedDate)
        }
        
        
        // Phones
        if let phonesRef = ABRecordCopyValue(recordRef, kABPersonPhoneProperty)
        {
            let phonesss: ABMultiValue = phonesRef.takeUnretainedValue() as ABMultiValue
            //            let allPhones = ABMultiValueCopyArrayOfAllValues(phones).takeRetainedValue() as NSArray
            
            let phones = WLPhone().initWithPhonesRef(phonesss)
            
            if phones != nil && phones!.count > 0
            {
                self.contactPhones = phones
            }
            
        }
        
        // Emails
        if let emailProperty: ABMultiValue = ABRecordCopyValue(recordRef, kABPersonEmailProperty).takeRetainedValue() as ABMultiValue {
            
            if ABMultiValueGetCount(emailProperty) > 0 {
                let allEmailIDs: NSArray = ABMultiValueCopyArrayOfAllValues(emailProperty).takeUnretainedValue() as NSArray
                print(allEmailIDs)
                self.contactEmails = allEmailIDs
            }
        }
        
        return self
    }
    
    
    //INIT WITH DICTIONARY
    //===================================================================================================
    fileprivate func initWithDictionary(_ dictionary : NSDictionary)-> NSObject {
        
        return self
    }
    
    
    func serialize()->NSMutableDictionary
    {
        
        let dict = NSMutableDictionary()
        if self.contactFirstName  != nil{
            dict.setValue(self.contactFirstName, forKey: "firstName")
        }
        
        if self.contactMiddleName  != nil{
            dict.setValue(self.contactMiddleName, forKey: "middleName")
        }
        
        if self.contactLastName  != nil{
            dict.setValue(self.contactLastName, forKey: "lastName")
        }
        
        if self.contactCompany != nil{
            dict.setValue(self.contactCompany, forKey: "company")
        }
        
        if self.contactJobTitle  != nil{
            dict.setValue(self.contactJobTitle, forKey: "jobtitle")
        }
        
        if self.contactNickname  != nil{
            dict.setValue(self.contactNickname, forKey: "nickname")
        }
        
        if self.contactLabel  != nil{
            dict.setValue(self.contactLabel, forKey: "label")
        }
        
        if self.contactNickname  != nil{
            dict.setValue(self.contactNickname, forKey: "nickname")
        }
        
        if self.contactAppleID  != nil{
            dict.setValue(self.contactAppleID, forKey: "key")
        }
        
        if self.dateCreated  != nil{
            dict.setValue(self.dateCreated, forKey: "creationDate")
        }
        
        if self.contactModifiedDate  != nil{
            dict.setValue(self.contactModifiedDate, forKey: "modificationDate")
        }
        
        
        if self.contactEmails?.count > 0
        {
            let emails = NSMutableArray()
            for i in 0..<self.contactEmails!.count {
                
//                if let email : WLEmail = self.contactEmails![i] as? WLEmail
                if let email = self.contactEmails![i] as? String
                {
                    if validateEmail(email) {
                        emails.add(email)
                    }
                }
                
            }
            dict.setValue(emails, forKey: "emails")
        }
        
        
        if self.contactPhones?.count > 0
        {
            let phones = NSMutableArray()
            for i in 0..<self.contactPhones!.count
            {
                if let phone : WLPhone = self.contactPhones![i] as? WLPhone
                {
                    phones.add(phone.serialize())
                }
                
            }
            dict.setValue(phones, forKey: "phones")
        }
        
        return dict
        
    }
    
}
