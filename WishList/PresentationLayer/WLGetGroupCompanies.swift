//
//  WLGetGroupCompanies.swift
//  WishList
//
//  Created by Dharmesh on 01/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLGetGroupCompanies: WLModel {
    
    var groupHandle = ""
    
    func getCompaniesForSelectedGroups(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.getCompaniesForSelectedGroup)
        task.addArg("groupHandle", value: groupHandle as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
