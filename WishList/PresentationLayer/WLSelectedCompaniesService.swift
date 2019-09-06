//
//  WLSelectedCompaniesService.swift
//  WishList
//
//  Created by Dharmesh on 30/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLSelectedCompaniesService: WLService {
    var successCallback: SuccessCallback?;
    var errorCallback: ErrorCallback?;
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.selectedCompanies:
            self.selectedCompanies(args!, successCallback: successCallback, errorCallback: errorCallback)
        default:
            self.logNoAction()
        }
    }
    
    func selectedCompanies(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.selectedCompanies(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
}
