//
//  WLCompanyWishList.swift
//  WishList
//
//  Created by Dharmesh on 02/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLCompanyWishList: WLModel {
    
    func getCompanyWishList(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.companyWishList)
        task.start(successCallback, errorCallback: errorCallback)
    }
}
