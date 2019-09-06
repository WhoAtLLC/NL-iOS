//
//  WLMoreCompanyFeed.swift
//  WishList
//
//  Created by Dharmesh on 14/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLMoreCompanyFeed: WLModel {
    
    var nextURL = ""
    
    func loadMoreCompanyFeed(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.nextCompanyFeed)
        task.addArg("nextURL", value: nextURL as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
