//
//  MyWishlistTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 09/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class MyWishlistTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCompanieName: UILabel!
    @IBOutlet weak var imgCompanyIcon: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
