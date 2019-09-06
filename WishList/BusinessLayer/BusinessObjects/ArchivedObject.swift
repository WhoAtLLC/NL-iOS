//
//  ArchivedObject.swift
//  WishList
//
//  Created by Dharmesh on 13/05/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//
import Foundation

class ArchivedObject {
    
    var status: String?
    var contactowner: String?
    var prospectname: String?
    var requestID: Int?
    let highlight: Int?
    let contactusername: String?
    
    init(status: String, contactowner: String, prospectname: String, requestID: Int, highlight: Int, contactusername: String) {
        
        self.status = status
        self.contactowner = contactowner
        self.prospectname = prospectname
        self.requestID = requestID
        self.highlight = highlight
        self.contactusername = contactusername
    }
}