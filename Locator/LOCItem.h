//
//  Item.h
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "LOCCategory.h"


@interface LOCItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) LOCCategory * category;

- (NSString*) creationDateStringShort;
- (NSString*) creationDateStringFull;
@end
