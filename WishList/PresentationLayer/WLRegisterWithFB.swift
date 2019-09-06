//
//  WLRegisterWithFB.swift
//  WishList
//
//  Created by Dharmesh on 21/11/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLRegisterWithFB: WLModel {
    
    var oauth_token = ""
    
    func registerWithFB(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.registerWithFB)
        task.addArg("oauth_token", value: oauth_token as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
