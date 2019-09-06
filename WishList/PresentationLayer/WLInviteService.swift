//
//  WLInviteService.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLInviteService: WLService {
    var successCallback: SuccessCallback?;
    var errorCallback: ErrorCallback?;
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.invite:
            self.getAllinvite(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func getAllinvite(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.getInvite(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
    
}
