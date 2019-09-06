//
//  NotificationOutGoingCell.swift
//  WishList
//
//  Created by Sanjay Yadav on 1/10/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class NotificationOutGoingCell: UITableViewCell {
    
    
    @IBOutlet var lblOuGoingProspectName: UILabel!
    @IBOutlet var lblOutGoinghOwner: UILabel!    
    @IBOutlet var btnOutGoingStatus: UIButton!
    @IBOutlet weak var lblProspectCompanyName: UILabel!
    @IBOutlet weak var lblProspectDesignation: UILabel!
    @IBOutlet weak var lblContactOwnerDetail: UILabel!
    @IBOutlet weak var lblContactTitle: UILabel!
    @IBOutlet weak var lblContactCompany: UILabel!

    @IBOutlet weak var imgContactPerson: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
