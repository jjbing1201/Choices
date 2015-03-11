//
//  ConnectRequest.swift
//  zFramework
//
//  Created by Computer on 15/3/8.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit
import Foundation

class ConnectRequest: BaseRequest {
    let httpHandler: HttpHandler?
    
    override init() {
        httpHandler = HttpHandler.shareInstance
    }
    
    func requestPostConnectedWithServer(complete:(resp:ConnectedCodeResp!)->Void) {
        var params:Array<ParamData>=[]
        
        var p_platform:ParamData = ParamData()
        p_platform.paramName = "platform"
        p_platform.paramValue = "IOS"
        params.append(p_platform)
        
        var p_version: ParamData = ParamData()
        p_version.paramName = "version"
        p_version.paramValue = "0.1.140814"
        params.append(p_version)
        
        var p_type: ParamData = ParamData()
        p_type.paramName = "type"
        p_type.paramValue = "DEBUG"
        params.append(p_type)
        
        //TODO: 等待服务端获取连接检测接口
        self.httpHandler?.sendHttpReq(endPoint: "ServerConnect", mode: OperationMode.POST, requestType: RequestType.Default, params: params, completeRequest: { (status, dataArr) -> Void in
            
            var r = ConnectedCodeResp(retCode: RetCode.Failure, retMsg:stringHelper.i18n("network.resp.unknown"), sTime: 0)
            
            if let respArr:Array<BaseResponse> = dataArr as Array<BaseResponse>! {
                if respArr.count > 0 {
                    if let resp:ConnectedCodeResp = respArr.first! as? ConnectedCodeResp {
                        r = resp
                    } else {
                        r.retMsg = stringHelper.i18n("network.resp.type.err")
                    }
                } else {
                    r.retMsg = stringHelper.i18n("network.resp.nil")
                }
            } else {
                r.retMsg = stringHelper.i18n("network.resp.nil")
            }
            complete(resp: r)
        })
    }

}