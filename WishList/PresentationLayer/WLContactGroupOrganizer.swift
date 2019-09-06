//
//  WLContactGroupOrganizer.swift
//  WishList
//
//  Created by Dharmesh on 20/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLContactGroupOrganizer: WLModel {
    
    var groupSlug = ""
    
    func contactGroupOrganizer(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.contactGroupOrganizer)
        task.addArg("groupSlug", value: groupSlug as AnyObject)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
