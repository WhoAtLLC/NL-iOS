//
//  WLGroupList.swift
//  WishList
//
//  Created by Dharmesh on 31/08/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLGroupList: WLModel {
    
    func getGroupList(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getGroupList)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
