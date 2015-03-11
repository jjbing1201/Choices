//
//  ResponseDataHandler.swift
//  Mibang3
//
//  Created by admin on 14/12/29.
//  Copyright (c) 2014年 陆广庆. All rights reserved.
//

import UIKit

class ResponseDataHandler: NSObject {
    var _data:NSData?
    var notEmpty:Bool = true
    
    init(data:NSData?) {
        _data = data

        if _data != nil {
            notEmpty = true
        } else {
            notEmpty = false
        }
    }
    
    func checkResponseData() -> Array<BaseResponse>  {
        var respArr:Array<BaseResponse>=Array()
        
        while notEmpty {
            if _data?.length > 0 {
                let httpPack:HttpPack = HttpPack()
                var newData:NSData = httpPack.checkPack(_data, adapterServer: 0)
                
                if newData.length > 0 {
                    notEmpty = true
                    self._data = NSData(data: newData)
                } else {
                    notEmpty = false
                }

                if (httpPack.packStatus == true) {
                    if httpPack.body != nil {
                        println("body.length:\(httpPack.body.len()) body:\(httpPack.body)")
                    } else {
                        println("body is nil")
                    }
                    if let resp = self.dispatchData(Length: httpPack.body.len(), bodyData: httpPack.bodyData) {
                        respArr.append(resp)
                        return respArr
                    }
                } else {
                    println("packStatus is false")
                }
                
            } else {
                notEmpty = false
            }
        }
        return respArr
    }
    
    //TODO: - 修改中逐层修改
    func dispatchData1(#action:String,command:String,bodyData:NSData) -> BaseResponse? {
        if let d:Dictionary<NSObject,AnyObject>? = BaseTools.decodeJsonString(bodyData)  {
            if let dict = d {
                let responseData:ResponseData = ResponseData(action: action, command: command, dict: dict)
                
                return nil
            } else {
                println("decode bodyData to JSON ERROR:\(bodyData.debugDescription)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func dispatchData(#Length: Int, bodyData:NSData) -> BaseResponse? {
        if let dict:Dictionary<NSObject,AnyObject>? = BaseTools.decodeJsonString(bodyData)  {

            if dict == nil {
                println("decode bodyData to JSON ERROR:\(bodyData.debugDescription)")
                return nil
            }
            //println("dict:\(dict)")
            let (retCode,retMsg,sTime,identifierID) = self.checkCode(dict!)
            switch (identifierID) {
            
            //MARK: － 收到提示连接信息
            case ("ServerConnect"):
                // TODO: - 分析获取结果
                var resp = ConnectedCodeResp(retCode: retCode, retMsg: retMsg, sTime: sTime, identifier:RequestID.RemoteConnected)
                // TODO: - 分析实际解析内容 
                resp.AnalystResponseData(data: dict!)
                return resp
            default:
                println("未知消息内容")
                return nil
            }
        } else {
            println("解析数据结构失败!")
            return nil
        }
    }
    
    func checkCode(dict:Dictionary<NSObject,AnyObject>) -> (RetCode,String,Int,String) {
        var retMsg:String = ""
        var sTime:Int = 0
        var identifierID:String = "unKnown"
        
        if (dict["strInfo"] != nil) {
            retMsg = dict["strInfo"] as String
        }
        if let t:String = dict["stime"] as? String {
            sTime = t.toInt()!
        }
        if let id:String = dict["ResponseID"] as? String {
            identifierID = id
        }
        if let code = dict["code"] as? Int {
            if (code == 0) {
                return (RetCode.Success, retMsg, sTime, identifierID)
            } else {
                return (RetCode.Failure, retMsg, sTime, identifierID)
            }
        } else {
            return (RetCode.Failure,retMsg,sTime, identifierID)
        }
    }

}
