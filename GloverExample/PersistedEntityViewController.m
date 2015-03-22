//
//  PersistedEntityViewController.m
//  Glover
//
//  Created by Sebastian Owodziń on 07/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "PersistedEntityViewController.h"

#import "PersistedEntity.h"

@interface PersistedEntityViewController ()

@end

@implementation PersistedEntityViewController

- (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appDelegate.complexDataManager.managedObjectContext;
}

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PersistedEntity"];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    
    return fetchRequest;
}

- (IBAction)importButtonTouched:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for ( NSUInteger idx = 0; idx < 1000; idx++ ) {
        [appDelegate.complexDataManager dataOperationWithBlock:^(NSManagedObjectContext *workerContext) {
            PersistedEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"PersistedEntity" inManagedObjectContext:workerContext];
            
            entity.name = [NSString stringWithFormat:@"PersistedEntity_%lu", idx];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExampleCell" forIndexPath:indexPath];
    
    PersistedEntity *entity = (PersistedEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = entity.name;
    
    return cell;
}

@end
