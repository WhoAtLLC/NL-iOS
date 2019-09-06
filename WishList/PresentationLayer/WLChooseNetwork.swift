//
//  WLChooseNetwork.swift
//  WishList
//
//  Created by Dharmesh on 30/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLChooseNetwork: WLModel {
    
    var selectedNetwork = ""
    var fromMoreScreen = false
    
    func chooseNetwork(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.chooseNetwork)
        task.addArg("network_status", value: selectedNetwork as AnyObject)
        task.addArg("fromMoreScreen", value: fromMoreScreen as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
