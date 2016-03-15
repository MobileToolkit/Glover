//
//  Manager.swift
//  Glover
//
//  Created by Sebastian Owodzin on 12/03/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import Foundation
import CoreData

public class Manager {
    
    var configuration: Configuration
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.configuration.model)
        
        for persistentStoreConfiguration in self.configuration.persistentStoreConfigurations {
            do {
                try coordinator.addPersistentStoreWithType(persistentStoreConfiguration.type.CoreDataStoreType, configuration: persistentStoreConfiguration.configuration, URL: persistentStoreConfiguration.url, options: persistentStoreConfiguration.options)
            } catch {
                let userInfo = [
                    NSLocalizedDescriptionKey: "Failed to initialize the persistent store: [ type: \(persistentStoreConfiguration.type) | configuration: \(persistentStoreConfiguration.configuration) | URL: \(persistentStoreConfiguration.url) | options: \(persistentStoreConfiguration.options) ]",
                    NSLocalizedFailureReasonErrorKey: "There was an error creating or loading the application's saved data.",
                    NSUnderlyingErrorKey: error as NSError
                ]
                
                let wrappedError = NSError(domain: Errors.Domain, code: Errors.PersistentStoreCreationErrorCode, userInfo: userInfo)

                NSLog("Glover: Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            }
        }
        
        return coordinator
    }()
    
    public lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
