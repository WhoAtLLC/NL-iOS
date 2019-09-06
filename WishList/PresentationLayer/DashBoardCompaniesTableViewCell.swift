//
//  DashBoardCompaniesTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 27/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class DashBoardCompaniesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var imgCompanyConnectionStrength: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
