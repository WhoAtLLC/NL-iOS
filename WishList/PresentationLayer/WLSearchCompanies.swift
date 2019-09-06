//
//  WLSearchCompanies.swift
//  WishList
//
//  Created by Dharmesh on 13/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSearchCompanies: WLModel {
    
    var searchKeyword = ""
    
    func searchCompany(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.searchCompany)
        task.addArg("searchKeyword", value: searchKeyword as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
