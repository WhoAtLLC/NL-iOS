//
//  WLGetInBoundeRequestDetail.swift
//  WishList
//
//  Created by Dharmesh on 06/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLGetInBoundeRequestDetail: WLModel {
    
    var requestID = 0
    
    func getInBoundDetail(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getInboundDetail)
        task.addArg("requestID", value: requestID as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
