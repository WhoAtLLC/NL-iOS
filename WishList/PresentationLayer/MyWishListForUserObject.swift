//
//  MyWishListForUserObject.swift
//  WishList
//
//  Created by Dharmesh on 09/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class MyWishListForUserObject {
    
    let id: Int?
    let mutual: Int?
    let title: String?
    let leads: Int?
    
    init(id: Int, mutual: Int, title: String, leads: Int) {
        
        self.id = id
        self.mutual = mutual
        self.title = title
        self.leads = leads
    }
}