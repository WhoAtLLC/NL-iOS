//
//  MutualConnectionObject.swift
//  WishList
//
//  Created by Dharmesh on 15/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class MutualConnectionObject {
    
    var id: Int?
    var connectioncount: Int?
    var wishlistmember: Int?
    var slug: String?
    var date_created: String?
    var date_changed: String?
    var first_name: String?
    var middle_name: String?
    var last_name: String?
    var label: String?
    var title: String?
    var email: String?
    var address: String?
    var address_two: String?
    var city: String?
    var state: String?
    var postal_code: String?
    var country: String?
    var date_submitted: String?
    var date_updated: String?
    var approved: Int?
    var handle: String?
    var bio: String?
    var key: Int?
    var profile: Int?
    var fullName: String?
    let company: String?
    
    init(id: Int, connectioncount: Int, wishlistmember: Int, slug: String, date_created: String, date_changed: String, first_name: String, middle_name: String, last_name: String, label: String, title: String, email: String, address: String, address_two: String, city: String, state: String, postal_code: String, country: String, date_submitted: String, date_updated: String, approved: Int, handle: String, bio: String, key: Int, profile: Int, fullName: String, company: String) {
        
        self.id = id
        self.connectioncount = connectioncount
        self.wishlistmember = wishlistmember
        self.slug = slug
        self.date_created = date_created
        self.date_changed = date_changed
        self.first_name = first_name
        self.middle_name = middle_name
        self.last_name = last_name
        self.label = label
        self.title = title
        self.email = email
        self.address = address
        self.address_two = address_two
        self.city = city
        self.state = state
        self.postal_code = postal_code
        self.country = country
        self.date_submitted = date_submitted
        self.date_updated = date_updated
        self.approved = approved
        self.handle = handle
        self.bio = bio
        self.key = key
        self.profile = profile
        self.fullName = fullName
        self.company = company
    }
    
}