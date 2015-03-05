//
//  ViewController.h
//  GloverExample
//
//  Created by Sebastian Owodziń on 21/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshButtonTouched:(UIBarButtonItem *)sender;

- (IBAction)trashButtonTouched:(UIBarButtonItem *)sender;

@end

