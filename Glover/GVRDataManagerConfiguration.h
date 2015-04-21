//
//  GVRDataManagerConfiguration.h
//  Glover
//
//  Created by Sebastian Owodziń on 21/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

@import Foundation;

FOUNDATION_EXPORT NSString *const GVRDataManagerConfiguration_PersistentStoreTypeKey;
FOUNDATION_EXPORT NSString *const GVRDataManagerConfiguration_PersistentStoreConfigurationKey;
FOUNDATION_EXPORT NSString *const GVRDataManagerConfiguration_PersistentStoreURLKey;
FOUNDATION_EXPORT NSString *const GVRDataManagerConfiguration_PersistentStoreOptionsKey;

@interface GVRDataManagerConfiguration : NSObject

@property (copy) NSArray * modelBundles;
@property (copy) NSArray * models;

@property (copy) NSArray * persistentStores;

+ (instancetype)defaultConfiguration;

+ (instancetype)singleSQLiteStoreConfiguration;
+ (instancetype)singleBinaryStoreConfiguration;
+ (instancetype)singleInMemoryStoreConfiguration;

@end
