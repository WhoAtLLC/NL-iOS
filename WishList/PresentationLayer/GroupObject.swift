//
//  GroupObject.swift
//  WishList
//
//  Created by Dharmesh on 31/08/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class GroupObject {
    
    let name: String?
    let slug: String?
    let description: String?
    let expiration_date: String?
    let count: Int?
    let owner_name: String?
    let owner_company: [String]?
    let owner_title: [String]?
    
    init(name: String, slug: String, description: String, expiration_date: String, count: Int, owner_name: String, owner_company: [String], owner_title: [String]) {
        
        self.name = name
        self.slug = slug
        self.description = description
        self.expiration_date = expiration_date
        self.count = count
        self.owner_name = owner_name
        self.owner_company = owner_company
        self.owner_title = owner_title
    }
}