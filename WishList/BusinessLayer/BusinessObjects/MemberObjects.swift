//
//  MemberObjects.swift
//  WishList
//
//  Created by Dharmesh on 09/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class MemberObjects {
    
    let companies: Int?
    let handle: String?
    let id: Int?
    let mutual: Int?
    let short_bio: String?
    let leads: Int?
    let avatar: String?
    
    init(companies: Int, handle: String, id: Int, mutual: Int, short_bio: String, leads: Int, avatar: String) {
        
        self.companies = companies
        self.handle = handle
        self.id = id
        self.mutual = mutual
        self.short_bio = short_bio
        self.leads = leads
        self.avatar = avatar
    }
}
