//
//  AppDependency.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit
import Foundation

class AppDependency: NSObject {
    
    var rooter:LaunchRouter?
    
    override init() {
        super.init()
        configureDependencies()
    }
    
    func installRootView(window:UIWindow) {
        rooter?.setupRootView(window)
    }

    private func configureDependencies() {
        
        var loginRouter   = LoginRouter()
        var loginHandler  = LoginHandler()
        loginRouter.handler = loginHandler
        loginHandler.router = loginRouter
        
        var launchRouter  = LaunchRouter()
        var launchHandler = LaunchHandler()
        launchRouter.handler = launchHandler
        launchHandler.router = launchRouter
        launchRouter.loginRouter = loginRouter
        
        rooter = launchRouter
    }
}