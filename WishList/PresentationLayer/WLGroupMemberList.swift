//
//  WLGroupMemberList.swift
//  WishList
//
//  Created by Dharmesh on 05/10/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLGroupMemberList: WLModel {
    
    var group = ""
    
    func getGroupMemberList(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.getGroupMemberList)
        task.addArg("group", value: group as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
