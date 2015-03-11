//
//  LaunchHandler.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//

import UIKit

class LaunchHandler: BaseHandler {
    
    override func initData() {
        super.initData()
    }
    
    func TestConnectWithServer() {
        TaskListInstance.doGetConnectWithServer()
    }
    
    override func networkCallback(n: NSNotification) {
        let resp = n.userInfo![lRespData] as BaseResponse
        if resp.reqID == RequestID.RemoteConnected { // 推荐精选
            let r = resp as ConnectedCodeResp
            onRemoteConnectedFromServerCompleted(r)
        }
    }
    
    func onRemoteConnectedFromServerCompleted(resp: ConnectedCodeResp) {
        if let ctl = controller as? LaunchController {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if resp.retCode == RetCode.Success {
                    alertHelper.showAlertAutoClose("获取连通性检测成功!")
                } else {
                    alertHelper.showErrorAlertWithConfirm("获取连通性检测", content: "失败")
                }
            })
        }
    }

}