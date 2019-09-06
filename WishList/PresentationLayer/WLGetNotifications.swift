//
//  WLGetNotifications.swift
//  WishList
//
//  Created by Dharmesh on 05/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLGetNotifications: WLModel {
    
    func getNotifications(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getNotifications)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
