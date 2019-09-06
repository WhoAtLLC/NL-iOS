//
//  WLRegisterWithFBService.swift
//  WishList
//
//  Created by Dharmesh on 21/11/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLRegisterWithFBService: WLService {
    
    var successCallback: SuccessCallback?
    var errorCallback: ErrorCallback?
    
     override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.registerWithFB:
            self.registerWithFB(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func registerWithFB(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.registerWithFB(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
        }) { (Void, NSError) -> Void in
            errorCallback((), NSError)
        }
    }
}
