//
//  SNUser.h
//  SporNetApp
//
//  Created by 浦明晖 on 6/30/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//
#import "AVObject.h"
#import <AVOSCloud/AVOSCloud.h>


static NSString *const kStudnetKeyGender = @"gender";
static NSString *const kStudentKeyName = @"name";
static NSString *const kStudentKeyGradYear = @"gradYear";
static NSString *const kBestSport = @"bestSport";
static NSString *const kSportTimeSlot =@"sportTimeSlot";
static NSString *const kAboutMe = @"aboutMe";
static NSString *const kDateOfBirth = @"dateOfBirth";

typedef NS_ENUM(NSInteger, GenderType){
    GenderMale,
    GenderFamale
};

typedef NS_ENUM(NSInteger, BestSports) {
    BestSportsJogging = 1,
    BestSportsMuscle,
    BestSportsSoccer,
    BestSportsBasketball,
    BestSportsYoga
};
typedef NS_ENUM(NSInteger, SportTimeSlot) {
    SportTimeSlotMorning,
    SportTimeSlotNoon,
    SportTimeSlotAfternoon,
    SportTimeSlotNight
};
//store all user information provided in profile page.
@interface SNUser : AVObject<AVSubclassing>
//user's name
@property (nonatomic, copy  ) NSString      *name;
//user's gender
@property (nonatomic, assign) GenderType    gender;
//user's gender
@property (nonatomic, assign) NSDate    *dateOfBirth;
//user's year of graduation
@property (nonatomic, assign) NSInteger     gradYear;
//user's account information including email and password.
@property (nonatomic, assign) AVUser        *user;
//user's best sport
@property (nonatomic, assign) enum BestSports    bestSport;
//user's sport time splot
@property (nonatomic, assign) enum SportTimeSlot sportTimeSlot;
//user's self introduction
@property (nonatomic, assign) NSString      *aboutMe;
@property(nonatomic, assign) NSInteger voteNumber;
@end
