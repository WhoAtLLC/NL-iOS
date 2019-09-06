//
//  WLServiceTask.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

enum ServiceAction : Int {
    
    case login, logout, companyList, myBusiness, chooseNetwork, loadMoreCompanies, selectedCompanies, companyWishList, getConnections, mutualContacts, sendRequest, getNotifications, getInboundDetail, getTerms, notificationActions, searchCompany, searchCompanyOfIntrust, nextCompanyFeed, checkHandle, courses , courseDetail , courseRequest, courseDetailRequest , notifications , acceptNotification , deleteNotification ,declineNotification, readNotification , unreadNotification , register ,forgotpassword , profile ,contacts ,listcourses ,invite , reset_PASSWORD ,send_INVITE_PREVIEW ,send_VALIDATION ,get_SIMILAR_DOMAINS ,is_FREEMAIL ,get_TITLES ,get_TITLE_TYPE_AHEAD ,get_ORGANIZATIONS ,get_ORG_TYPE_AHEAD , syncContact , myProfile, theirProfile , updateProfile, getMutualForNotificationDetail, searchConnection, getMemberList, getWishLishForUser, getTheirWishLishForUser, getGroupList, getCompaniesForSelectedGroup, getSelectedCompaniesGroupMember, contactGroupOrganizer, checkEmailStatus, resenEmailVerification, searchCompanyForGroup, getGroupMemberList, registerWithFB
}

class WLServiceTask: NSObject {
    var serviceArgs: Dictionary<String, AnyObject> = [:];
    var serviceAction: ServiceAction;
    
    init(action: ServiceAction) {
        self.serviceAction = action;
    }
    
    func addArg(_ key: String, value: AnyObject) {
        serviceArgs[key] = value;
    }
    
    func start(_ successCallback : @escaping SuccessCallback , errorCallback : @escaping ErrorCallback ) {
        
        WLThreading.background { () -> Void  in
            let service = WLServiceFactory.service(self.serviceAction);
            service.execute(self.serviceArgs, successCallback: { (Void, AnyObject) -> Void in
                
                successCallback((Void), AnyObject)
                
                }, errorCallback: { (Void, NSError) -> Void in
                    errorCallback((),NSError)
            })
        }
    }
}
