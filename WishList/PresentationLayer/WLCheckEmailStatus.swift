//
//  WLCheckEmailStatus.swift
//  WishList
//
//  Created by Dharmesh on 23/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLCheckEmailStatus: WLModel {
    
    func checkEmailStatus(_ successCallback: @escaping SuccessCallback, _ errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.checkEmailStatus)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
