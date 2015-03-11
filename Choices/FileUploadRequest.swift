//
//  FileUploadRequest.swift
//  zFramework
//
//  Created by Computer on 15/3/3.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit

class FileUploadRequest: BaseRequest {
    let httpHandler:HttpHandler!
    
    override init() {
        httpHandler = HttpHandler.shareInstance
    }
}

class FileUploadResp: BaseResponse {
    var imgURL:String?
    var voiceURL:String?
    
    init(retCode:RetCode,retMsg:String,sTime:Int) {
        super.init(reqID: RequestID.Unknown, serverTime: sTime)
        self.retCode = retCode
        self.retMsg = retMsg
        self.serverTime = sTime
    }
    
    func downloadListURL(#dict:Dictionary<NSObject,AnyObject>) {
        if let image:String = dict["uploadfile"] as? String {
            self.imgURL = image
        }
        if let voice:String = dict["uploadfile2"] as? String {
            self.voiceURL = voice
        }
    }
}