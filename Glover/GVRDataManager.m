//
//  GVRDataManager.m
//  Glover
//
//  Created by Sebastian Owodziń on 14/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "GVRDataManager.h"

NSString *const GVRErrorDomain = @"org.mobiletoolkit.ios.glover";

@interface GVRDataManager () {
    GVRDataManagerConfiguration *   __configuration;
    
    NSTimer *                       __delayedSaveTimer;
    BOOL                            __isSaving;
    
    NSManagedObjectContext *        __workerContext;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext * _writerManagedObjectContext;

- (void)__performDelayedSave;

@end

@implementation GVRDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize _writerManagedObjectContext = __writerManagedObjectContext;

- (NSManagedObjectModel *)managedObjectModel {
    if ( nil == _managedObjectModel ) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:__configuration.modelBundles];
        if ( 0 < __configuration.models.count ) {
            NSManagedObjectModel *model = [NSManagedObjectModel modelByMergingModels:__configuration.models];
            _managedObjectModel = [NSManagedObjectModel modelByMergingModels:@[ _managedObjectModel, model ]];
        }
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if ( nil == _persistentStoreCoordinator ) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        if ( 0 == __configuration.persistentStores.count ) {
            __configuration.persistentStores = @[
                @{
                    GVRDataManagerConfiguration_PersistentStoreURLKey: [[GVRDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"gloverDB.sqlite"],
                    GVRDataManagerConfiguration_PersistentStoreTypeKey: NSSQLiteStoreType
                }
            ];
        }
        
        [__configuration.persistentStores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSURL *storeURL = obj[GVRDataManagerConfiguration_PersistentStoreURLKey];
            NSString *storeType = obj[GVRDataManagerConfiguration_PersistentStoreTypeKey];
            NSString *storeConfiguration = obj[GVRDataManagerConfiguration_PersistentStoreConfigurationKey];
            NSDictionary *storeOptions = obj[GVRDataManagerConfiguration_PersistentStoreOptionsKey];
            
            NSError *error = nil;
            if ( nil == [_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:storeConfiguration URL:storeURL options:storeOptions error:&error] ) {
                
                NSDictionary *userInfo = @{
                    NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to initialize the persistent store: [ type: %@ | configuration: %@ | URL: %@ ]", storeType, storeConfiguration, storeURL],
                    NSLocalizedFailureReasonErrorKey: @"There was an error creating or loading the persisten store.",
                    NSUnderlyingErrorKey: error
                };
                
                error = [NSError errorWithDomain:GVRErrorDomain code:9999 userInfo:userInfo];
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
            }
        }];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if ( nil == _managedObjectContext ) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.parentContext = self._writerManagedObjectContext;
    }

    return _managedObjectContext;
}

/*!Returns application's documents directory URL.
 */
+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/*!Initializes data manager with given configuration.
 \param configuration
 The configuration to be used for initialization.
 \returns A data manager initialized with given configuration.
 */
- (instancetype)initWithConfiguration:(GVRDataManagerConfiguration *)configuration {
    self = [super init];
    if ( self ) {
        __configuration = configuration;
    }
    
    return self;
}

/*!Saves main thread context's data using a background writer context
 */
- (void)saveContext {
    if ( NO == __isSaving ) {
        __isSaving = YES;
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        
        [managedObjectContext performBlock:^{
            if ( [managedObjectContext hasChanges] ) {
//                NSLog(@"SAVING: main context on Thread: %@", NSThread.currentThread);
                
                NSError *error = nil;
                if ( ![managedObjectContext save:&error] ) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                    abort();
                }
                
                [__writerManagedObjectContext performBlock:^{
//                    NSLog(@"SAVING: writer context on Thread: %@", NSThread.currentThread);
                    
                    NSError *error = nil;
                    if ( ![__writerManagedObjectContext save:&error] ) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                        abort();
                    }
                    
                    __isSaving = NO;
                }];
            }
        }];
    }
}

/*!Creates a temporary worker context (if needed) & performs on it a data operation
 \param block Asynchronously performs a given block on the worker context's queue.
 
 You can use this method to process large amounts of CoreData changes & maintain UI responsiveness.
 */
- (void)dataOperationWithBlock:(void (^)(NSManagedObjectContext *context))block {
    if ( nil == __workerContext ) {
        __workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        __workerContext.parentContext = self.managedObjectContext;
        __workerContext.undoManager = nil;
    }
    
    [__workerContext performBlock:^{
        block(self.managedObjectContext);
        
        if ( [__workerContext hasChanges] ) {
//            NSLog(@"SAVING: worker context on Thread: %@", NSThread.currentThread);
            
            NSError *error = nil;
            if ( ![__workerContext save:&error] ) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __performDelayedSave];
        });
    }];
}

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    if ( self ) {
        __isSaving = NO;
    }
    
    return self;
}

#pragma mark - Private methods

- (NSManagedObjectContext *)_writerManagedObjectContext {
    if ( nil == __writerManagedObjectContext ) {
        __writerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        __writerManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return __writerManagedObjectContext;
}

- (void)__performDelayedSave {
    if ( nil != __delayedSaveTimer ) {
        [__delayedSaveTimer invalidate];
        __delayedSaveTimer = nil;
    }
    
    __delayedSaveTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(saveContext) userInfo:nil repeats:NO];
    
    __workerContext = nil;
}

@end
