//
//  TabBarViewController.swift
//  WishList
//
//  Created by Dharmesh on 18/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import UIKit


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.switchToNotificationTab), name:NSNotification.Name(rawValue: "SwitchTabNotification"), object: nil)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(netHex: 0xFFFFFF)
        UITabBar.appearance().tintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(netHex: 0xAEAEAE)], for: UIControl.State())
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for:.selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 8)!], for: UIControl.State())
        UITabBar.appearance().shadowImage = UIImage()
        self.tabBar.setValue(true, forKey: "_hidesShadow")
         
        //for var i = 0; i < self.tabBar.items?.count; i += 1 {
        for i in 0..<self.tabBar.items!.count {
            switch i {
                
            case 0:
                
                let companyTab = self.tabBar.items![i] as UITabBarItem
                companyTab.image = UIImage(named: "Companies")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                companyTab.selectedImage = UIImage(named: "CompaniesSelected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                companyTab.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
                
            case 1:
                
                let companyTab = self.tabBar.items![i] as UITabBarItem
                companyTab.image = UIImage(named: "NotificationTab")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                companyTab.selectedImage = UIImage(named: "NotificationSelected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                
                companyTab.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
                
            case 2:
                
                let companyTab = self.tabBar.items![i] as UITabBarItem
                companyTab.image = UIImage(named: "MyAccount")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                companyTab.selectedImage = UIImage(named: "MyAccountSelected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                companyTab.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
                
            case 3:
                
                let companyTab = self.tabBar.items![i] as UITabBarItem
                companyTab.image = UIImage(named: "MoreTab")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                companyTab.selectedImage = UIImage(named: "MoreSelected")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
                companyTab.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
                
            default:
                
                break
            }
        }
        
        if requestIDGlobal.count > 0 {
            
            self.selectedIndex = 1
        }
    }
    
    @objc func switchToNotificationTab() {
        self.selectedIndex = 1
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let vc = viewController as? UINavigationController {
            vc.popToRootViewController(animated: false)
        }
    }
}

extension UIImage {
    
    class func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
