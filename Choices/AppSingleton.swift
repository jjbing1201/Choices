//
//  AppSingleton.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit

// MARK: - 全局单例
let AppConfigSharedInstance: AppConfig = AppConfig()
let AppColorsSharedInstance: AppColors = AppColors()
let CoreDataSharedInstance: CoreDataBase = CoreDataBase()
let HttpHandlerSharedInstance:HttpHandler = HttpHandler()

// MARK: - 全局常量
let lUUIDKey = "uuid"
let lNewUser = "NewUser"
let lRespDataKey = "RespData"
let lStoreKeyAppRecord = "AppRecord"
let lStoreBaseModel: String = "BaseModel"

// MARK: - 所有storyboard和xib
let lStoryboardMain = "Main"

// MARK: - 全局所有名称
let lLaunchViewControllerIdentifier = "LaunchController"
let lLoginControllerIdentifier = "LoginController"

// MARK: - 全局枚举

/*
 @brief : 后台可执行的任务类型
*/
enum BackgroundTaskType { //
    case User
}

/*
 @brief : 后台可执行的任务的需求id
*/
enum RequestID {
    case Unknown            // 未知 <20150302>
    case OnTimeOut          // 网络超时 <20150302>
    case RemoteConnected    // 远程网络连接 <20150308>
}

/*
 @brief : 回调的执行结果状态值
*/
enum RetCode {
    case Success
    case Failure
}

/*
 @brief : 网络交互模式get/post
*/
enum OperationMode:String {
    case GET  = "GET"
    case POST = "POST"
}

/*
 @brief : 网络交互的类型是默认字符串提交/表单提交
*/
enum RequestType:String {
    case Default = "Default"
    case Form    = "Form"
}

/*
 @brief : 网络交互的内容分类
*/
enum FormInputType:String {
    case Text   = "text"
    case File   = "file"
    case FileData = "fileData"
}

/*
 @brief : 行为分析集合(ResponseData)使用
*/
enum ActionCommand {
    case Code(Int,Int)
}