//
//  WLForgotPassword.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class TGForgotPassword: WLModel {
    var email = ""
    
    //vsk
    func forgotpassword(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.forgotpassword)
        task.addArg("email", value: email as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
