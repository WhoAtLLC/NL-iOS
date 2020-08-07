//
//  WLAppSettings.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

class WLAppSettings: NSObject {
    
    class func getBaseUrl()->String {
        let userDefauld = UserDefaults.standard
        let selectedHost = userDefauld.value(forKey: SELECTED_HOST)
        if selectedHost != nil{
            let data =  selectedHost as! [String: Any]
            return data["HostUrl"] as! String
        }
//        if let path = Bundle.main.path( forResource: "WLSettings" , ofType: "plist") {
//            let myDict: NSDictionary = NSDictionary(contentsOfFile: path)!
//            if let selectedEnv = myDict["env"] as? String {
//                if let dictUrl = myDict[selectedEnv] as? NSDictionary{
//                    return dictUrl["baseUrl"] as! String
//
//                }
//            }
//        }
        return ""
    }
    
    class func loginurl(_ args: Dictionary<String, Any>)->String {
        print("baseURL = " + getBaseUrl())
        return getBaseUrl() + "/api/v1/login/"
    }
    
    class func registerurl(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/register/step/1/"
    }
    
    class func addProfileURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/register/step/2/"
    }
    
    class func checkEmailStatusURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/register/status/"
    }
    class func profileurl(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/profile/"
    }
    
    class func checkHandleURL(_ args: Dictionary<String, Any>)->String {
        
        let handle = args["handle"] as! String
        return getBaseUrl() + "/api/v1/register/username/?search=\(handle)"
    }
    
    class func forgotPasswordurl(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/password/reset/"
    }
    
    class func syncContacts(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/contact/"
    }
    
    class func companyList(_ args: Dictionary<String, Any>)->String {
        
        let mutualContact = args["mutualContact"] as? String
        if mutualContact?.characters.count > 0 {
            return getBaseUrl() + "/api/v1/user/\(mutualContact!)/companies/"
        } else {
            return getBaseUrl() + "/api/v1/company/"
        }
    }
    
    class func LoadMoreCompanyListURL(_ args: Dictionary<String, Any>)->String {
        let nextPageURL = args["nextPageURL"] as! String
        return nextPageURL
    }
    
    class func myBusinessURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/profile/interests/"
    }
    
    class func chooseNetworkURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/profile/network/"
    }
    
    class func sendSelectedCompaniesURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/profile/wishlist/"
    }
    
    class func companyWishList(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/company/feed/"
    }
    
    class func getConnectionURL(_ args: Dictionary<String, Any>)->String {
        
        let nextMutualContactURL = args["nextMutualContactURL"] as? String
        
        if nextMutualContactURL?.characters.count > 0 {
            
            return nextMutualContactURL!
            
        } else {
            let contactHandle = args["contactHandle"] as? String
            if contactHandle?.characters.count > 0 {
                return getBaseUrl() + "/api/v1/contact/\(contactHandle!)/mutual/"
            } else {
                let companyID = args["companyID"] as? Int ?? 0
                return getBaseUrl() + "/api/v1/company/\(companyID)/connections/"
            }
        }
    }
    
    class func getMutualContactURL(_ args: Dictionary<String, Any>)->String {
        let connectionID = args["connectionID"] as! Int
        return getBaseUrl() + "/api/v1/contact/\(connectionID)/connections/"
    }
    
    class func sendRequestURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/notification/create/"
    }
    
    class func getNotificationsURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/notification/"
    }
    
    class func getInboundDetailURL(_ args: Dictionary<String, Any>)->String {
        let requestID = args["requestID"] as! Int
        return getBaseUrl() + "/api/v1/notification/read/\(requestID)/"
    }
    
    class func getTermsURL(_ args: Dictionary<String, Any>)->String {
        let isPrivacyPolicy = args["isPrivacyPolicy"] as! Bool
        if isPrivacyPolicy {
            return getBaseUrl() + "/api/v1/privacy/"
        } else {
            return getBaseUrl() + "/api/v1/terms/"
        }
        
    }
    
    class func notificationActionURL(_ args: Dictionary<String, Any>)->String {
        
        let notificatioAction = args["notificatioAction"] as! String
        let notificationID = args["notificationID"] as! Int
        return getBaseUrl() + "/api/v1/notification/\(notificatioAction)/\(notificationID)/"
    }
    
    class func searchCompanyURL(_ args: Dictionary<String, Any>)->String {
        let searchKeyword = args["searchKeyword"] as! String
        return getBaseUrl() + "/api/v1/company/feed/?search=\(searchKeyword)"
    }
    
    class func loadMoreCompanyFeed(_ args: Dictionary<String, Any>)->String {
        let nextURL = args["nextURL"] as! String
        return nextURL
    }
    
    class func searchCompanyOfIntrustURL(_ args: Dictionary<String, Any>)->String {
        let searchKeyword = args["searchKeyword"] as! String
        return getBaseUrl() + "/api/v1/company/?search=\(searchKeyword)"
    }
    
    class func theirProfileURL(_ args: Dictionary<String, Any>)->String {
        let user = args["user"] as! String
        return getBaseUrl() + "/api/v1/user/\(user)/"
    }
    
    class func getMutualContactForNotificationDetailURL(_ args: Dictionary<String, Any>)->String {
        let id = args["id"] as! Int
        let next = args["next"] as! String
        if next.characters.count > 0 {
            return next
        } else {
            return getBaseUrl() + "/api/v1/notification/mutual/\(id)/"
        }
    }
    
    class func getSearchConnectionURL(_ args: Dictionary<String, Any>)->String {
        let ConnectionID = args["ConnectionID"] as! Int
        let searchKey = args["searchKey"] as! String
        return getBaseUrl() + "/api/v1/company/\(ConnectionID)/connections/?search=\(searchKey)"
    }
    
    class func getMemberList(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/company/match/"
    }
    
    class func getMyWishList(_ args: Dictionary<String, Any>)->String {
        let handle = args["handle"] as! String
        return getBaseUrl() + "/api/v1/company/match/\(handle)/"
    }
    
    class func getTheirMemberList(_ args: Dictionary<String, Any>)->String {
        let handle = args["handle"] as! String
        return getBaseUrl() + "/api/v1/company/match/\(handle)/reverse/"
    }
    
    class func getGroupList(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/groups/"
    }
    
    
    class func getCompaniesForSelectedGroupsURL(_ args: Dictionary<String, Any>)->String {
        let groupHandle = args["groupHandle"] as! String
        return getBaseUrl() + "/api/v1/company/feed/?group=\(groupHandle)"
    }
    
    class func getSelectedCompaniesGroupMemberURL(_ args: Dictionary<String, Any>)->String {
        let groupHandle = args["groupHandle"] as! String
        let companyID = args["selectedComapnyID"] as! Int
        return getBaseUrl() + "/api/v1/company/\(companyID)/connections/?group=\(groupHandle)"
    }
    
    class func contactGroupOrganizerURL(_ args: Dictionary<String, Any>)->String {
        let groupSlug = args["groupSlug"] as! String
        return getBaseUrl() + "/api/v1/group/\(groupSlug)/contact/"
    }
    
    class func resendEmailVerificationURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/register/resend/"
    }

    class func searchCompaniesForGroup(_ args: Dictionary<String, Any>)->String {
        let keyword = args["keyword"] as! String
        let group = args["group"] as! String
        return getBaseUrl() + "/api/v1/company/feed/?search=\(keyword)&group=\(group)/"
    }
    
    class func getGroupMemberListURL(_ args: Dictionary<String, Any>)->String {
        let group = args["group"] as! String
        return getBaseUrl() + "/api/v1/group/\(group)/members/"
    }
    
    class func registerWithFBURL(_ args: Dictionary<String, Any>)->String {
        return getBaseUrl() + "/api/v1/social/facebook/"
    }
    
}
