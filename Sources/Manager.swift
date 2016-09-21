//
//  Manager.swift
//  Glover
//
//  Created by Sebastian Owodzin on 12/03/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import Foundation
import CoreData

open class Manager {
    fileprivate var configuration: Configuration

    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.configuration.model)

        for persistentStoreConfiguration in self.configuration.persistentStoreConfigurations {
            let type = persistentStoreConfiguration.type
            let configuration = persistentStoreConfiguration.configuration
            let url = persistentStoreConfiguration.url
            let options = persistentStoreConfiguration.options

            do {
                try coordinator.addPersistentStore(ofType: type.toCoreDataStoreType(), configurationName: configuration, at: url as URL?, options: options)
            } catch {
                let errorDescription = "Failed to initialize persistent store: \(persistentStoreConfiguration)"

                let userInfo = [
                    NSLocalizedDescriptionKey: errorDescription,
                    NSLocalizedFailureReasonErrorKey: "There was an error creating or loading the application's saved data.",
                    NSUnderlyingErrorKey: error as NSError
                ] as [String : Any]

                let wrappedError = NSError(domain: Errors.Domain, code: Errors.PersistentStoreCreationErrorCode, userInfo: userInfo)

                NSLog("Glover: error: \(wrappedError) | \(wrappedError.userInfo)")
            }
        }

        return coordinator
    }()

    fileprivate lazy var masterContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator

        return context
    }()

    open lazy var managedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.masterContext

        return context
    }()

    fileprivate lazy var workerContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext

        return context
    }()

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    open func performOnWorkerContext(_ closure: @escaping (_ context: NSManagedObjectContext) -> Void) {
        workerContext.perform {
            NSLog("Glover: working on thread \(Thread.current)")

            closure(self.workerContext)

            do {
                try self.workerContext.save()

                self.saveContext()
            } catch {
                let nserror = error as NSError
                NSLog("Glover: error: \(nserror) | \(nserror.userInfo)")
            }
        }
    }

    fileprivate func saveMasterContext() {
        masterContext.perform {
            if self.masterContext.hasChanges {
                do {
                    try self.masterContext.save()
                } catch {
                    let nserror = error as NSError
                    NSLog("Glover: error: \(nserror) | \(nserror.userInfo)")
                }
            }
        }
    }

    open func saveContext() {
        managedObjectContext.perform {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()

                    self.saveMasterContext()
                } catch {
                    let nserror = error as NSError
                    NSLog("Glover: error: \(nserror) | \(nserror.userInfo)")
                }
            }
        }
    }
}
