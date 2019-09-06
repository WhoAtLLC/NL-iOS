//
//  WLMyBusinessService.swift
//  WishList
//
//  Created by Dharmesh on 30/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLMyBusinessService: WLService {
    var successCallback: SuccessCallback?;
    var errorCallback: ErrorCallback?;
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.myBusiness:
            self.myBusiness(args!, successCallback: successCallback, errorCallback: errorCallback)
        default:
            self.logNoAction()
        }
    }
    
    func myBusiness(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.myBusiness(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
}
