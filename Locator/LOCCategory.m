//
//  LOCCategory.m
//  Locator
//
//  Created by Brad Charna on 3/25/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCCategory.h"
#import "LOCItem.h"


@implementation LOCCategory

@dynamic name;
@dynamic item;
@dynamic creationDate;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.creationDate = [NSDate date];
}

+ (instancetype) defaultCategoryUsingContext:(NSManagedObjectContext*) context
{
  NSEntityDescription *entityDescription = [NSEntityDescription
                                            entityForName:@"LOCCategory" inManagedObjectContext:context];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entityDescription];
  NSError *error;
  NSArray *array = [context executeFetchRequest:request error:&error];
  return [array objectAtIndex:0];
}

- (void) deleteCategory
{
    LOCCategory *defaultCategory = [LOCCategory defaultCategoryUsingContext:self.managedObjectContext];
    [self.item enumerateObjectsUsingBlock:^(LOCItem *item, BOOL *stop) {
        item.category = defaultCategory;
    }];
    NSError *error;
    [self.managedObjectContext deleteObject:self];
    [self.managedObjectContext save:&error];
}

@end
