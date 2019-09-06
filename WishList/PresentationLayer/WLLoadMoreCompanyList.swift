//
//  WLLoadMoreCompanyList.swift
//  WishList
//
//  Created by Dharmesh on 30/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLLoadMoreCompanyList:WLModel {
    var nextPageURL = ""
    
    func loadMoreCompanies(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.loadMoreCompanies)
        task.addArg("nextPageURL", value: nextPageURL as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
