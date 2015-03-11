//
//  LaunchController.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

class LaunchController: UIViewController {
    
    var handler: LaunchHandler?
    

    @IBAction func LoginButton(sender: UIButton) {
        self.handler?.TestConnectWithServer()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler?.initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.redColor()
    }
}
