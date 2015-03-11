//
//  BaseResponse.swift
//  Mibang3
//
//  Created by 陆广庆 on 14/12/27.
//  Copyright (c) 2014年 陆广庆. All rights reserved.
//

import UIKit


class BaseResponse: NSObject {
   
    var reqID: RequestID = RequestID.Unknown
    var retCode: RetCode = .Failure
    var retMsg: String = stringHelper.i18n("network.failture")
    var caller: BaseHandler?
    var serverTime: Int = 0
    var dict: Dictionary<NSObject,AnyObject> = Dictionary()
    
    override init() {
    }
    
    init(reqID: RequestID) {
        self.reqID = reqID
    }
    
    init(reqID: RequestID, serverTime: Int) {
        self.reqID = reqID
        if serverTime > 0 {
            var record = AppRecord.loadAppRecord()
            record.resetServerTimeDiff(serverTime)
            record.save()
        }
    }
    
    init(retCode:RetCode,retMsg:String,serverTime:Int) {
        self.retCode = retCode
        self.retMsg = retMsg
        if serverTime > 0 {
            var record = AppRecord.loadAppRecord()
            record.resetServerTimeDiff(serverTime)
            record.save()
        }
    }
    
    init(reqID:RequestID,retCode:RetCode,retMsg:String,serverTime:Int) {
        self.reqID = reqID
        self.retCode = retCode
        self.retMsg = retMsg
        if serverTime > 0 {
            var record = AppRecord.loadAppRecord()
            record.resetServerTimeDiff(serverTime)
            record.save()
        }
    }
    
    
    
}
