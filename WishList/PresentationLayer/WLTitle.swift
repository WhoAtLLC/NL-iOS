//
//  WLTitle.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLTitle: WLModel {
    var title : String? = ""
    var titleContactCount : NSNumber?
        {
        get{
            if self.titleContactCount != nil{
                return self.titleContactCount
            }else{
                return 0
            }
        }
        set{
            self.titleContactCount = newValue
        }
    }
    
    //INIT WITH DICTIONARY
    //===================================================================================================
    fileprivate func initWithDictionary(_ dictionary : NSDictionary)-> NSObject {
        self.title = getObjectIn(dictionary, keyName: "label", defaultValue: "") as? String
        self.titleContactCount = getObjectIn(dictionary, keyName: "count", defaultValue: 0) as? NSNumber
        return self
    }
    
    
    //SERIALIZE
    //==================================================================================================
    
    fileprivate func serialize()-> NSDictionary
    {
        let dict = NSMutableDictionary()
        if self.title  != nil{
            dict.setValue(self.title, forKey: "label")
        }
        if self.titleContactCount  != nil{
            dict.setValue(self.titleContactCount, forKey: "contact_count")
        }
        return dict
    }
    
    
    //GET ORGANIZATIONS
    //==================================================================================================
    
    func titlesWithSuccess(_ successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.get_TITLES)
        return task
    }
    
    //GET ORGANIZATION TYPE AHEAD
    //==================================================================================================
    
    func titleTypeAheadWithQuery(_ query : String ,successCallback: SuccessCallback, errorCallback: ErrorCallback) -> WLServiceTask
    {
        let task = WLServiceTask(action: ServiceAction.get_TITLE_TYPE_AHEAD)
        return task
    }
    
}
