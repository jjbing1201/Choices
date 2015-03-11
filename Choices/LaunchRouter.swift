//
//  LaunchRouter.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

class LaunchRouter: BaseRouter {
    
    override func configureControllerStyle() {
        super.configureControllerStyle()
    }
    
    func setupRootView(window:UIWindow!) {
        var ctl:LaunchController = window.rootViewController as LaunchController
        ctl.handler = handler as? LaunchHandler
        handler?.router = self
        handler?.controller = ctl
        self.controller = ctl
        self.configureControllerStyle()
    }

}
