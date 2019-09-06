//
//  WLMyWishListForUser.swift
//  WishList
//
//  Created by Dharmesh on 09/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLMyWishListForUser: WLModel {
    
    var handle = ""
    
    func getMyWishListForUser(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getWishLishForUser)
        task.addArg("handle", value: handle as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
