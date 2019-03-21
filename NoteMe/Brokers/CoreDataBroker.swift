//
//  CoreDataBroker.swift
//  NoteMe
//
//  Created by Leonardo Domingues on 3/7/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//
import UIKit
import CoreData

final /* it is not intended to be subclassed */
class CoreDataBroker {
    
    // MARK: properties
    
    private let modelName: String
    
    /*
     A managed object context receives a model objects through a persistent store
     coordinator (also an object of this class). In this way, the managed object
     context can keeps a reference to the persistent store coordinator of the
     application. The managed object context is responsible to create, reads,
     updates and delete model objects.
     */
    private (set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedobjectContext = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType)
        managedobjectContext.persistentStoreCoordinator =
            self.persistentStoreCoordinator
        return managedobjectContext
    }()
    
    /*
     This property represents the data model of the Core Data application. This
     object is prepresented by a file in the application bundle that contains the
     data schema of the app, i.e. the collection of entities, that has attributes
     and relationships.
     */
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
    
    /*
     The persistent store coordinator keeps a reference to the managed object
     model and every parent managed object context keeps a reference to the
     persistent coordinator.
     */
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(
            managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryUrl = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreUrl =
            documentsDirectoryUrl.appendingPathComponent(storeName)
        
        // Allows lightweight migration, i.e., automatically.
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: persistentStoreUrl,
                options: options)
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    init(modelName: String) {
        self.modelName = modelName
        setupNotificationsHandling()
    }
    
    private func setupNotificationsHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(saveChanges),
            name: UIApplication.willTerminateNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(saveChanges),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }
    
    @objc private func saveChanges() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to save changes with managed object context!")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
}
