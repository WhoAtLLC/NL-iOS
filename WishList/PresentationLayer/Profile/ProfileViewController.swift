//
//  ProfileViewController.swift
//  WishList
//
//  Created by Harendra Singh on 1/13/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPosition: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblPhoneNo: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var tvBio: UITextView!
    @IBOutlet var tvBusinessProfile: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnBAck(_ sender :UIButton){
        
        self.navigationController?.popViewController(animated: true)
    }
}
