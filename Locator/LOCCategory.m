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

@end
