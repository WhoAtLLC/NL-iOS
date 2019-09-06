//
//  WLGetSelectedCompaniesMember.swift
//  WishList
//
//  Created by Dharmesh on 01/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLGetSelectedCompaniesGroupMember: WLModel {
    
    var groupHandle = ""
    var selectedComapnyID = 0
    
    func getSelectedCompaniesGroupMember(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.getSelectedCompaniesGroupMember)
        task.addArg("groupHandle", value: groupHandle as AnyObject)
        task.addArg("selectedComapnyID", value: selectedComapnyID as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
