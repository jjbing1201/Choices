//
//  AppColors.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit

class AppColors: NSObject {
    
    class var sharedInstance : AppColors {
        return AppColorsSharedInstance
    }
    
    private(set) var appWhite: UIColor = UIColor()

    override init() {
        super.init()
        let plist = NSBundle.mainBundle().pathForResource("AppColors", ofType: "plist")
        let data = NSDictionary(contentsOfFile: plist!) as Dictionary<String, AnyObject>;
        for (key, val) in data {
            let rgba = val as [Int]
            if rgba.count != 4 {
                continue
            }
            let r: CGFloat = CGFloat(Float(rgba[0]) / 255.0)
            let g: CGFloat = CGFloat(Float(rgba[1]) / 255.0)
            let b: CGFloat = CGFloat(Float(rgba[2]) / 255.0)
            let a: CGFloat = CGFloat(Float(rgba[3]) / 100.0)
            let color = UIColor(red: r, green: g, blue: b, alpha: a)
            self.setValue(color, forKey: key)
        }
    }
}

extension UIColor {
        
    class func appWhite() -> UIColor {
        return AppColors.sharedInstance.appWhite
    }
}

