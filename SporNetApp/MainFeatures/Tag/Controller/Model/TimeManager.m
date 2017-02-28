//
//  TimeManager.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/1/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "TimeManager.h"
#import <NSDate+DateTools.h>
static NSDateFormatter *timeFormatter = nil;
static NSDateFormatter *dateFormatter = nil;
@implementation TimeManager
+(NSString*)getTimeStringFromNSDate:(NSDate*)date {
    if(timeFormatter == nil) {
        timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"HH:mm";
    }
    return [timeFormatter stringFromDate:date];
}
+(NSString*)getDateString:(NSDate*)date {
    if(dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";;
    }
    return [dateFormatter stringFromDate:date];
}

+(NSString*)getTimeLabelString:(NSDate*)checkinTime refreshTime:(NSDate*)refreshTime {
    NSString *result;
    NSTimeInterval distanceSeconds = -[checkinTime timeIntervalSinceDate:refreshTime];
    if(distanceSeconds < 60) result = [NSString stringWithFormat:@"%lds ago", (long)distanceSeconds];
    else if (distanceSeconds < 3600) result = [NSString stringWithFormat:@"%ldmin ago", (long)distanceSeconds / 60];
    else result = [NSString stringWithFormat:@"%ldhr ago", (long)distanceSeconds/3600];
    return result;
}


+ (NSString *)getConvastionTimeStr:(NSDate *)sendDate
{
    NSString *timeString;
    if([sendDate isToday]) timeString = [self getTimeStringFromNSDate:sendDate];
    else if([sendDate isYesterday]) timeString = [NSString stringWithFormat:@"Yesterday %@", [self getTimeStringFromNSDate:sendDate]];
    else if([[NSDate date]daysFrom:sendDate] <= 7) {
        timeString = [NSString stringWithFormat:@"%@ %@", WEEKDAYS[[sendDate weekday]], [self getTimeStringFromNSDate:sendDate]];
    } else timeString = [NSString stringWithFormat:@"%@ %@", [self getDateString:sendDate], [self getTimeStringFromNSDate:sendDate]];
    return timeString;
}

+(NSInteger)calculateAgeByBirthday:(NSDate*)birthday {
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:[NSDate date]
                                       options:0];
    return [ageComponents year];
}
@end
