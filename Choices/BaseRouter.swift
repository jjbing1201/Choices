//
//  BaseRouter.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

class BaseRouter: NSObject {
    
    var handler:BaseHandler?
    var controller:UIViewController?
    
    func configureControllerStyle() {
        controller?.view.backgroundColor = UIColor.blackColor()
    }

}
