//
//  ConnectRequestStruct.swift
//  zFramework
//
//  Created by Computer on 15/3/8.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit
import Foundation

class ConnectedCodeResp: BaseResponse {
    
    var interfaceArray = [String]()
    
    init(retCode:RetCode,retMsg:String,sTime:Int) {
        super.init(reqID: RequestID.RemoteConnected, serverTime: sTime)
        self.retCode = retCode
        self.retMsg = retMsg
        self.serverTime = sTime
    }
    
    init(retCode:RetCode,retMsg:String,sTime:Int,identifier:RequestID) {
        super.init(reqID: identifier, serverTime: sTime)
        self.retCode = retCode
        self.retMsg = retMsg
        self.serverTime = sTime
    }
    
    func AnalystResponseData(#data: Dictionary<NSObject,AnyObject?>) {
        if let arr = data["dataObject"] as? NSDictionary {
            interfaceArray = arr.objectForKey("details") as [String]
        }
    }
}