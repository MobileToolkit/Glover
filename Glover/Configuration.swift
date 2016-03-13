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
    
    lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }()
    
    var model: NSManagedObjectModel!
    
    var persistentStoreConfigurations: [PersistentStoreConfiguration] = []
    
    public func addPersistentStoreConfiguration(persistentStoreConfiguration: PersistentStoreConfiguration) {
        persistentStoreConfigurations.append(persistentStoreConfiguration)
    }
    
    public class func defaultConfiguration() -> Configuration {
        return Configuration.singleSQLiteStoreConfiguration()
    }
    
    public class func singleSQLiteStoreConfiguration() -> Configuration {
        let configuration = Configuration()

        configuration.model = NSManagedObjectModel.mergedModelFromBundles(nil)
        configuration.addPersistentStoreConfiguration(PersistentStoreConfiguration(type: .SQLite, url: configuration.applicationDocumentsDirectory.URLByAppendingPathComponent("gloverDB.sqlite")))
        
        return configuration
    }
    
    public class func singleBinaryStoreConfiguration() -> Configuration {
        let configuration = Configuration()
        
        configuration.model = NSManagedObjectModel.mergedModelFromBundles(nil)
        configuration.addPersistentStoreConfiguration(PersistentStoreConfiguration(type: .Binary, url: configuration.applicationDocumentsDirectory.URLByAppendingPathComponent("gloverDB.bin")))
        
        return configuration
    }
    
    public class func singleInMemoryStoreConfiguration() -> Configuration {
        let configuration = Configuration()
        
        configuration.model = NSManagedObjectModel.mergedModelFromBundles(nil)
        configuration.addPersistentStoreConfiguration(PersistentStoreConfiguration(type: .InMemory))
        
        return configuration
    }
    
}
