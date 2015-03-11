//
//  TaskEngine.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit

/*! 执行结果汇总

- Complete: 完成
- Retry:   重试
*/
enum TaskResult {
    case Complete
    case AlwaysRetry // 永久重试
    case Retry       // 有限重试
}

typealias taskCallback = (result: TaskResult) -> ()

private let taskEngineSharedInstance: TaskEngine = TaskEngine()

class TaskEngine: NSObject {
    
    private var taskQueue = Array<TaskAdapter>()
    
    private var taskMap: [String : TaskAdapter] = [:]
    
    private var tag: Bool = false
    
    class var sharedInstance : TaskEngine {
        return taskEngineSharedInstance
    }
    
    override private init() {
        super.init()
        loop()
    }
    
    func loop() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let sleepTime: useconds_t = 200000 //200毫秒
            while self.tag {
                if self.taskQueue.isEmpty {
                    usleep(sleepTime)
                    continue
                }
                let task = self.taskQueue.removeLast()
                var callback: taskCallback = {(result: TaskResult) -> () in
                    switch result {
                    case .Complete:
                        println("\(task) completion")
                        if task.taskID != nil {
                            self.taskMap.removeValueForKey(task.taskID!)
                        }
                        break
                    case .Retry:
                        self.taskQueue.append(task)
                        break
                    default:
                        break
                    }
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    task.execute(callback)
                })
            }
        })
    }
    
    func start() {
        tag = true
    }
    
    func stop() {
        tag = false
    }
    
    func pushTask(task: TaskAdapter) {
        if task.taskID != nil {
            taskMap.updateValue(task, forKey: task.taskID!)
        }
        println("当前队列数\(taskQueue.count)")
        taskQueue.append(task)
        println("add task:\(task) 当前队列数\(taskQueue.count)")
    }
    
    func findTask(taskID: String) -> TaskAdapter? {
        return taskMap[taskID]
    }
}

