//
//  AppConfig.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

class AppConfig: NSObject {
    
    class var globalConfig : AppConfig {
        return AppConfigSharedInstance
    }
    
    override init() {
        super.init()
        loadConfigPlist()
    }
    
    // MARK: - 物理配置
    // 服务器端地址
    private(set) var urlHttpServer: String = ""
    // 服务器端端口
    private(set) var urlHttpServerPort: Int = 0
    // 审核用服务器端地址
    private(set) var urlTestHttpServer: String = ""
    // 审核用服务器端端口
    private(set) var urlTestHttpServerPort: Int = 0
    // 审核使用账号
    private(set) var testAccount: String = ""
    
    // MARK: - 程序配置
    // 启动时间
    private(set) var launchTime: Int = 2
    // 注册手机最大长度
    private(set) var regTelephoneMaxLen: Int = 50
    // 注册账号最大长度
    private(set) var regUsernameMaxLen: Int = 50
    // 注册密码最大长度
    private(set) var regPasswordMaxLen: Int = 50
    // 昵称最大长度
    private(set) var regNicknameMaxLen: Int = 50
    // 密码重置url
    private(set) var urlResetPassword: String = ""
    // 服务条款url
    private(set) var urlServiceLaw: String = ""
    
    func loadConfigPlist() {
        let plist = NSBundle.mainBundle().pathForResource("AppConfig", ofType: "plist")
        let data = NSDictionary(contentsOfFile: plist!) as Dictionary<String, AnyObject>
        for (key, val) in data {
            self.setValue(val, forKey: key)
        }
    }
    
}

