//
//  IncommingMutualContactsTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 07/03/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class IncommingMutualContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblContactPosition: UILabel!
    @IBOutlet weak var lblContactCompany: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
