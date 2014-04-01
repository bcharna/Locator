//
//  Item.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCItem.h"


@implementation LOCItem

@dynamic name;
@dynamic location;
@dynamic creationDate;
@dynamic category;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.creationDate = [NSDate date];
}

- (NSString *)creationDateStringFull
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E, MMM d, yyyy"];
    NSString *date = [formatter stringFromDate:self.creationDate];
    [formatter setDateFormat:@"h:mm a"];
    NSString *time = [formatter stringFromDate:self.creationDate];
    NSString *label = [NSString stringWithFormat:@"Added %@ at %@", date, time];
    return label;
}

- (NSString*) creationDateStringShort
{
    NSDate *midnight = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:midnight];
    midnight = [currentCalendar dateFromComponents:dateComponents];
    dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-1];
    NSDate *oneDayAgo = [currentCalendar dateByAddingComponents:dateComponents toDate:midnight options:0];
    dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *sevenDaysAgo = [currentCalendar dateByAddingComponents:dateComponents toDate:midnight options:0];
    NSComparisonResult result;
    result = [midnight compare:self.creationDate];
    BOOL createdToday = result == NSOrderedAscending;
    result = [oneDayAgo compare:self.creationDate];
    BOOL createdWithinOneDay = result == NSOrderedAscending;
    result = [sevenDaysAgo compare:self.creationDate];
    BOOL createdWithinSevenDays = result == NSOrderedAscending;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *date;
    if (createdToday) {
        // 3:30 PM
        [formatter setDateFormat:@"h:mm a"];
        date = [formatter stringFromDate:self.creationDate];
        return date;
    } else if (createdWithinOneDay) {
        return @"Yesterday";
    } else if (createdWithinSevenDays) {
        // Wednesday
        [formatter setDateFormat:@"EEEE"];
        date = [formatter stringFromDate:self.creationDate];
        return date;
    } else {
        // 3/2/14
        [formatter setDateFormat:@"M/d/yy"];
        date = [formatter stringFromDate:self.creationDate];
        return date;
    }
}
@end
