
//
//  CompaniesTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 01/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class CompaniesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var ibiCompanyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
