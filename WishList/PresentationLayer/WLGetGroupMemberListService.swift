//
//  WLGetGroupMemberListService.swift
//  WishList
//
//  Created by Dharmesh on 05/10/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLGetGroupMemberListService: WLService {
    
    var successCallback: SuccessCallback?
    var errorCallback: ErrorCallback?
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.getGroupMemberList:
            self.getGroupMemberList(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func getGroupMemberList(_ args: Dictionary<String,AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.getGroupMemberList(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
        }) { (Void, NSError) -> Void in
            errorCallback((), NSError)
        }
    }
}
