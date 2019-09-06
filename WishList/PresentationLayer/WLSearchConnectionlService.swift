//
//  WLSearchConnectionlService.swift
//  WishList
//
//  Created by Dharmesh on 27/06/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLSearchConnectionlService: WLService {
    var successCallback: SuccessCallback?
    var errorCallback: ErrorCallback?
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.searchConnection:
            self.searchConnection(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func searchConnection(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.searchConnection(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
        }) { (Void, NSError) -> Void in
            errorCallback((), NSError)
        }
    }
}
