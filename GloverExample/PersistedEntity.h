//
//  PersistedEntity.h
//  Glover
//
//  Created by Sebastian Owodziń on 07/03/2015.
//  Copyright (c) 2015 mobiletoolkit.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersistedEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;

@end
