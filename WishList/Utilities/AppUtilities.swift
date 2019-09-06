//
//  AppUtilities.swift
//  WishList
//
//  Created by Harendra Singh on 1/7/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

let loader = MFLoader()

func showAlert(_ title : String, message : String, viewController:UIViewController ){
    
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //Create and add the Cancel action
    let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
        //Do some stuff
    }
    alertView.addAction(cancelAction)
    
    viewController.present(alertView, animated: true, completion: nil)

}

func isValidEmail(_ strEmailID :String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: strEmailID)
}

extension String {
    var length: Int {
        return characters.count
    }
}

extension UIView {
    
    func fadeIn() {
        
        self.isHidden = false
        self.alpha = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: {(finished: Bool) -> Void in
                
                 self.isHidden = true
                
        })
    }
}
