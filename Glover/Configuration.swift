//
//  Configuration.swift
//  Glover
//
//  Created by Sebastian Owodzin on 12/03/2016.
//  Copyright © 2016 mobiletoolkit.org. All rights reserved.
//

import Foundation

public class Configuration {
    
    public class func defaultConfiguration() -> Configuration {
        return Configuration()
    }
    
    class func singleSQLiteStoreConfiguration() -> Configuration {
        return Configuration()
    }
    
    class func singleBinaryStoreConfiguration() -> Configuration {
        return Configuration()
    }
    
    class func singleInMemoryStoreConfiguration() -> Configuration {
        return Configuration()
    }
    
}
