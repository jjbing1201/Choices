//
//  ResponseData.swift
//  Mibang3
//
//  Created by admin on 15/1/20.
//  Copyright (c) 2015年 陆广庆. All rights reserved.
//

import UIKit


class ResponseData: BaseResponse {
    init(action:String,command:String,dict:Dictionary<NSObject,AnyObject>) {
        super.init()
        self.dict = dict
        (self.retCode,self.retMsg,self.serverTime) = checkCode(dict)
        self.reqID = respID(action:action, command: command)
    }
    
    func respID(#action:String,command:String) -> RequestID {
        println("action:\(action) command:\(command)")
        switch (action,command) {
        case ("0","1"):
            return RequestID.OnTimeOut
        default:
            return RequestID.Unknown
        }

    }
    
    func checkCode(dict:Dictionary<NSObject,AnyObject>) -> (RetCode,String,Int) {
        var retMsg:String = ""
        var sTime:Int = 0
        if (dict["desc"] != nil) {
            retMsg = dict["desc"] as String
        }
        if let t:String = dict["stime"] as? String {
            sTime = t.toInt()!
        }
        
        if let code = dict["code"] as? String {
            if (code == "0") {
                return (RetCode.Success,retMsg,sTime)
            } else {
                return (RetCode.Failure,retMsg,sTime)
            }
        } else {
            return (RetCode.Failure,retMsg,sTime)
        }
    }
    
    
}
