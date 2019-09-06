//
//  WLResendEmailVerification.swift
//  WishList
//
//  Created by Dharmesh on 24/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLResendEmailVerification: WLModel {
    
    func resendEmailVerification(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.resenEmailVerification)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
