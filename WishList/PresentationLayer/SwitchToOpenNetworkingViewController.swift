//
//  SwitchToOpenNetworkingViewController.swift
//  WishList
//
//  Created by Dharmesh on 28/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class SwitchToOpenNetworkingViewController: UIViewController {
    
    let loader = MFLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnChangeNetworkingTapped(_ sender: AnyObject) {
        
        loader.showActivityIndicator(self.view)
        
        let chooseNetworkModel = WLChooseNetwork()
        chooseNetworkModel.fromMoreScreen = false
        chooseNetworkModel.selectedNetwork = "open"
        chooseNetworkModel.chooseNetwork({(Void, AnyObject) -> Void in
            
            self.loader.hideActivityIndicator(self.view)
            if let response = AnyObject as? [String: AnyObject] {
                if let _ = response["network_status"] as? String {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
            }, errorCallback: {(Void, NSError) -> Void in
                
                print(NSError)
                self.loader.hideActivityIndicator(self.view)
        })
    }
}
