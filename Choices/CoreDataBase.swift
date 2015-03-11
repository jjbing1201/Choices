//
//  CoreDataBase.swift
//  zFramework
//
//  Created by Computer on 15/3/2.
//  Copyright (c) 2015年 Computer. All rights reserved.
//
import UIKit
import CoreData

class CoreDataBase: NSObject {
    
    let kStoreFileName = "Choices.sqlite"
    
    var privateContext: NSManagedObjectContext?
    
    private var managedObjectModel: NSManagedObjectModel?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var mainContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext?
    
    class var sharedInstance : CoreDataBase {
        return CoreDataSharedInstance
    }
    
    override init() {
        super.init()
        if let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil) {
            self.managedObjectModel = managedObjectModel
            
            persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            
            if let coordinator = persistentStoreCoordinator {
                let applicationDocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last as NSURL
                let storeURL = applicationDocumentsDirectory.URLByAppendingPathComponent(kStoreFileName)
                let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
                let error: NSErrorPointer = nil
                coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options, error: error)
                
                masterContext = setupContextWithConcurrencyType(NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
                masterContext?.persistentStoreCoordinator = persistentStoreCoordinator
                
                mainContext = setupContextWithConcurrencyType(NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
                mainContext?.parentContext = masterContext
                
                privateContext = setupContextWithConcurrencyType(NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
                privateContext?.parentContext = mainContext
            }
        }
    }
    
    deinit {
        save()
    }
    
    func setupContextWithConcurrencyType(type: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext  {
        var context = NSManagedObjectContext(concurrencyType: type)
        return context;
    }
    
    func createManagedObject(entityName: String) -> NSManagedObject {
        var mmo = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: privateContext!) as NSManagedObject
        return mmo
    }
    
    func save() {
        if let moc = privateContext {
            moc.performBlockAndWait({ () -> Void in
                let error: NSErrorPointer = nil
                if moc.hasChanges {
                    if !moc.save(error) {
                        println("CoreDataStore save() Error:\(error)")
                    } else {
                        self.mainContextSave()
                    }
                }
            })
        }
    }
    
    private func mainContextSave() {
        if let moc = mainContext {
            moc.performBlock({ () -> Void in
                let error: NSErrorPointer = nil
                if moc.hasChanges {
                    if !moc.save(error) {
                        println("CoreDataStore save() Error:\(error)")
                    } else {
                        self.masterContextSave()
                    }
                }
            })
        }
    }
    
    private func masterContextSave() {
        if let moc = masterContext {
            moc.performBlock({ () -> Void in
                let error: NSErrorPointer = nil
                if moc.hasChanges && !moc.save(error) {
                    println("CoreDataStore save() Error:\(error)")
                }
            })
        }
    }
    
}










