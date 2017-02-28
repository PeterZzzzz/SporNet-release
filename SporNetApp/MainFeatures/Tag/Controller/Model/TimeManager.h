//
//  TimeManager.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/1/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject
+(NSString*)getTimeStringFromNSDate:(NSDate*)date;
+(NSString*)getDateString:(NSDate*)date;
+(NSString*)getTimeLabelString:(NSDate*)checkinTime refreshTime:(NSDate*)refreshTime;
+(NSInteger)calculateAgeByBirthday:(NSDate*)birthday;
+(NSString *)getConvastionTimeStr:(NSDate *)sendDate;
@end
