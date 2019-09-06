//
//  CompanyWishListObject.swift
//  WishList
//
//  Created by Dharmesh on 02/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class CompanyWishListObject {
    
    var id: Int?
    var title: String?
    var level: Int?
    var icon: String?
    
    init(id: Int, title: String, level: Int, icon: String){
        
        self.id = id
        self.title = title
        self.level = level
        self.icon = icon
    }
}