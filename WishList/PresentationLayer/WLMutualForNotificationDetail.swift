//
//  WLMutualForNotificationDetail.swift
//  WishList
//
//  Created by Root on 16/06/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLMutualForNotificationDetail: WLModel {
    
    var ID = 0
    var nextURL = ""
    
    
    
    func getMutualContactForNotificationDetail(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getMutualForNotificationDetail)
        task.addArg("id", value: ID as AnyObject)
        task.addArg("next", value: nextURL as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
