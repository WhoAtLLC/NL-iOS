//
//  WLNotificationAction.swift
//  WishList
//
//  Created by Dharmesh on 12/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLNotificationAction: WLModel {
    
    var notificatioAction = ""
    var notificationID = 0
    var comment = ""
    
    func performNotificationAction(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.notificationActions)
        task.addArg("notificationID", value: notificationID as AnyObject)
        task.addArg("notificatioAction", value: notificatioAction as AnyObject)
        task.addArg("comment", value: comment as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
