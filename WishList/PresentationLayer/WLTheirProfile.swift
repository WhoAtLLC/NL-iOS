//
//  WLTheirProfile.swift
//  WishList
//
//  Created by Dharmesh on 28/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLTheirProfile: WLModel {
    
    var user = ""
    
    func theirProfile(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.theirProfile)
        task.addArg("user", value: user as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
