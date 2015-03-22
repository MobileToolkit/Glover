# Glover

Multi-layered data manager that utilises CoreData by using multiple contexts & async saving.

## Information

* Source code [available on GitHub](https://github.com/MobileToolkit/Glover-iOS)

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

## Customising GVRDataManager with GVRDataManagerConfiguration

### Using pre-defined configurations

```Objective-C
// default configuration (single SQLite store & merged models from main bundle)
GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration defaultConfiguration];
GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:configuration];

// single SQLite store configuration (single SQLite store & merged models from main bundle)
GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration singleSQLiteStoreConfiguration];
GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:configuration];

// single binary store configuration (single binary store & merged models from main bundle)
GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration singleBinaryStoreConfiguration];
GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:configuration];

// single in-memory store configuration (single in-memory store & merged models from main bundle)
GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration singleInMemoryStoreConfiguration];
GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:configuration];
```

### Using self-defined configuration

```Objective-C
GVRDataManagerConfiguration *configuration = [GVRDataManagerConfiguration defaultConfiguration];

// bundles array to look up models
configuration.modelBundles = @[ ... ];
// models array to combine
configuration.models = @[ ... ];
// persistent stores array to use
configuration.persistentStores = @[
  @{
    GVRDataManagerConfiguration_PersistentStoreURLKey: [[GVRDataManager applicationDocumentsDirectory] URLByAppendingPathComponent:@"gloverPersistedEntities.sqlite"],
    GVRDataManagerConfiguration_PersistentStoreTypeKey: NSSQLiteStoreType,
    GVRDataManagerConfiguration_PersistentStoreConfigurationKey: @"PersistedEntities"
  },
  @{
    GVRDataManagerConfiguration_PersistentStoreTypeKey: NSInMemoryStoreType,
    GVRDataManagerConfiguration_PersistentStoreConfigurationKey: @"InMemoryEntities"
  }
]

GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:configuration];
```

## Processing large amounts of CoreData changes & maintaining UI responsiveness

If you need to process a lot of CoreData changes & maintain your app's UI responsive Glover has something nice for you.

```Objective-C
GVRDataManager *dataManager = [[GVRDataManager alloc] initWithConfiguration:[GVRDataManagerConfiguration defaultConfiguration]];

for ( NSUInteger idx = 0; idx < 10000; idx++ ) {
  [dataManager dataOperationWithBlock:^(NSManagedObjectContext *context) {
    // here you should do all changes (make sure you use workerContext for those)
  }];
}
```
