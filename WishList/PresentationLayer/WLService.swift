//
//  WLService.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class WLService: NSObject {
    var serviceAction: ServiceAction;
    
    init(action: ServiceAction) {
        self.serviceAction = action;
    }
    
    func execute(_ args: Dictionary<String, AnyObject>?, successCallback:  @escaping SuccessCallback, errorCallback:  @escaping ErrorCallback) {
        //meant to be overridden by children
    }
    
    func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback,progressCallBack : @escaping ProgressCallback, errorCallback: @escaping ErrorCallback) {
        //meant to be overridden by children
    }
    
    func logNoAction() {
        let errorStr = "Unrecognized action executed in \(type(of: self))";
        let error = NSError(domain: "wish list", code: 0, userInfo: [NSLocalizedDescriptionKey: errorStr]);
        WLLogging.logError(error);
    }
}
