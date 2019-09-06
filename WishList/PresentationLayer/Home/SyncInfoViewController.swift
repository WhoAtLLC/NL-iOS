//
//  SyncInfoViewController.swift
//  WishList
//
//  Created by Dharmesh on 04/05/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class SyncInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToSettings(_ sender: AnyObject) {
        
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.openURL(appSettings)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(netHex: 0x498CE7)
    }

}
