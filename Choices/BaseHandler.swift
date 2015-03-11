//
//  BaseHandler.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

class BaseHandler: NSObject {
    
    var router: BaseRouter?
    var controller: UIViewController?
    var userInfo:[NSObject:AnyObject?]?
    
    override init() {
        super.init()
        NotificationHelper.register(NotificationType.NetworkResponse, receiver: self, action: "networkCallback:")
    }
    
    deinit {
        NotificationHelper.remove(NotificationType.NetworkResponse, receiver: self)
    }
    
    func initData() {
        
    }
    
    func networkCallback(n: NSNotification) {
        
    }
    
}
