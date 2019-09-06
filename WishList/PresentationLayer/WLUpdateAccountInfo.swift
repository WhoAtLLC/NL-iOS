
//
//  WLUpdateAccountInfo.swift
//  WishList
//
//  Created by Dharmesh on 29/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLUpdateAccountInfo: WLModel {
    
    var first_name = ""
    var last_name = ""
    var phone = ""
    var twitter_url = ""
    var title = ""
    var company = ""
    var linkedin_url = ""
    var bio = ""
    var short_bio = ""
    var business_discussion = ""
    var business_additional = ""
    
    func updateProfile(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.updateProfile)
        task.addArg("first_name", value: first_name as AnyObject)
        task.addArg("last_name", value: last_name as AnyObject)
        task.addArg("phone", value: phone as AnyObject)
        task.addArg("title", value: title as AnyObject)
        task.addArg("company", value: company as AnyObject)
        task.addArg("bio", value: bio as AnyObject)
        task.addArg("short_bio", value: short_bio as AnyObject)
        task.addArg("myBusinessDiscussion", value: business_discussion as AnyObject)
        task.addArg("myBusinessOtherInfo", value: business_additional as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
