
//
//  WLMyBusiness.swift
//  WishList
//
//  Created by Dharmesh on 30/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLMyBusiness: WLModel {
    var business_discussion: String = ""
    var business_additional: String = ""
    var companiesofInterest = [Int]()
    var forPUT = false
    var onlyForBusiness = false
    var devices = [String:AnyObject]()
    func myBusiness(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.myBusiness)
        task.addArg("myBusinessDiscussion", value: business_discussion as AnyObject)
        task.addArg("myBusinessOtherInfo", value: business_additional as AnyObject)
        task.addArg("forPUT", value: forPUT as AnyObject)
        
        if !onlyForBusiness {
            
            task.addArg("companiesofInterest", value: companiesofInterest as AnyObject)
            devices = ["udid": unicDeviceToken as AnyObject, "device_type" : "iOS" as AnyObject]
            task.addArg("devices", value: devices as AnyObject)
        }
        
        task.start(successCallback, errorCallback: errorCallback)
    }
}
