//
//  LoginRouter.swift
//  Choices
//
//  Created by Computer on 15/3/11.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit
import Foundation

class LoginRouter: BaseRouter {
    
    override func configureControllerStyle() {
        super.configureControllerStyle()
    }
    
    func presentViewControllerFromViewController(viewcontroller: UIViewController) {
        let sb = UIStoryboard(name: lStoryboardMain, bundle: NSBundle.mainBundle())
        var ctl = sb.instantiateViewControllerWithIdentifier(lLoginControllerIdentifier) as LoginController
        ctl.handler = handler as? LoginHandler
        handler?.controller = ctl
        self.controller = ctl
        self.configureControllerStyle()
        
        viewcontroller.presentViewController(ctl, animated: true) { () -> Void in
            
        }
    }
}