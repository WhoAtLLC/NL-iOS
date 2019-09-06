//
//  WLLogging.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLLogging: NSObject {
    class func logError(_ error: NSError) {
        NSLog("Error: %@", error);
        //TODO log errors to
    }
    
    class func logEvent(_ event: String, attributes: Dictionary<String, Any>?) {
        NSLog("Event: %@\nAttributes: %@", event, attributes!.description);
        //TODO log events using an analytic service
    }
    
    class func logInfo(_ info: String) {
        NSLog("Info: %@", info);
    }
}
