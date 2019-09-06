//
//  WLCheckHandle.swift
//  WishList
//
//  Created by Dharmesh on 14/05/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLCheckHandle: WLModel {
    
    var handle = ""
    
    func checkHandle(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.checkHandle)
        task.addArg("handle", value: handle as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
