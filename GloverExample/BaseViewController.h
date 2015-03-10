//
//  BaseViewController.h
//  Glover
//
//  Created by Sebastian Owodziń on 07/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/NSFetchedResultsController.h>
#import <CoreData/NSFetchRequest.h>
#import "AppDelegate.h"

@interface BaseViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property (readonly, strong, nonatomic) NSFetchedResultsController * fetchedResultsController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSFetchRequest *)fetchRequest;

- (IBAction)importButtonTouched:(UIBarButtonItem *)sender;

@end
