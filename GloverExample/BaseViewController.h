//
//  BaseViewController.h
//  Glover
//
//  Created by Sebastian Owodziń on 07/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

@import UIKit;
@import CoreData;

#import "AppDelegate.h"

@class NSManagedObjectContext;
@class NSFetchRequest;

@interface BaseViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property (readonly, strong, nonatomic) NSFetchedResultsController * fetchedResultsController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSManagedObjectContext *)managedObjectContext;

- (NSFetchRequest *)fetchRequest;

- (IBAction)importButtonTouched:(UIBarButtonItem *)sender;

@end
