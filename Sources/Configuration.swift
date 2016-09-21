//
//  Configuration.swift
//  Glover
//
//  Created by Sebastian Owodzin on 12/03/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import Foundation
import CoreData

open class Configuration {
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    var model: NSManagedObjectModel

    var persistentStoreConfigurations: [PersistentStoreConfiguration] = []

    open func addPersistentStoreConfiguration(_ persistentStoreConfiguration: PersistentStoreConfiguration) {
        persistentStoreConfigurations.append(persistentStoreConfiguration)
    }

    public init(model: NSManagedObjectModel) {
        self.model = model
    }

    open class func singleSQLiteStoreConfiguration(_ model: NSManagedObjectModel) -> Configuration {
        let configuration = Configuration(model: model)

        let storeURL = configuration.applicationDocumentsDirectory.appendingPathComponent("gloverDB.sqlite")
        let storeConfig = PersistentStoreConfiguration(type: .SQLite, url: storeURL)

        configuration.addPersistentStoreConfiguration(storeConfig)

        return configuration
    }

    open class func singleBinaryStoreConfiguration(_ model: NSManagedObjectModel) -> Configuration {
        let configuration = Configuration(model: model)

        let storeURL = configuration.applicationDocumentsDirectory.appendingPathComponent("gloverDB.bin")
        let storeConfig = PersistentStoreConfiguration(type: .Binary, url: storeURL)

        configuration.addPersistentStoreConfiguration(storeConfig)

        return configuration
    }

    open class func singleInMemoryStoreConfiguration(_ model: NSManagedObjectModel) -> Configuration {
        let configuration = Configuration(model: model)

        configuration.addPersistentStoreConfiguration(PersistentStoreConfiguration(type: .InMemory))

        return configuration
    }
}
