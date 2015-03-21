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
    NSTimer *                   __autoSaveTimer;
    BOOL                        __isSaving;
    NSManagedObjectContext *    __workerContext;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext * _writerManagedObjectContext;

- (void)__performDelayedAutoSave;

@end

@implementation GVRDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize _writerManagedObjectContext = __writerManagedObjectContext;

- (NSManagedObjectModel *)managedObjectModel {
    if ( nil == _managedObjectModel ) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if ( nil == _persistentStoreCoordinator ) {
        //TODO: create multiple persistent stores if needed (for different model configurations)
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"glover.sqlite"];
        NSString *storeType = NSSQLiteStoreType;
        NSString *storeConfiguration = nil;
        
        NSError *error = nil;
        if ( nil == [_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:storeConfiguration URL:storeURL options:nil error:&error] ) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Failed to initialize the persistent store: [ type: %@ | configuration: %@ | URL: %@ ]", storeType, storeConfiguration, storeURL],
                                       NSLocalizedFailureReasonErrorKey: @"There was an error creating or loading the persisten store.",
                                       NSUnderlyingErrorKey: error
                                       };
            
            error = [NSError errorWithDomain:GVRErrorDomain code:9999 userInfo:userInfo];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
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

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    if ( NO == __isSaving ) {
        __isSaving = YES;
        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
        
        [managedObjectContext performBlock:^{
            if ( [managedObjectContext hasChanges] ) {
                NSLog(@"SAVING: main context on Thread: %@", NSThread.currentThread);
                
                NSError *error = nil;
                if ( ![managedObjectContext save:&error] ) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
                
                [__writerManagedObjectContext performBlock:^{
                    NSLog(@"SAVING: writer context on Thread: %@", NSThread.currentThread);
                    
                    NSError *error = nil;
                    if ( ![__writerManagedObjectContext save:&error] ) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                    
                    __isSaving = NO;
                }];
            }
        }];
    }
}

- (void)dataOperationWithBlock:(void (^)(NSManagedObjectContext *workerContext))workerContextBlock {
    if ( nil == __workerContext ) {
        __workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        __workerContext.parentContext = self.managedObjectContext;
        __workerContext.undoManager = nil;
    }
    
    [__workerContext performBlock:^{
        workerContextBlock(__workerContext);
        
        if ( [__workerContext hasChanges] ) {
            NSLog(@"SAVING: worker context on Thread: %@", NSThread.currentThread);
            
            NSError *error = nil;
            if ( ![__workerContext save:&error] ) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __performDelayedAutoSave];
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

- (void)__performDelayedAutoSave {
    if ( nil != __autoSaveTimer ) {
        [__autoSaveTimer invalidate];
        __autoSaveTimer = nil;
    }
    
    __autoSaveTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(saveContext) userInfo:nil repeats:NO];
}

@end
