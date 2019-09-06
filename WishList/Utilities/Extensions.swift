//
//  StringExtensions.swift
//  WishList
//
//  Created by Dharmesh on 05/02/16.
//  Copyright © 2016 Harendra Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIViewController {
    func displayAlert(_ title:String, error:String, buttonText: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    
    var makeThisRound: UIImageView {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
        return self
    }
}
extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}



extension UIView {
    /**
     Set x Position
     
     :param: x CGFloat
     by DaRk-_-D0G
     */
    func setX(_ x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position
     
     :param: y CGFloat
     by DaRk-_-D0G
     */
    func setY(_ y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width
     
     :param: width CGFloat
     by DaRk-_-D0G
     */
    func setWidth(_ width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height
     
     :param: height CGFloat
     by DaRk-_-D0G
     */
    func setHeight(_ height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
}

extension UIImage {
    var uncompressedPNGData: Data      { return self.pngData()!        }
    var highestQualityJPEGNSData: Data { return self.jpegData(compressionQuality: 1)!  }
    var highQualityJPEGNSData: Data    { return self.jpegData(compressionQuality: 0.75)!  }
    var mediumQualityJPEGNSData: Data  { return self.jpegData(compressionQuality: 0.5)!  }
    var lowQualityJPEGNSData: Data     { return self.jpegData(compressionQuality: 0.25)!  }
    var lowestQualityJPEGNSData:Data   { return self.jpegData(compressionQuality: 0)!  }
}

extension UIView {
    func update(_ x: NSNumber?, y: NSNumber?, width: NSNumber?, height: NSNumber?) {
        var rect = self.frame;
        if (x != nil) {
            rect.origin.x = CGFloat(x!.floatValue);
        }
        
        if (y != nil) {
            rect.origin.y = CGFloat(y!.floatValue);
        }
        
        if (width != nil) {
            rect.size.width = CGFloat(width!.floatValue);
        }
        
        if (height != nil) {
            rect.size.height = CGFloat(height!.floatValue);
        }
        
        self.frame = rect;
    }
    
    var left: CGFloat { return self.frame.origin.x; }
    var right: CGFloat { return self.frame.origin.x + self.frame.size.width; }
    var top: CGFloat { return self.frame.origin.y; }
    var bottom: CGFloat { return self.frame.origin.y + self.frame.size.height; }
    var width: CGFloat { return self.frame.size.width; }
    var height: CGFloat { return self.frame.size.height; }
}

extension UIImageView {
    public func imageFromUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("<YOUR_HEADER_VALUE>", forHTTPHeaderField: "<YOUR_HEADER_KEY>")
            
            let task =  URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                guard let data = data, error == nil else{
                    NSLog("Image download error: \(error)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode > 400 {
                        let errorMsg = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        NSLog("Image download error, statusCode: \(httpResponse.statusCode), error: \(errorMsg!)")
                        return
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    NSLog("Image download success")
                    self.image = UIImage(data: data)
                })
            }
            task.resume()
        }
    }
}

