//
//  WLCompanyList.swift
//  WishList
//
//  Created by Dharmesh on 26/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLCompanyList: WLModel {
    
    var isContactCompanies = false
    var mutualContact = ""
    
    func companyList(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        
        let task = WLServiceTask(action: ServiceAction.companyList)
        
        if isContactCompanies {
            task.addArg("mutualContact", value: mutualContact as AnyObject)
        }
        task.start(successCallback, errorCallback: errorCallback)
    }
}
