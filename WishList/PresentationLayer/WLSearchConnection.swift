//
//  WLSearchConnection.swift
//  WishList
//
//  Created by Dharmesh on 27/06/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSearchConnection: WLModel {
    
    var ConnectionID = 0
    var searchKey = ""
    
    func SearchConnection(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.searchConnection)
        task.addArg("ConnectionID", value: ConnectionID as AnyObject)
        task.addArg("searchKey", value: searchKey as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
