//
//  MutualContactObject.swift
//  WishList
//
//  Created by Dharmesh on 02/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
class MutualContactObject {
    
    var handle: String?
    var title: String?
    var count: Int?
    var contact: Int?
    let short_bio: String?
    
    init(handle: String, title: String, count: Int, contact: Int, short_bio: String){
        
        self.handle = handle
        self.title = title
        self.count = count
        self.contact = contact
        self.short_bio = short_bio
    }
}