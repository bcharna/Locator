//
//  LOCItem.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCItem.h"

@implementation LOCItem
-(instancetype) initWithName: (NSString*) name withLocation:(CLLocation*) location
{
  if (self = [super init]) {
    self.name = name;
    self.location = location;
  }
  return self;
}
@end
