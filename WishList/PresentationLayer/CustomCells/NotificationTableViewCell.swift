//
//  NotificationTableViewCell.swift
//  WishList
//
//  Created by Sanjay Yadav on 1/10/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet var imgRequesterName: UIImageView!
    @IBOutlet var lblRequesterName: UILabel!
    @IBOutlet var lblRequsterPosition: UILabel!
    @IBOutlet var lblRequesterAddress: UILabel!
  
    
    @IBOutlet var lblProspectName: UILabel!
    @IBOutlet var lblProspectPosition: UILabel!
    @IBOutlet var lblProspectAddress: UILabel!
    
    @IBOutlet var btnStatus: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgRequesterName.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
