//
//  WLSearchCompaniesForGroupService.swift
//  WishList
//
//  Created by Dharmesh on 04/10/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSearchCompaniesForGroupService: WLService {
    
    var successCallback: SuccessCallback?
    var errorCallback: ErrorCallback?
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.searchCompanyForGroup:
            self.searchCompanyForGroup(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func searchCompanyForGroup(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.searchCompanyForGroup(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
        }) { (Void, NSError) -> Void in
            errorCallback((), NSError)
        }
    }
}