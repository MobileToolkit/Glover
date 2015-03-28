# Glover

This framework reduces complexity of CoreData's setup when one would want to use multiple context approach to keep the UI responsive even when there are 1000's of data changes being processed. It is achieved by using multiple contexts on separate threads & async saving.

## Information

* Source code [available on GitHub](https://github.com/MobileToolkit/Glover-iOS)

## Getting Help

* Please ask the community on [Stack Overflow](http://stackoverflow.com/) for help if you have any questions. Please do not post usage questions on the issue tracker.
* Please report bugs on the [issue tracker](https://github.com/MobileToolkit/Glover-iOS/issues), but check the [wiki](https://github.com/MobileToolkit/Glover-iOS/wiki) first.

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

For more information please check the [wiki pages](https://github.com/MobileToolkit/Glover-iOS/wiki).
