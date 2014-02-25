//
//  LOCItem.h
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LOCItem : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) CLLocation* location;

-(instancetype) initWithName: (NSString*) name withLocation:(CLLocation*) location;
@end
