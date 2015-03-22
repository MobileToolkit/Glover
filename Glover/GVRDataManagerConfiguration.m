//
//  GVRDataManagerConfiguration.m
//  Glover
//
//  Created by Sebastian Owodziń on 21/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "GVRDataManagerConfiguration.h"

#import "GVRDataManager.h"

NSString *const GVRDataManagerConfigurationPersistentStoreTypeKey = @"org.mobiletoolkit.glover.PersistentStoreTypeKey";
NSString *const GVRDataManagerConfigurationPersistentStoreConfigurationKey = @"org.mobiletoolkit.glover.PersistentStoreConfigurationKey";
NSString *const GVRDataManagerConfigurationPersistentStoreURLKey = @"org.mobiletoolkit.glover.PersistentStoreURLKey";
NSString *const GVRDataManagerConfigurationPersistentStoreOptionsKey = @"org.mobiletoolkit.glover.PersistentStoreOptionsKey";

@implementation GVRDataManagerConfiguration

+ (instancetype)defaultConfiguration {
    return [[GVRDataManagerConfiguration alloc] init];
}

+ (instancetype)singleSQLiteStoreConfiguration {
    GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration defaultConfiguration];
    
    configuration.persistentStores = @[
        @{
            GVRDataManagerConfigurationPersistentStoreURLKey: [[GVRDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"gloverDB.sqlite"],
            GVRDataManagerConfigurationPersistentStoreTypeKey: NSSQLiteStoreType
        }
    ];
    
    return configuration;
}

+ (instancetype)singleBinaryStoreConfiguration {
    GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration defaultConfiguration];
    
    configuration.persistentStores = @[
        @{
            GVRDataManagerConfigurationPersistentStoreURLKey: [[GVRDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"gloverDB.sqlite"],
            GVRDataManagerConfigurationPersistentStoreTypeKey: NSBinaryStoreType
        }
    ];
    
    return configuration;
}

+ (instancetype)singleInMemoryStoreConfiguration {
    GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration defaultConfiguration];
    
    configuration.persistentStores = @[
        @{
            GVRDataManagerConfigurationPersistentStoreURLKey: [[GVRDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"gloverDB.sqlite"],
            GVRDataManagerConfigurationPersistentStoreTypeKey: NSInMemoryStoreType
        }
    ];
    
    return configuration;
}

@end
