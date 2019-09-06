//
//  WLTheirProfileService.swift
//  WishList
//
//  Created by Dharmesh on 28/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLTheirProfileService: WLService {
    var successCallback: SuccessCallback?
    var errorCallback: ErrorCallback?
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.theirProfile:
            self.theirProfile(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func theirProfile(_ args: Dictionary<String,AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.theirProfile(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
}
