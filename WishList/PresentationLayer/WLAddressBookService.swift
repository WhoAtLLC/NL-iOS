//
//  TGAddressBookService.swift
//  WishList
//
//  Created by Dharmesh on 06/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class TGAddressBookService: WLService {
    
    var successCallback: SuccessCallback?;
    var errorCallback: ErrorCallback?;
    var progressCallBack : ProgressCallback?
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback , errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.syncContact:
            self.syncContacts(args!, successCallback: successCallback , errorCallback: errorCallback);
            break;
            
        default:
            self.logNoAction()
        }
    }
    
    func syncContacts(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        print(args.description)
        
        let api = WLApi()
        api.syncContact(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
            }) { (Void, NSError) -> Void in
                errorCallback((), NSError)
        }
    }
    
}
