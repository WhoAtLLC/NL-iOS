//
//  WLPhone.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit
import AddressBook

class WLPhone: WLModel {
    
    var phoneNumber : String? = ""
    var phoneType : String? = ""
    var phoneIsPrimaryValue : Bool?  = false
    var phoneIsPrimary : NSNumber?
        {
        get {
            return 0
        }
        set {
            self.phoneIsPrimary = newValue
        }
    }
    
    //INIT WITH ADDRESS BOOK REF
    //===================================================================================================
    
    func initWithPhonesRef(_ phonesRef : ABMultiValue?)->NSArray?
    {
        let phones = NSMutableArray()
        if phonesRef != nil {
            let count : CFIndex = ABMultiValueGetCount(phonesRef)
            
            for i in 0..<count
            {
                let phone = WLPhone()
                if (ABMultiValueCopyLabelAtIndex(phonesRef, i) != nil) {
                    
                    let locLabel : CFString = ABMultiValueCopyLabelAtIndex(phonesRef, i).takeUnretainedValue() as CFString
                    phone.phoneType = locLabel as String
                    
                } else {
                    phone.phoneType = ""
                    
                }
                if let phoneNumber = ABMultiValueCopyValueAtIndex(phonesRef, i).takeRetainedValue() as? String
                {
                    phone.phoneNumber = phoneNumber
                }
                phones.add(phone)
            }
        }
        return phones
    }
    
    //INIT WITH DICTIONARY
    //===================================================================================================
    fileprivate func initWithDictionary(_ dictionary : NSDictionary)-> NSObject {
        self.phoneNumber = getObjectIn(dictionary, keyName: "label", defaultValue: getObjectIn(dictionary, keyName: "value", defaultValue: "")) as? String
        self.phoneType = getObjectIn(dictionary, keyName: "type", defaultValue: getObjectIn(dictionary, keyName: "type", defaultValue: "tag")) as? String
        self.phoneIsPrimary = (getObjectIn(dictionary, keyName: "primary", defaultValue: 0) as? NSNumber)!
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
        if self.phoneNumber  != nil{
            dict.setValue(self.phoneNumber, forKey: "value")
        }
        if self.phoneType  != nil{
            dict.setValue(self.phoneType?.removeSpecialCharacters(), forKey: "label")
        }
        if self.phoneIsPrimary?.int32Value  != 0 {
            dict.setValue((self.phoneIsPrimary == true) ? 1 : 0, forKey: "primary")
        }else{
            dict.setValue(0, forKey: "primary")
        }
        
        
        return dict
    }
    
}

extension String
{
    func removeSpecialCharacters()->String
    {
        let charSet = CharacterSet.alphanumerics.inverted
        let cleanedString = self.trimmingCharacters(in: charSet)
        return cleanedString
    }
    
    
}
