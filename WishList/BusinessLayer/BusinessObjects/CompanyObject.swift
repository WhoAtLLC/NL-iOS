//
//  CompanyObject.swift
//  WishList
//
//  Created by Dharmesh on 27/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation

class CompanyObject: NSObject, NSCoding {
    
    var id: Int?
    var slug: String?
    var date_created: String?
    var date_changed: String?
    var title: String?
    var profile_image_url: String?
    var type: String?
    var primary_role: String?
    var unique_thirdparty_ref: String?
    var short_description: String?
    var funding_round_name: String?
    var crunchbase_url: String?
    var homepage_url: String?
    var facebook_url: String?
    var twitter_url: String?
    var linkedin_url: String?
    var stock_symbol: String?
    var location_city: String?
    var location_region: String?
    var location_country_code: String?
    var isSelected: Bool?
    
    init(id: Int, slug: String, date_created: String, date_changed: String, title: String, profile_image_url: String, type: String, primary_role: String, unique_thirdparty_ref: String, short_description: String, funding_round_name: String, crunchbase_url: String, homepage_url: String, facebook_url: String, twitter_url: String, linkedin_url: String, stock_symbol: String, location_city: String, location_region: String, location_country_code: String, isSelected: Bool) {
        
        self.id = id
        self.slug = slug
        self.date_created = date_created
        self.date_changed = date_changed
        self.title = title
        self.profile_image_url = profile_image_url
        self.type = type
        self.primary_role = primary_role
        self.unique_thirdparty_ref = unique_thirdparty_ref
        self.short_description = short_description
        self.funding_round_name = funding_round_name
        self.crunchbase_url = crunchbase_url
        self.homepage_url = homepage_url
        self.facebook_url = facebook_url
        self.twitter_url = twitter_url
        self.linkedin_url = linkedin_url
        self.stock_symbol = stock_symbol
        self.location_city = location_city
        self.location_region = location_region
        self.location_country_code = location_country_code
        self.isSelected = isSelected
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeInteger(forKey: "id")
        let slug = aDecoder.decodeObject(forKey: "slug") as! String
        let date_created = aDecoder.decodeObject(forKey: "date_created") as! String
        let date_changed = aDecoder.decodeObject(forKey: "date_changed") as! String
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let profile_image_url = aDecoder.decodeObject(forKey: "profile_image_url") as! String
        let type = aDecoder.decodeObject(forKey: "type") as! String
        let primary_role = aDecoder.decodeObject(forKey: "primary_role") as! String
        let unique_thirdparty_ref = aDecoder.decodeObject(forKey: "unique_thirdparty_ref") as! String
        let short_description = aDecoder.decodeObject(forKey: "short_description") as! String
        let funding_round_name = aDecoder.decodeObject(forKey: "funding_round_name") as! String
        let crunchbase_url = aDecoder.decodeObject(forKey: "crunchbase_url") as! String
        let homepage_url = aDecoder.decodeObject(forKey: "homepage_url") as! String
        let facebook_url = aDecoder.decodeObject(forKey: "facebook_url") as! String
        let twitter_url = aDecoder.decodeObject(forKey: "twitter_url") as! String
        let linkedin_url = aDecoder.decodeObject(forKey: "linkedin_url") as! String
        let stock_symbol = aDecoder.decodeObject(forKey: "stock_symbol") as! String
        let location_city = aDecoder.decodeObject(forKey: "location_city") as! String
        let location_region = aDecoder.decodeObject(forKey: "location_region") as! String
        let location_country_code = aDecoder.decodeObject(forKey: "location_country_code") as! String
        let isSelected = aDecoder.decodeBool(forKey: "isSelected")
        self.init(id: id, slug: slug, date_created: date_created , date_changed: date_changed, title: title, profile_image_url: profile_image_url, type: type, primary_role: primary_role, unique_thirdparty_ref: unique_thirdparty_ref, short_description: short_description, funding_round_name: funding_round_name, crunchbase_url: crunchbase_url, homepage_url: homepage_url, facebook_url: facebook_url, twitter_url: twitter_url, linkedin_url: linkedin_url, stock_symbol: stock_symbol, location_city: location_city, location_region: location_region, location_country_code: location_country_code, isSelected: isSelected)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id!, forKey: "id")
        aCoder.encode(slug, forKey: "slug")
        aCoder.encode(date_created, forKey: "date_created")
        aCoder.encode(date_changed, forKey: "date_changed")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(profile_image_url, forKey: "profile_image_url")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(primary_role, forKey: "primary_role")
        aCoder.encode(unique_thirdparty_ref, forKey: "unique_thirdparty_ref")
        aCoder.encode(short_description, forKey: "short_description")
        aCoder.encode(funding_round_name, forKey: "funding_round_name")
        aCoder.encode(crunchbase_url, forKey: "crunchbase_url")
        aCoder.encode(homepage_url, forKey: "homepage_url")
        aCoder.encode(facebook_url, forKey: "facebook_url")
        aCoder.encode(twitter_url, forKey: "twitter_url")
        aCoder.encode(linkedin_url, forKey: "linkedin_url")
        aCoder.encode(stock_symbol, forKey: "stock_symbol")
        aCoder.encode(location_city, forKey: "location_city")
        aCoder.encode(location_region, forKey: "location_region")
        aCoder.encode(location_country_code, forKey: "location_country_code")
        aCoder.encode(isSelected!, forKey: "isSelected")
    }
}
