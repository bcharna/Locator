//
//  LOCCategory.h
//  Locator
//
//  Created by Brad Charna on 3/25/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LOCCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *item;
@property (nonatomic, retain) NSDate * creationDate;
+ (instancetype) defaultCategoryUsingContext:(NSManagedObjectContext*) context;
- (void) deleteCategory;
@end