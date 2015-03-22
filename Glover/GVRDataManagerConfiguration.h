//
//  GVRDataManagerConfiguration.h
//  Glover
//
//  Created by Sebastian Owodziń on 21/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const GVRDataManagerConfigurationPersistentStoreTypeKey;
FOUNDATION_EXPORT NSString *const GVRDataManagerConfigurationPersistentStoreConfigurationKey;
FOUNDATION_EXPORT NSString *const GVRDataManagerConfigurationPersistentStoreURLKey;
FOUNDATION_EXPORT NSString *const GVRDataManagerConfigurationPersistentStoreOptionsKey;

@interface GVRDataManagerConfiguration : NSObject

@property (copy) NSArray * modelBundles;
@property (copy) NSArray * models;

@property (copy) NSArray * persistentStores;

+ (instancetype)defaultConfiguration;

+ (instancetype)singleSQLiteStoreConfiguration;
+ (instancetype)singleBinaryStoreConfiguration;
+ (instancetype)singleInMemoryStoreConfiguration;

@end
