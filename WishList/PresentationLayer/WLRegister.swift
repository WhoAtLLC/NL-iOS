//
//  WLRegister.swift
//  WishList
//
//  Created by Dharmesh on 05/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class WLRegister: WLModel {
    var email: String = "";
    var password: String = "";
    
    func register(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.register);
        task.addArg("email", value: email as AnyObject);
        task.addArg("password", value: password as AnyObject);
        task.start(successCallback, errorCallback: errorCallback)
    }
}
