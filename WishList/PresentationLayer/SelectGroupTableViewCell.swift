//
//  SelectGroupTableViewCell.swift
//  WishList
//
//  Created by Dharmesh on 26/08/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class SelectGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblGroupMemberCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
