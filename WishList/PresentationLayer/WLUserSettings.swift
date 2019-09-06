//
//  WLUserSettings.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLUserSettings: NSObject {
    class func setAuthToken(_ authToken: String?) {
        let defaults = UserDefaults.standard
        defaults.set(authToken, forKey: "authToken")
    }
    
    class func getAuthToken() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "authToken")
    }
    
    class func setEmail(_ authToken: String?) {
        let defaults = UserDefaults.standard
        defaults.set(authToken, forKey: "Email")
    }
    
    class func getEmail() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "Email")
    }
    
    class func setUser(_ user: String) {
        let defaults = UserDefaults.standard
        defaults.set(user, forKey: "user")
    }
    
    class func getUser() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "user")
    }
    
    class func setHandle(_ user: String) {
        let defaults = UserDefaults.standard
        defaults.set(user, forKey: "handle")
    }
    
    class func getHandle() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "handle")
    }
    
}
