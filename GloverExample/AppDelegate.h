//
//  AppDelegate.h
//  GloverExample
//
//  Created by Sebastian Owodziń on 21/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Glover/Glover.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) GLODataManager *dataManager;

@end

