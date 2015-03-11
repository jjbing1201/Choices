//
//  HttpHandler.swift
//  Mibang3
//
//  Created by admin on 14/12/29.
//  Copyright (c) 2014年 陆广庆. All rights reserved.
//

import UIKit
import SystemConfiguration

class HttpHandler: NSObject {
    
    class var shareInstance : HttpHandler {
        return HttpHandlerSharedInstance
    }
    
    let requestTimeOut = 5.0
    
    let formRequestTimeOut = 30.0
    
    var baseURL:String = AppConfig.globalConfig.urlHttpServer

    let BOUNDARY_STR = "------WebKitFormBoundaryHYLiNrOfGMd5P31X"
    
    //审核用账号登陆
    var isTestAccount:Bool = false
    {
        //在属性变化前记录日志
        willSet
        {
            println("will set testAccount")
        }
        
        //要在属性发生变化后，更新baseURL属性
        didSet
        {
            if isTestAccount == true {
                baseURL = AppConfig.globalConfig.urlTestHttpServer
            } else {
                baseURL = AppConfig.globalConfig.urlHttpServer
            }
        }
    }
    
    override init() {
        return
    }
    
    func markTestAccount(status:Bool) {
        isTestAccount = status
    }
    
    /**
    发送HTTP请求
    
    :param: endPoint    服务器端提供的接口名称（或php的名称）
    :param: mode        方式:GET/POST
    :param: requestType 提交方式:normal/form
    :param: params      参数列表
    :param: callback    回调
    */
    func sendHttpReq(#endPoint:String, mode:OperationMode, requestType:RequestType, params:Array<ParamData>,completeRequest:(status:Bool,dataArr:Array<BaseResponse>?) -> Void) {

        if Reachability.isConnectedToNetwork(){
            //endPoint url
            let urlString:String = baseURL + endPoint
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                if requestType == RequestType.Default {
                    self.normalRequest(urlString: urlString, interfaceName: endPoint, params: params, mode: mode, complete: { (status, dataArr) -> Void in
                        completeRequest(status: status, dataArr: dataArr)
                    })
                } else if (requestType == RequestType.Form) {
                    self.formRequest(urlStr:urlString, params: params, complete: { (status, dataArr) -> Void in
                        completeRequest(status: status, dataArr: dataArr)
                    })
                }
            })
        } else {
            println("网络异常......")
            alertHelper.showAlert("网络异常......")
            completeRequest(status: false, dataArr: nil)
        }
    }
    /**
    创建GetRequest的详细内容
    
    :param: urlString       服务器地址
    :param: interfacename   接口名称
    :param: params          params
    
    :returns: request
    */
    func createNormalGetRequest(urlString:String, interfacename: String,  params:Array<ParamData>) -> NSMutableURLRequest? {
        
        var _URLStr:String = "\(urlString)?"

        // 组合参数
        // 1. timestamp
        let _time = getPackageTimestamp()
        _URLStr += "timestamp=\(_time)"
        // 2. data
        let _data = getPackageData(params)
        _URLStr += "&data=\(_data)"
        // 3. auth
        let _auth = getPackageAuth(gtime: _time, gData: _data, gInterfacename: interfacename)
        _URLStr += "&auth=\(_auth)"
        
        // 4. output
        let url:NSURL = NSURL(string: _URLStr)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        return request
    }
    
    /**
    创建PostRequest
    
    :param: urlString 服务器地址
    :param: action    action
    :param: command   command
    :param: params    params
    
    :returns: request
    */
    func createNormalPostRequest(urlString:String, interfacename: String,  params:Array<ParamData>) -> NSMutableURLRequest? {
        
        var _URLStr = "\(urlString)"
        let url:NSURL = NSURL(string: _URLStr)!
        
        var paramsStr:String = ""
        // 1. timestamp
        let _time = getPackageTimestamp()
        paramsStr += "timestamp=\(_time)"
        // 2. data
        let _data = getPackageData(params)
        paramsStr += "&data=\(_data)"
        // 3. auth
        let _auth = getPackageAuth(gtime: _time, gData: _data, gInterfacename: interfacename)
        paramsStr += "&auth=\(_auth)"
        println("sendBodyData:\(paramsStr)")
        
        let data:NSData! = paramsStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        var request:NSMutableURLRequest? = NSMutableURLRequest(URL: url)
        request?.HTTPMethod = "POST"
        request?.HTTPBody = data
        return request
    }
    
    //正常方式提交
    func normalRequest(#urlString:String, interfaceName: String, params:Array<ParamData>, mode:OperationMode,complete:(status:Bool,dataArr:Array<BaseResponse>?) -> Void) {
        var request:NSMutableURLRequest?
        //设置请求
        if mode == OperationMode.GET { //GET
            request = createNormalGetRequest(urlString, interfacename: interfaceName, params: params)
        } else { //POST
            request = createNormalPostRequest(urlString, interfacename: interfaceName, params: params)
        }
        
        if request != nil {
            
            let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()

            let session:NSURLSession = NSURLSession.sharedSession()
            let task:NSURLSessionDataTask = session.dataTaskWithRequest(request!, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in

                //读取HTTP头
                if let httpHeader=response as? NSHTTPURLResponse {
                    if httpHeader.statusCode == 200 && error == nil {
                        let dataHandler:ResponseDataHandler = ResponseDataHandler(data: data!)
                        let respArr:Array<BaseResponse> = dataHandler.checkResponseData()
                        
                        complete(status: true, dataArr: respArr)
                    } else {
                        println("return statusCode:\(httpHeader.statusCode) response:\(response!.debugDescription) error:\(error?.debugDescription) datalength:\(data!.length) data:")
                        
                        complete(status: false, dataArr: nil)
                    }
                } else {
                    complete(status:false,dataArr:nil)
                }
                println("\n")
                
            })
            task.resume()
        } else {
            println("createRequest failed")
            complete(status: false, dataArr: nil)
        }
    }
  
    
    //form方式提交
    func formRequest(#urlStr:String,params:Array<ParamData>,complete:(status:Bool,dataArr:Array<BaseResponse>?) -> Void) {
        if let url:NSURL = NSURL(string: urlStr) {
            //设置请求
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            //HTTPMethod
            request.HTTPMethod = "POST"
            
            
            //指定Content-Type
            let typeStr:String = "multipart/form-data; boundary=\(BOUNDARY_STR)"
            request.setValue(typeStr, forHTTPHeaderField: "Content-Type")
            
            let body:NSData = createFormHttpBody(params)
            request.HTTPBody = body
            
            //指定Content-Length
            let lengthStr:String = "\(body.length)"
            request.setValue(lengthStr, forHTTPHeaderField: "Content-Length")
            
            let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            
            let session:NSURLSession = NSURLSession.sharedSession()
            let task:NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
                var respBody = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                var status:Bool = false
                let resp:FileUploadResp = FileUploadResp(retCode: RetCode.Failure, retMsg: "", sTime: 0)
                
                if let httpHeader=response as? NSHTTPURLResponse {
                    if httpHeader.statusCode == 200 && error == nil {
                        if let dict:Dictionary<NSObject,AnyObject>? = BaseTools.decodeJsonString(data)  {
                            if dict == nil {
                                println("decode data to JSON ERROR:\(error?.debugDescription) body:\(respBody!)")
                                resp.retMsg = "数据异常"
                            } else {
                                println("文件上传结果:\(dict)")
                                if let code:String = dict!["code"] as? String {
                                    if code.toInt() == 0 {
                                        resp.retCode = RetCode.Success
                                    } else {
                                        if let desc:String = dict!["desc"] as? String {
                                            resp.retMsg = desc
                                        }
                                    }
                                }
                                resp.downloadListURL(dict: dict!)
                                status=true
                            }
                        } else {
                            println("\nerrordata:\(respBody))")
                            resp.retMsg = "数据异常"
                        }
                    } else {
                        resp.retMsg = "网络错误"
                        println("response:\(response!.debugDescription) error:\(error?.debugDescription) body:\(respBody!)")
                    }
                } else {
                    resp.retMsg = "网络错误"
                }
                if status == true {
                    complete(status: true, dataArr: [resp])
                } else {
                    complete(status: false, dataArr: [resp])
                }
                
            })
            
            task.resume()

        } else {
            complete(status: false, dataArr: nil)
        }
    }

    
    //拼接FormHttpBody
    func createFormHttpBody(params:Array<ParamData>) ->NSData {
        var dataM:NSMutableData = NSMutableData()
        
        
        for param in params {
            //head
            dataM.appendData(httpBoundary(isLast: false))
            
            if param.paramType == FormInputType.File {
                if (param.paramValue == "" && param.paramData.length > 0) { //fileData
                    // image/png
                    dataM.appendData(httpImageBodyContentDispoition(formKey: param.paramName))
                    dataM.appendData(param.paramData)
                } else {
                    var tmpArr = param.paramValue.componentsSeparatedByString("/")
                    let fileName:String = tmpArr.last!
                    dataM.appendData(httpBodyContentDispoition(formKey: param.paramName, filePath: param.paramValue, value: fileName))
                    dataM.appendData(httpBodyFile(param.paramValue))
                }
            } else {
                dataM.appendData(httpBodyContentDispoition(formKey: param.paramName, filePath: nil, value: param.paramValue))
            }
        }
        
        //end
        dataM.appendData(httpBoundary(isLast: true))
        
        return dataM
    }
    
    func httpBoundary(#isLast:Bool) ->NSData {
        var strBoundary:String!
        if isLast == false {
            strBoundary = "\n--\(BOUNDARY_STR)\n"
        } else {
            strBoundary = "\n--\(BOUNDARY_STR)--\n"
        }
        
        let bodyBoundaryData:NSData! = strBoundary.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return bodyBoundaryData
    }
    
    func httpBodyContentDispoition(#formKey:String,filePath:String?,value:String) ->NSData {
        var contentDispoitionData:NSData = NSData()
        var strContentDispoition:String
        
        if let filepath = filePath {
            let filename = value
            var  mimeType:String? = mimeTypeWithFilePath(filepath)
            if mimeType == nil {
                mimeType = "text/plain"
            }
            strContentDispoition = "Content-Disposition: form-data; name=\"\(formKey)\"; filename=\"\(filename)\"\nContent-Type: \(mimeType!)\n\n"
            
        } else {
            strContentDispoition = "Content-Disposition: form-data; name=\"\(formKey)\"\n\n\(value)"
        }
        if let data:NSData = strContentDispoition.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            contentDispoitionData = NSMutableData(data: data)
        }
        return contentDispoitionData
    }
    
    func httpImageBodyContentDispoition(#formKey:String) ->NSData {
        var contentDispoitionData:NSData = NSData()
        var strContentDispoition:String
        strContentDispoition = "Content-Disposition: form-data; name=\"\(formKey)\"; filename=\"avatar_upload\"\nContent-Type: image/png \n\n"
        
        if let data:NSData = strContentDispoition.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            contentDispoitionData = NSMutableData(data: data)
        }
        return contentDispoitionData
    }
    //上传的文件内容
    func httpBodyFile(filePath:String) -> NSData {
        var bodyFileData:NSData = NSData()
        if let fileURL:NSURL = NSURL(fileURLWithPath: filePath) {
            //拼接上传文件本身的二进制数据
            if let fileData = NSData(contentsOfURL: fileURL) {
                bodyFileData = fileData
            }
        }
        return bodyFileData
    }
    

    //指定全路径文件的mimeType
    func mimeTypeWithFilePath(filePath:String) ->String? {
        //判断文件是否存在
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) == false {
            return nil
        }
        
        //使用HTTP HEAD方法获取上传文件信息
        let url:NSURL = NSURL(fileURLWithPath: filePath)!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        //调用同步方法获取文件的MimeType
        var response:NSURLResponse?
        var error:NSError?
        NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        if let mimeType = response?.MIMEType {
            return mimeType
        } else {
            return nil
        }
    }
    
    // MARK: - 私有方法
    private func getPackageTimestamp() -> String {
        return NSDate().getNowTime()
    }
    
    private func getPackageData(params: Array<ParamData>) -> String {
        var dict = Dictionary<String,AnyObject?>()
        var nsDict = NSMutableDictionary()
        for param in params {
            dict[param.paramName] = param.paramValue
            nsDict.setObject(param.paramValue, forKey: param.paramName)
        }
        return JsonEasyControl.JsonToStringZero(nsDict)
    }
    
    private func getPackageAuth(#gtime: String, gData: String, gInterfacename: String) -> String {
        var s = "\(gtime)+\(gData)+\(gInterfacename)" as String
        var ns = s.md5 as NSString
        return ns.substringWithRange(NSMakeRange(0, 32))
    }
    
}

class ParamData {
    var paramType:FormInputType = FormInputType.Text
    var paramName:String = ""
    var paramValue:String = ""
    var paramData:NSData = NSData()
}


