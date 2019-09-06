//
//  InboundObject.swift
//  WishList
//
//  Created by Dharmesh on 05/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class InboundObject {
    
    var status: String?
    var requestorname: String?
    var requestorimage: String?
    var requestordesignation: [String]?
    var requestorcompanyname: [String]?
    var prospectname: String?
    var prospectdesignation: [String]?
    var prospectcompanyname: String?
    var requestID: Int?
    let highlight: Int?
    let requestorusername: String?
    let category: String?
    let companiesOffered: [AnyObject]?
    
    init(status: String, requestorname: String, requestorimage: String, requestordesignation: [String], requestorcompanyname: [String], prospectname: String, prospectdesignation: [String], prospectcompanyname: String, requestID: Int, highlight: Int, requestorusername: String, category: String, companiesOffered: [AnyObject]) {
        
        self.status = status
        self.requestorname = requestorname
        self.requestorimage = requestorimage
        self.requestordesignation = requestordesignation
        self.requestorcompanyname = requestorcompanyname
        self.prospectname = prospectname
        self.prospectdesignation = prospectdesignation
        self.prospectcompanyname = prospectcompanyname
        self.requestID = requestID
        self.highlight = highlight
        self.requestorusername = requestorusername
        self.category = category
        self.companiesOffered = companiesOffered
    }
}