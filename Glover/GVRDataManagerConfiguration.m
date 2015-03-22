//
//  GVRDataManagerConfiguration.m
//  Glover
//
//  Created by Sebastian Owodziń on 21/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "GVRDataManagerConfiguration.h"

#import "GVRDataManager.h"

NSString *const GVRDataManagerConfiguration_PersistentStoreTypeKey = @"org.mobiletoolkit.glover.PersistentStoreTypeKey";
NSString *const GVRDataManagerConfiguration_PersistentStoreConfigurationKey = @"org.mobiletoolkit.glover.PersistentStoreConfigurationKey";
NSString *const GVRDataManagerConfiguration_PersistentStoreURLKey = @"org.mobiletoolkit.glover.PersistentStoreURLKey";
NSString *const GVRDataManagerConfiguration_PersistentStoreOptionsKey = @"org.mobiletoolkit.glover.PersistentStoreOptionsKey";

@implementation GVRDataManagerConfiguration

+ (instancetype)defaultConfiguration {
    return [GVRDataManagerConfiguration singleSQLiteStoreConfiguration];
}

+ (instancetype)singleSQLiteStoreConfiguration {
    GVRDataManagerConfiguration *configuration = [[GVRDataManagerConfiguration alloc] init];
    
    configuration.persistentStores = @[
        @{
            GVRDataManagerConfiguration_PersistentStoreURLKey: [[GVRDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"gloverDB.sqlite"],
            GVRDataManagerConfiguration_PersistentStoreTypeKey: NSSQLiteStoreType
        }
    ];
    
    return configuration;
}

+ (instancetype)singleBinaryStoreConfiguration {
    GVRDataManagerConfiguration *configuration = [[GVRDataManagerConfiguration alloc] init];
    
    configuration.persistentStores = @[
        @{
            GVRDataManagerConfiguration_PersistentStoreURLKey: [[GVRDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"gloverDB.bin"],
            GVRDataManagerConfiguration_PersistentStoreTypeKey: NSBinaryStoreType
        }
    ];
    
    return configuration;
}

+ (instancetype)singleInMemoryStoreConfiguration {
    GVRDataManagerConfiguration *configuration = [[GVRDataManagerConfiguration alloc] init];
    
    configuration.persistentStores = @[
        @{
            GVRDataManagerConfiguration_PersistentStoreTypeKey: NSInMemoryStoreType
        }
    ];
    
    return configuration;
}

@end
