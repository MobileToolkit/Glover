//
//  Configuration.swift
//  Glover
//
//  Created by Sebastian Owodzin on 12/03/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import Foundation
import CoreData

public class Configuration {
    private lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()

    var model: NSManagedObjectModel

    var persistentStoreConfigurations: [PersistentStoreConfiguration] = []

    public func addPersistentStoreConfiguration(persistentStoreConfiguration: PersistentStoreConfiguration) {
        persistentStoreConfigurations.append(persistentStoreConfiguration)
    }

    public init(model: NSManagedObjectModel) {
        self.model = model
    }

    public class func singleSQLiteStoreConfiguration(model: NSManagedObjectModel) -> Configuration {
        let configuration = Configuration(model: model)

        let storeURL = configuration.applicationDocumentsDirectory.URLByAppendingPathComponent("gloverDB.sqlite")
        let storeConfig = PersistentStoreConfiguration(type: .SQLite, url: storeURL)

        configuration.addPersistentStoreConfiguration(storeConfig)

        return configuration
    }

    public class func singleBinaryStoreConfiguration(model: NSManagedObjectModel) -> Configuration {
        let configuration = Configuration(model: model)

        let storeURL = configuration.applicationDocumentsDirectory.URLByAppendingPathComponent("gloverDB.bin")
        let storeConfig = PersistentStoreConfiguration(type: .Binary, url: storeURL)

        configuration.addPersistentStoreConfiguration(storeConfig)

        return configuration
    }

    public class func singleInMemoryStoreConfiguration(model: NSManagedObjectModel) -> Configuration {
        let configuration = Configuration(model: model)

        configuration.addPersistentStoreConfiguration(PersistentStoreConfiguration(type: .InMemory))

        return configuration
    }
}
