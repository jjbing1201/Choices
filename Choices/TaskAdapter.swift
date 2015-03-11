//
//  TaskAdapter.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit

protocol TaskAdapter {
    
    var taskID: String? {get set}
    
    func execute(callback:taskCallback)
    
}
