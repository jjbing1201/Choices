//
//  TaskListInstance.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

let requestConnect: ConnectRequest = ConnectRequest()

class TaskListInstance: NSObject, TaskList {
    
    // MARK: - 所有tasklist中定义的内容实现：Request结构体调用定义在Singleton中
    class func doGetConnectWithServer() {
        // TODO: - 前台执行样例
        requestConnect.requestPostConnectedWithServer { (resp) -> Void in
            println("服务端联通性检测完成")
            NotificationHelper.send(NotificationType.NetworkResponse, userInfo: [lRespData:resp])
        }
        
        // TODO: - 后台执行样例
        // TaskEngine.sharedInstance.pushTask(ConnectedRequestCall())
    }
}
