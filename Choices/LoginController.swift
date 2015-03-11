//
//  LoginController.swift
//  Choices
//
//  Created by Computer on 15/3/11.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit
import Foundation

class LoginController: UIViewController {
    
    var handler: LoginHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler?.initData()
    }
    
}