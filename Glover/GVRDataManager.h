//
//  GVRDataManager.h
//  Glover
//
//  Created by Sebastian Owodziń on 14/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "GVRDataManagerConfiguration.h"

FOUNDATION_EXPORT NSString *const GVRErrorDomain;

@interface GVRDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;

+ (NSURL *)applicationDocumentsDirectory;

- (instancetype)initWithConfiguration:(GVRDataManagerConfiguration *)configuration;

- (void)saveContext;

- (void)dataOperationWithBlock:(void (^)(NSManagedObjectContext *workerContext))workerContextBlock;

@end
