//
//  YourConnectionsTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 28/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class YourConnectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgConnectionMain: UIImageView!
    @IBOutlet weak var imgSubConnections: UIImageView!
    @IBOutlet weak var lblConnectionTitle: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblConnectionCount: UILabel!
    @IBOutlet weak var imgMember: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
