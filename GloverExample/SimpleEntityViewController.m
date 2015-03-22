//
//  SimpleEntityViewController.m
//  GloverExample
//
//  Created by Sebastian Owodziń on 21/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "SimpleEntityViewController.h"

#import "SimpleEntity.h"

@interface SimpleEntityViewController ()

@end

@implementation SimpleEntityViewController

- (NSManagedObjectContext *)managedObjectContext {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return appDelegate.simpleDataManager.managedObjectContext;
}

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SimpleEntity"];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    
    return fetchRequest;
}

- (IBAction)importButtonTouched:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for ( NSUInteger idx = 0; idx < 1000; idx++ ) {
        [appDelegate.simpleDataManager dataOperationWithBlock:^(NSManagedObjectContext *context) {
            SimpleEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"SimpleEntity" inManagedObjectContext:context];
            
            entity.name = [NSString stringWithFormat:@"SimpleEntity_%lu", (unsigned long)idx];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExampleCell" forIndexPath:indexPath];
    
    SimpleEntity *entity = (SimpleEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = entity.name;
    
    return cell;
}

@end
