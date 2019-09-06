//
//  WLModel.swift
//  WishList
//
//  Created by Dharmesh on 05/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit
import AddressBook

class WLModel: NSObject {
    
    
    internal func getObjectIn(_ dict : NSDictionary, keyName : String , defaultValue : Any)->Any
    {
        if let value: Any = dict.object(forKey: keyName) {
            return value
        }else{
            return defaultValue
        }
    }
    internal func convertCfTypeToString1(_ cfValue: Unmanaged<CFString>!) -> String?{
        
        /* Coded by Vandad Nahavandipoor */
        
        let value = Unmanaged.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFString
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        }
        else  if let value = cfValue.takeRetainedValue() as? String
        {
            return value
        }
        else {
            return nil
        }
    }
    
    internal func convertCfTypeToString(_ cfValue: Unmanaged<AnyObject>!) -> String?{
        
        /* Coded by Vandad Nahavandipoor */
        
        let value = Unmanaged.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFString
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else  if let value: AnyObject = cfValue.takeRetainedValue() as? AnyObject
        {
            let valu = value.description
            return valu as! String
        }
        else {
            return nil
        }
    }
    
}
