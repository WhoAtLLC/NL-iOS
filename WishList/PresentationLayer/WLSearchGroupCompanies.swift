//
//  WLSearchGroupCompanies.swift
//  WishList
//
//  Created by Dharmesh on 04/10/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSearchGroupCompanies: WLModel {
    
    var keyword = ""
    var group = ""
    
    func searchCompaniesForGroup(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.searchCompanyForGroup)
        task.addArg("keyword", value: keyword as AnyObject)
        task.addArg("group", value: group as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
