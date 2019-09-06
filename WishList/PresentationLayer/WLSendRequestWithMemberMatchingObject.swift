//
//  WLSendRequestWithMemberMatchingObject.swift
//  WishList
//
//  Created by Dharmesh on 13/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSendRequestWithMemberMatchingObject: WLModel {
    
    var howIntroReason = ""
    var whyIntroReason = ""
    var companiesofInterest = [Int]()
    var companiesOffered = [Int]()
    var excludedmutualcontacts = [Int]()
    var recipient = ""
    var category = ""
    
    func sendRequestWithMemberMatching(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.sendRequest)
        task.addArg("howIntroReason", value: howIntroReason as AnyObject)
        task.addArg("whyIntroReason", value: whyIntroReason as AnyObject)
        task.addArg("companiesofInterest", value: companiesofInterest as AnyObject)
        task.addArg("companiesOffered", value: companiesOffered as AnyObject)
        task.addArg("excludedmutualcontacts", value: excludedmutualcontacts as AnyObject)
        task.addArg("recipient", value: recipient as AnyObject)
        task.addArg("category", value: category as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
