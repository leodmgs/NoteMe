//
//  CoreDataBroker.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/7/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import CoreData

final /* it is not intended to be subclassed */
class CoreDataBroker {
    
    // MARK: properties
    
    private let modelName: String
    
    private (set) lazy var managedobjectContext: NSManagedObjectContext = {
        let managedobjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedobjectContext.persistentStoreCoordinator =
            self.persistentStoreCoordinator
        return managedobjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(
            forResource: modelName, withExtension: "momd") else {
                fatalError("Unable to Find Data Model file.")
        }
        guard let managedObjectModel = NSManagedObjectModel(
            contentsOf: modelUrl) else {
                fatalError("Unable to Load Data Model file")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(
            managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryUrl = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreUrl =
            documentsDirectoryUrl.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreUrl,
                options: nil)
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
}
