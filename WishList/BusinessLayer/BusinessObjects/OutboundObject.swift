//
//  OutboundObject.swift
//  WishList
//
//  Created by Dharmesh on 05/04/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class OutboundObject {
    
    var status: String?
    var contactowner: String?
    var prospectname: String?
    var requestID: Int?
    let highlight: Int?
    let contactusername: String?
    let recipient_read: Int?
    let prospectdesignation: String?
    let prospectcompanyname: String?
    let contactcompanyname: String?
    let contactshortbio: String?
    let contactdesignation: String?
    let category: String?
    let companiesOffered: [AnyObject]?
    
    init(status: String, contactowner: String, prospectname: String, requestID: Int, highlight: Int, contactusername: String, recipient_read: Int, prospectdesignation: String, prospectcompanyname: String, contactcompanyname: String, contactshortbio: String, contactdesignation:String, category: String, companiesOffered: [AnyObject]) {

        self.status = status
        self.contactowner = contactowner
        self.prospectname = prospectname
        self.requestID = requestID
        self.highlight = highlight
        self.contactusername = contactusername
        self.recipient_read = recipient_read
        self.prospectdesignation = prospectdesignation
        self.prospectcompanyname = prospectcompanyname
        self.contactcompanyname = contactcompanyname
        self.contactshortbio = contactshortbio
        self.contactdesignation = contactdesignation
        self.category = category
        self.companiesOffered = companiesOffered
    }
}