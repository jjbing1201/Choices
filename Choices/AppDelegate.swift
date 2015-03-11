//
//  AppDelegate.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 全局样式设置
        initAppStyle()
        // 全局初始化
        initializedDepend()
        // 通知初始化
        initNotification(application)
        // 后台任务启动
        TaskEngine.sharedInstance.start()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        CoreDataBase.sharedInstance.save()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        CoreDataBase.sharedInstance.save()
        application.beginReceivingRemoteControlEvents()
    }

    func applicationWillEnterForeground(application: UIApplication) {

    }
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataBase.sharedInstance.save()
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nil
    }

    // MARK: 分享类部分
    // 分享类活跃部分
    func applicationDidBecomeActive(application: UIApplication) {
        
    }

    // 分享类跳转打开部分
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        return true
    }
    
    // MARK: 推送注册
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token = deviceToken.description
            .stringByReplacingOccurrencesOfString("<", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString(">", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            .stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(token, forKey: lUUIDKey)
        userDefault.synchronize()
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error.localizedDescription)
    }
    
    // MARK: 播放控制
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        if event.type == .RemoteControl {
            
        }
    }

    // MARK: - Private Method
    func initAppStyle() {
        
        // windows
        window?.backgroundColor = UIColor.whiteColor()
        
        // status bar
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        // NavigationBar
        // UINavigationBar.appearance().setBackgroundImage(UIImage(named: "bg_navigation"), forBarMetrics: UIBarMetrics.Default)
        // UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.textNavigation()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        // UINavigationBar.appearance().translucent = false
        // UINavigationBar.appearance().barTintColor = UIColor.redColor()
        
        // Tab bar
        // UITabBar.appearance().backgroundColor = UIColor.lightGrayColor()
        // UITabBar.appearance().backgroundImage = UIImage(named: "trans")
        
        // Tab Bar Item
        // UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.textTabBar()], forState: UIControlState.Normal)
        // UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Selected)
        
        // Config
        AppConfigSharedInstance
        // Color
        AppColorsSharedInstance
    }
    
    func initializedDepend() {
        var dependence: AppDependency = AppDependency()
        dependence.installRootView(window!)
    }
    
    func initNotification(application: UIApplication) {
        var currentVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        if currentVersion >= 8.0 {
            var types:UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
            var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            var types:UIRemoteNotificationType = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
            application.registerForRemoteNotificationTypes(types)
        }

    }
}

