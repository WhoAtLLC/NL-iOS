//
//  WLOrganization.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLOrganization: WLModel {
    
    var organization : String? = ""
    var organizationContactCount : NSNumber?
        {
        get{
            if self.organizationContactCount != nil{
                return self.organizationContactCount
            }else{
                return 0
            }
        }
        set{
            self.organizationContactCount = newValue
        }
    }
    
    
    //INIT WITH DICTIONARY
    //===================================================================================================
    fileprivate func initWithDictionary(_ dictionary : NSDictionary)-> NSObject {
        self.organization = getObjectIn(dictionary, keyName: "label", defaultValue: "") as? String
        self.organizationContactCount = getObjectIn(dictionary, keyName: "count", defaultValue: 0) as? NSNumber
        return self
    }
    
    
    //SERIALIZE
    //==================================================================================================
    
    fileprivate func serialize()-> NSDictionary
    {
        let dict = NSMutableDictionary()
        if self.organization  != nil{
            dict.setValue(self.organization, forKey: "label")
        }
        if self.organizationContactCount  != nil{
            dict.setValue(self.organizationContactCount, forKey: "contact_count")
        }
        return dict
    }
    
    
    //GET ORGANIZATIONS
    //==================================================================================================
    
    func organizationsWithSuccess(_ successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.get_ORGANIZATIONS)
        return task
    }
    
    //GET ORGANIZATION TYPE AHEAD
    //==================================================================================================
    
    func organizationTypeAheadWithQuery(_ query : String ,successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.get_ORG_TYPE_AHEAD)
        return task
    }
    
    
}
