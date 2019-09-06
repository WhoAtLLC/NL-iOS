//
//  ConnectionDetailTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 29/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class ConnectionDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblConnectionTitle: UILabel!
    @IBOutlet weak var lblMutualContactCounter: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblSort_Bio: UILabel!
    @IBOutlet weak var imgUserPicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
