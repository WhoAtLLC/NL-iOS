//
//  WLContactGroupOrganizer.swift
//  WishList
//
//  Created by Dharmesh on 20/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class WLContactGroupOrganizerService: WLService {
    
    var successCallback: SuccessCallback?
    var errorCallback: ErrorCallback?
    
    override func execute(_ args: Dictionary<String, AnyObject>?, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        super.execute(args, successCallback: successCallback, errorCallback: errorCallback);
        
        switch(self.serviceAction) {
        case ServiceAction.contactGroupOrganizer:
            self.contactGroupOrganizer(args!, successCallback: successCallback, errorCallback: errorCallback);
            break;
        default:
            self.logNoAction()
        }
    }
    
    func contactGroupOrganizer(_ args: Dictionary<String, AnyObject>, successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let api = WLApi()
        api.contactGroupOrganizer(args, successCallback: { (Void, AnyObject) -> Void in
            successCallback((), AnyObject.self as AnyObject)
        }) { (Void, NSError) -> Void in
            errorCallback((), NSError)
        }
    }
}
