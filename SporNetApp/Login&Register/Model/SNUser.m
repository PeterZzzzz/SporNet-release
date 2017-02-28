//
//  SNUser.m
//  SporNetApp
//
//  Created by 浦明晖 on 6/30/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNUser.h"

@implementation SNUser
@dynamic name,gender, gradYear, bestSport, sportTimeSlot, aboutMe, voteNumber, dateOfBirth;

+ (NSString *)parseClassName {
    return @"SNUser";
}

@end
