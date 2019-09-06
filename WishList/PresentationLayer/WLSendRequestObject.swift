//
//  WLSendRequestObject.swift
//  WishList
//
//  Created by Dharmesh on 05/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSendRequestObject: WLModel {
    
    var howIntroReason = ""
    var whyIntroReason = ""
    var companiesofInterest = [Int]()
    var excludedmutualcontacts = [Int]()
    var recipient = ""
    var dynamicLink = ""
    var contact = Int()
    
    func sendRequest(_ successCallback: @escaping SuccessCallback,_ errorCallback:  @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.sendRequest)
        task.addArg("howIntroReason", value: howIntroReason as AnyObject)
        task.addArg("whyIntroReason", value: whyIntroReason as AnyObject)
        task.addArg("companiesofInterest", value: companiesofInterest as AnyObject)
        task.addArg("excludedmutualcontacts", value: excludedmutualcontacts as AnyObject)
        task.addArg("recipient", value: recipient as AnyObject)
        task.addArg("contact", value: contact as AnyObject)
        task.addArg("dynamicLink", value: dynamicLink as AnyObject)
        
        task.start(successCallback, errorCallback: errorCallback)
    }
}
