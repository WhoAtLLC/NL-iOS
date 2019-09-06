//
//  WLGetInboundDetailService.swift
//  WishList
//
//  Created by Dharmesh on 06/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLGetInboundDetailService: WLService {
    var successCallback: SuccessCallback?
    var errorCallback: ErrorCallback?
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.getInboundDetail:
            self.getInboundDetail(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func getInboundDetail(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.getInboundDetail(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
}
