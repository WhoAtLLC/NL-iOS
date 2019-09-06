//
//  WLProfileService.swift
//  WishList
//
//  Created by Dharmesh on 05/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLProfileService: WLService {
    
    var successCallback: SuccessCallback?;
    var errorCallback: ErrorCallback?;
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.profile:
            self.profile(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        case ServiceAction.myProfile:
            self.myProfile(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
//        case ServiceAction.TheirProfile:
//            self.theirProfile(args!, successCallback: successCallback, errorCallback: errorCallback);
//            break;
//        case ServiceAction.UpdateProfile:
//            self.updateProfile(args!, successCallback: successCallback, errorCallback: errorCallback);
//            break;
        default:
            self.logNoAction()
        }
    }
    
    func profile(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.profile(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
    
    func myProfile(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.getProfile(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
//
//    func theirProfile(args: Dictionary<String, Any>, successCallback: SuccessCallback, errorCallback: ErrorCallback) {
//        let api = WLApi()
//        api.theirProfile(args, successCallback: { (Void, Any) -> Void in
//            successCallback((), Any)
//            }) { (Void, NSError) -> Void in
//                errorCallback((), NSError)
//        }
//    }
//    func updateProfile(args: Dictionary<String, Any>, successCallback: SuccessCallback, errorCallback: ErrorCallback) {
//        let api = WLApi()
//        api.updateProfile(args, successCallback: { (Void, Any) -> Void in
//            successCallback((), Any)
//            }) { (Void, NSError) -> Void in
//                errorCallback((), NSError)
//        }
//    }
}
