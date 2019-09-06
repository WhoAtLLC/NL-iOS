//
//  WLProfile.swift
//  WishList
//
//  Created by Dharmesh on 05/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLProfile: WLModel {
    var firstname: String = ""
    var lastname: String = ""
    var handle: String = ""
    var deviceid: String = ""
    var devicetype: String = ""
    var phone: String = ""
    var bio: String = ""
    var code: String = ""
    var user: String = ""
    var userImage: UIImage?
    var userEmail = ""
    
    func profile(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.profile)
        task.addArg("first_name", value: firstname as AnyObject)
        task.addArg("last_name", value: lastname as AnyObject)
        task.addArg("handle", value: handle as AnyObject)
        
        if userEmail.characters.count > 0 {
            task.addArg("email", value: userEmail as AnyObject)
        }
        task.start(successCallback, errorCallback: errorCallback)
    }
    
    
    
    
    func updateProfile(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.updateProfile);
        task.addArg("firstname", value: firstname as AnyObject);
        task.addArg("lastname", value: lastname as AnyObject);
        task.addArg("handle", value: handle as AnyObject);
        task.addArg("deviceid", value: "345567654" as AnyObject);
        task.addArg("devicetype", value: "iOS" as AnyObject);
        task.addArg("phone", value: phone as AnyObject);
        task.addArg("bio", value: bio as AnyObject);
        task.addArg("user", value: user as AnyObject);
        task.addArg("token", value: WLUserSettings.getAuthToken()! as String as AnyObject);
        
        //task.addArg("token", value: token);
        
        task.start(successCallback, errorCallback: errorCallback)
    }
    
    func getProfile(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.profile);
        task.addArg("first_name", value: firstname as AnyObject);
        task.addArg("last_name", value: lastname as AnyObject);
        task.addArg("handle", value: handle as AnyObject);
        //task.addArg("token", value: token);
        
        task.start(successCallback, errorCallback: errorCallback)
    }
    
    func myProfile(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.myProfile)
        task.start(successCallback, errorCallback: errorCallback)
    }
    
    func theirProfile(_ successCallback: @escaping SuccessCallback, errorCallback: @escaping ErrorCallback) {
        let task = WLServiceTask(action: ServiceAction.theirProfile);
        task.start(successCallback, errorCallback: errorCallback)
    }
    
    func updateProfileData(_ dict : NSMutableDictionary)
    {
        if let firstName = dict["firstname"] as? String
        {
            self.firstname = firstName
        }
        if let lastname = dict["lastname"] as? String
        {
            self.lastname = lastname
        }
        if let handle = dict["handle"] as? String
        {
            self.handle = handle
        }
        if let deviceid = dict["deviceid"] as? String
        {
            self.deviceid = deviceid
        }
        if let devicetype = dict["devicetype"] as? String
        {
            self.devicetype = devicetype
        }
        if let phone = dict["phone"] as? String
        {
            self.phone = phone
        }
        if let bio = dict["bio"] as? String
        {
            self.bio = bio
        }
        if let user = dict["user"] as? String
        {
            self.user = user
        }
        
    }
}
