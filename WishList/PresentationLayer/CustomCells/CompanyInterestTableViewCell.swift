//
//  CompanyInterestTableViewCell.swift
//  WishList
//
//  Created by Harendra Singh on 1/11/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class CompanyInterestTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var lblCompanyTitle: UILabel!
    @IBOutlet weak var btnChecked: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
