//
//  WLServiceFactory.swift
//  WishList
//
//  Created by Dharmesh on 04/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class WLServiceFactory: NSObject {
    class func service(_ action: ServiceAction) -> WLService {
        switch(action) {
        case
        .login,
        .logout:
            return TGUserService(action: action)
            
        case
        .myBusiness:
            return WLMyBusinessService(action: action)

        case
        
        .chooseNetwork:
            return WLChooseNetworkService(action: action)

        case
        
        .loadMoreCompanies:
            return WLLoadMoreCompanyService(action: action)
        case
        .selectedCompanies:
            return WLSelectedCompaniesService(action: action);

        case
        .companyWishList:
            return WLCompanyWishListService(action: action);
            
        case
        .getConnections:
            return WLGetConnectionService(action: action);
            
        case
        .mutualContacts:
            return WLGetMutualContactService(action: action);
        case
        .sendRequest:
            return WLSendRequestService(action: action);
        case
        .getNotifications:
            return WLGetNotificationsService(action: action);
        case
        .getInboundDetail:
            return WLGetInboundDetailService(action: action);
        case
        .register:
            return WLRegisterService(action: action)
        case
        .forgotpassword:
            return WLForgotPassService(action: action)

        case
        .profile:
            return WLProfileService(action: action)
            
        case
        .companyList:
            
            return WLCompanyService(action: action)
            
            
        case
        .myProfile:
            return WLProfileService(action: action)
        case
        .getTerms:
            return WLGetTermsService(action: action);
        case
        .notificationActions:
            return WLNotificationActionService(action: action);
            
        case
        .searchCompany:
            return WLSeachCompanyService(action: action);
        case
        .nextCompanyFeed:
            return WLLoadMoreCompanyFeedSearvice(action: action);

        case
        .searchCompanyOfIntrust:
            return WLSearchCompanyOfIntrustService(action: action);

        case
        .syncContact:
            return TGAddressBookService(action: action);
            
        case
        .theirProfile:
            return WLTheirProfileService(action: action);
            
        case
        .updateProfile:
            return WLUpdateProfileService(action: action)
            
        case
        .checkHandle:
            return WLCheckHandleService(action: action)
        case .getMutualForNotificationDetail:
            
            return WLGetMutualForNotificationDetailService(action: action)
            
        case .searchConnection:
            
            return WLSearchConnectionlService(action: action)
            
        case .getMemberList:
            
            return WLGetMemberListService(action: action)
            
        case .getWishLishForUser:
            
            return WLGetMyCompanyWishListForUserService(action: action)
            
        case .getTheirWishLishForUser:
            
            return WLGetTheirCompanyWishListForUserService(action: action)
        
        case .getGroupList:
            
            return WLGetGroupListService(action: action)
            
        case .getCompaniesForSelectedGroup:
            
            return WLGetCompaniesForSelectedGroupService(action: action)
            
        case .getSelectedCompaniesGroupMember:
            
            return WLGetSelectedCompaniesGroupMemberService(action: action)
            
        case .contactGroupOrganizer:
            
            return WLContactGroupOrganizerService(action: action)
            
        case .checkEmailStatus:
            
            return WLCheckEmailStatusService(action: action)
            
        case .resenEmailVerification:
            
            return WLResendEmailVerificationService(action: action)
            
        case .searchCompanyForGroup:
            
            return WLSearchCompaniesForGroupService(action: action)
            
        case .getGroupMemberList:
            
            return WLGetGroupMemberListService(action: action)
            
        case .registerWithFB:
            
            return WLRegisterWithFBService(action: action)
            
        default:
            let error = NSError(domain: "wish list", code: 0, userInfo: [NSLocalizedDescriptionKey:"Unrecognized action sent to service factory"]);
            WLLogging.logError(error);
            return WLInviteService(action: action);
            
        }
        
        
    }
}
