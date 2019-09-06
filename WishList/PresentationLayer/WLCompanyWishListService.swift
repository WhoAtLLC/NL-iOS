//
//  WLCompanyWishListService.swift
//  WishList
//
//  Created by Dharmesh on 02/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLCompanyWishListService: WLService {
    var successCallback: SuccessCallback?;
    var errorCallback: ErrorCallback?;
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.companyWishList:
            self.companyWishList(args!, successCallback: successCallback, errorCallback: errorCallback)
        default:
            self.logNoAction()
        }
    }
    
    func companyWishList(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.companyWishList(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
}
