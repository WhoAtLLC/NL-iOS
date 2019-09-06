//
//  WLMutualContacts.swift
//  WishList
//
//  Created by Dharmesh on 02/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLMutualContacts: WLModel {
    var connectionID: Int = 0
    
    func getmMutualContacts(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.mutualContacts)
        task.addArg("connectionID", value: connectionID as AnyObject);
        task.start(successCallback, errorCallback: errorCallback)
    }
}
