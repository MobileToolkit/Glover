//
//  InMemoryEntityViewController.m
//  Glover
//
//  Created by Sebastian Owodziń on 07/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import "InMemoryEntityViewController.h"

#import "InMemoryEntity.h"

@interface InMemoryEntityViewController ()

@end

@implementation InMemoryEntityViewController

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"InMemoryEntity"];
    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    
    return fetchRequest;
}

- (IBAction)refreshButtonTouched:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    for ( NSUInteger idx = 0; idx < 1000; idx++ ) {
        InMemoryEntity *entity = [NSEntityDescription insertNewObjectForEntityForName:@"InMemoryEntity" inManagedObjectContext:appDelegate.dataManager.managedObjectContext];
        
        entity.name = [NSString stringWithFormat:@"InMemoryEntity_%lu", idx];
    }
    
    [appDelegate.dataManager saveContext];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExampleCell" forIndexPath:indexPath];
    
    InMemoryEntity *entity = (InMemoryEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = entity.name;
    
    return cell;
}

@end
