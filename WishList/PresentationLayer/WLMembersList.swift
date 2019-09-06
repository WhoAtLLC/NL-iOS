//
//  WLMembersList.swift
//  WishList
//
//  Created by Dharmesh on 09/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLMembersList: WLModel {
    
    func getMemberList(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getMemberList)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
