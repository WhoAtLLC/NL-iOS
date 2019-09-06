//
//  WLSearchCompaniesOfIntrust.swift
//  WishList
//
//  Created by Dharmesh on 15/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSearchCompaniesOfIntrust: WLModel {
    
    var searchKeyword = ""
    
    func searchCompanyOfIntrust(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.searchCompanyOfIntrust)
        task.addArg("searchKeyword", value: searchKeyword as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
