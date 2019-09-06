//
//  ContryCodeTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 05/09/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class ContryCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
