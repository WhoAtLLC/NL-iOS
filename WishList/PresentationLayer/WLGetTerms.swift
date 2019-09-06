//
//  WLGetTerms.swift
//  WishList
//
//  Created by Dharmesh on 07/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLGetTerms: WLModel {
    
    var isPrivacyPolicy = false
    
    func getTermsDetail(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getTerms)
        task.addArg("isPrivacyPolicy", value: isPrivacyPolicy as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
