//
//  AppDelegate.h
//  GloverExample
//
//  Created by Sebastian Owodziń on 21/02/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

@import UIKit;
@import Glover;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) GVRDataManager *simpleDataManager;

@property (readonly, strong, nonatomic) GVRDataManager *complexDataManager;

@end

