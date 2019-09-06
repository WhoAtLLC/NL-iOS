//
//  RecentSearchObject.swift
//  WishList
//
//  Created by Dharmesh on 25/05/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
class RecentSearchObject: NSObject, NSCoding {
    
    var id: Int!
    var name: String!
    
    
    init(id: Int, name:String) {
        self.id = id
        self.name = name
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(id: id, name: name as String)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
}
