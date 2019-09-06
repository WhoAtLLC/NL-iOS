//
//  WLSendSelectedCompanies.swift
//  WishList
//
//  Created by Dharmesh on 30/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
class WLSendSelectedCompanies: WLModel {
    
    var user = 0
    var selectedCompaniesPK = [Int]()
    var user1 = Int(WLUserSettings.getUser()!)!
    
    func selectedCompanies(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.selectedCompanies)
        task.addArg("user", value: user1 as AnyObject)
        task.addArg("company", value: selectedCompaniesPK as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}

//Int(WLUserSettings.getUser()!)!
