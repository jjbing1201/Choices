//
//  ConnectedRequestCall.swift
//  zFramework
//
//  Created by Computer on 15/3/10.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit
import Foundation

class ConnectedRequestCall: BaseRequest, TaskAdapter {
    
    var _connectid: String!
    var retryCount: CGFloat?
    
    // MARK: - 无需taskid去查看后台提交线程内容的情况使用
    override init() {
        super.init()
        self.taskID = ""
        retryCount = 0
    }
    
    // MARK: - 可以通过taskid去查看后台提交线程内容的情况使用
    init(connectid: String!) {
        super.init()
        self.taskID = ""
        _connectid = connectid
        retryCount = 0
    }
    
    func execute(callback: taskCallback) {
        let requestConnect = ConnectRequest()
        requestConnect.requestPostConnectedWithServer { (resp) -> Void in
            switch (resp!.retCode) {
            // 在这里进行是否重新执行的判断,并且可以进行前台展示和数据导入
            case RetCode.Success:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    alertHelper.showSuccessAlertWithConfirm("后台连接成功", content: "请确认")
                })
                callback(result: .Complete)
            // Retry是根据判断来进行处理，需要拥有重复次数限制
            case RetCode.Failure:
                self.retryCount!++
                if self.retryCount! < 10 {
                    callback(result: .Retry)
                }
            }
        }
    }
}