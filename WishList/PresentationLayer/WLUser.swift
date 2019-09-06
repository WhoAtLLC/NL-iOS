//
//  WLUser.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class WLUser: NSObject {
    
    var email: String = "";
    var password: String = "";
    
    func login(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.login);
        task.addArg("email", value: email as AnyObject)
        task.addArg("password", value: password as AnyObject)
        task.addArg("deviceid", value: unicDeviceToken as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}

