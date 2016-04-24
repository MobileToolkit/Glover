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
    private var configuration: Configuration

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.configuration.model)

        for persistentStoreConfiguration in self.configuration.persistentStoreConfigurations {
            let type = persistentStoreConfiguration.type
            let configuration = persistentStoreConfiguration.configuration
            let url = persistentStoreConfiguration.url
            let options = persistentStoreConfiguration.options

            do {
                try coordinator.addPersistentStoreWithType(type.toCoreDataStoreType(), configuration: configuration, URL: url, options: options)
            } catch {
                let errorDescription = "Failed to initialize persistent store: \(persistentStoreConfiguration)"

                let userInfo = [
                    NSLocalizedDescriptionKey: errorDescription,
                    NSLocalizedFailureReasonErrorKey: "There was an error creating or loading the application's saved data.",
                    NSUnderlyingErrorKey: error as NSError
                ]

                let wrappedError = NSError(domain: Errors.Domain, code: Errors.PersistentStoreCreationErrorCode, userInfo: userInfo)

                NSLog("Glover: error: \(wrappedError) | \(wrappedError.userInfo)")
            }
        }

        return coordinator
    }()

    private lazy var masterContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator

        return context
    }()

    public lazy var managedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.parentContext = self.masterContext

        return context
    }()

    private lazy var workerContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.managedObjectContext

        return context
    }()

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public func performOnWorkerContext(closure: (context: NSManagedObjectContext) -> Void) {
        workerContext.performBlock {
            NSLog("Glover: working on thread \(NSThread.currentThread())")

            closure(context: self.workerContext)

            do {
                try self.workerContext.save()

                self.saveContext()
            } catch {
                let nserror = error as NSError
                NSLog("Glover: error: \(nserror) | \(nserror.userInfo)")
            }
        }
    }

    private func saveMasterContext() {
        masterContext.performBlock {
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

    public func saveContext() {
        managedObjectContext.performBlock {
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
