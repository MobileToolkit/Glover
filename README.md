# Glover

Multi-layered data manager that utilises CoreData by using multiple contexts & async saving.

## Information

* Source code [available on GitHub](https://github.com/MobileToolkit/Glover-iOS)
* More information, known limitations, and how-tos [available on the wiki](https://github.com/MobileToolkit/Glover-iOS/wiki)

## Getting Help

* Please ask the community on [Stack Overflow](http://stackoverflow.com/) for help if you have any questions. Please do not post usage questions on the issue tracker.
* Please report bugs on the [issue tracker](https://github.com/MobileToolkit/Glover-iOS/issues) but read the "getting help" section in the wiki first.

## Installation

Latest stable release is always available in [releases](https://github.com/MobileToolkit/Glover-iOS/releases) (both binary & source).

The recommended way to install Glover is to download the binary release, unzip it & just drag & drop **Glover.framework** into your Xcode project.

## Getting Started

The easies way start using the Glover's goodness is:
  
```Objective-C
#import <Glover/Glover.h>

// instantiate GVRDataManagerConfiguration object
GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration defaultConfiguration];

// instantiate GVRDataManager object using GVRDataManagerConfiguration object:
GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:configuration];
```

And that's it!

Now you can start using **dataManager.managedObjectContext** like you'd use with a standard CoreData setup.

### Customising GVRDataManagerConfiguration

// TODO

## Processing large amounts of CoreData changes & maintaining UI responsiveness

If you need to process a lot of CoreData changes & maintain your app's UI responsive Glover has something nice for you.

```Objective-C
GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration defaultConfiguration];

GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:configuration]

for ( NSUInteger idx = 0; idx < 10000; idx++ ) {
        [dataManager dataOperationWithBlock:^(NSManagedObjectContext *workerContext) {
            // here you should do all changes (make sure you use workerContext for those)
        }];
    }
```
