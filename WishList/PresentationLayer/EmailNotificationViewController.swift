//
//  EmailNotificationViewController.swift
//  WishList
//
//  Created by Dharmesh on 11/07/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit

class EmailNotificationViewController: UIViewController {

    @IBOutlet weak var introImageForNewLeadSheet: UIView!
    @IBOutlet weak var introImageForNewLeadSheetConstraint: NSLayoutConstraint!
    
    var shouldShowCoachMarks = UserDefaults.standard.bool(forKey: "shouldShowCoachMarks")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.introImageForNewLeadSheetConstraint.constant = 900
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        shouldShowCoachMarks = UserDefaults.standard.bool(forKey: "shouldShowCoachMarks")
        
        if !shouldShowCoachMarks {
            
           
            let tapForMainViewImage = UITapGestureRecognizer(target: self, action: #selector(EmailNotificationViewController.hideMainIntroForMyBusiness))
            introImageForNewLeadSheet.isUserInteractionEnabled = true
            introImageForNewLeadSheet.addGestureRecognizer(tapForMainViewImage)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(EmailNotificationViewController.respondToSwipeGestureForMyBusiness(_:)))
            swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
            self.introImageForNewLeadSheet.addGestureRecognizer(swipeLeft)
            introImageForNewLeadSheetConstraint.constant = 0
            //self.tabBarController?.tabBar.layer.zPosition = -1
            self.tabBarController?.tabBar.isHidden = true
            UserDefaults.standard.set(true, forKey: "shouldShowCoachMarks")
        }
    }
    
    @objc func hideMainIntroForMyBusiness() {
        
       // self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introImageForNewLeadSheetConstraint.constant = 900
            }, completion: nil)
    }
    
    @objc func respondToSwipeGestureForMyBusiness(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left:
                
                //self.tabBarController?.tabBar.layer.zPosition = 0
                self.tabBarController?.tabBar.isHidden = false
                
                UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.5, options: [], animations:
                    {
                        self.introImageForNewLeadSheetConstraint.constant = 900
                    }, completion: nil)
            default:
                break
            }
        }
    }
    
    @IBAction func btnCancleIntroPopUpTapped(_ sender: AnyObject) {
        
        //self.tabBarController?.tabBar.layer.zPosition = 0
         self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.5, options: [], animations:
            {
                self.introImageForNewLeadSheetConstraint.constant = 900
            }, completion: nil)
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
