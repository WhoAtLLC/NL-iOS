//
//  WLConnection.swift
//  WishList
//
//  Created by Dharmesh on 02/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLConnection: WLModel {
    
    var companyID: Int = 0
    var isMutualContacts = false
    var contactHandle = ""
    var nextMutualContactURL = ""
    
    func getConnections(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.getConnections)
        
        if !nextMutualContactURL.isEmpty {
            
            task.addArg("nextMutualContactURL", value: nextMutualContactURL as AnyObject)
            
        } else if isMutualContacts {
                
                task.addArg("contactHandle", value: contactHandle as AnyObject)
                
            } else {
                task.addArg("companyID", value: companyID as AnyObject)
        }
        
        task.start(successCallback, errorCallback: errorCallback)
    }
}
