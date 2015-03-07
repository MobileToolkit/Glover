//
//  GVRDataManager.m
//  Glover
//
//  Created by Sebastian Owodziń on 14/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "GVRDataManager.h"

@interface GVRDataManager () {

}

@property (readonly, strong, nonatomic) NSManagedObjectContext * _writerManagedObjectContext;

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
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if ( nil != managedObjectContext ) {
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
            }];
        }
    }
}

#pragma mark - Private methods

- (NSManagedObjectContext *)_writerManagedObjectContext {
    if ( nil == __writerManagedObjectContext ) {
        __writerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        __writerManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return __writerManagedObjectContext;
}

@end
