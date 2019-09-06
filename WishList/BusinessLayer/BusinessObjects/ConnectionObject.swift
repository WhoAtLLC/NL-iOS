//
//  ConnectionObject.swift
//  WishList
//
//  Created by Dharmesh on 02/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class ConnectionObject {
    
    var wishlistmember: Bool?
    var connectioncount: Int?
    var title: String?
    var connectionname: String?
    var mutualContactObj: [MutualContactObject]?
    let highlight: Int?
    let id: Int?
    
    init(wishlistmember: Bool, connectioncount: Int, title: String, connectionname: String, mutualContactObj: [MutualContactObject], highlight: Int, id: Int) {
        
        self.wishlistmember = wishlistmember
        self.connectioncount = connectioncount
        self.title = title
        self.connectionname = connectionname
        self.mutualContactObj = mutualContactObj
        self.highlight = highlight
        self.id = id
    }
    
}