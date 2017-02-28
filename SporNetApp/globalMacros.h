//
//  globalMacros.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/1/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#ifndef globalMacros_h
#define globalMacros_h
#define WEEKDAYS @[@"", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"]
#define SPORTSLOT_COLOR_ARRAY @[[UIColor colorWithRed:245/255.0 green:143/255.0 blue:61/255.0 alpha:1.0], [UIColor colorWithRed:236/255.0 green:212/255.0 blue:126/255.0 alpha:1.0], [UIColor colorWithRed:166/255.0 green:217/255.0 blue:210/255.0 alpha:1.0],[UIColor colorWithRed:64/255.0 green:114/255.0 blue:185/255.0 alpha:1.0]]
#define TAB_TINT_COLOR [UIColor redColor]
#define BESTSPORT_IMAGE_ARRAY @[@"", @"joggingSelected", @"muscleSelected", @"soccerSelected", @"basketballSelected", @"yogaSelected"]

#define SPORTSLOT_ARRAY @[@"Morning", @"Noon", @"Afternoon", @"Evening"]
#define SPORT_ARRAY @[@"Running", @"Fitness", @"Soccer", @"Basketball", @"Yoga"]
#define BEST_SPORT_IMAGE_ARRAY @[[UIImage imageNamed:@"joggingSelected"], [UIImage imageNamed:@"muscleSelected"], [UIImage imageNamed:@"soccerSelected"], [UIImage imageNamed:@"basketballSelected"], [UIImage imageNamed:@"yogaSelected"]]

#define SPORT_IMAGE_DIC @{@"Running":@"joggingSelected", @"Fitness":@"muscleSelected",@"Soccer":@"soccerSelected", @"Basketball":@"basketballSelected", @"Yoga":@"yogaSelected"}
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

#define SELF_ID [[[AVUser currentUser] objectForKey:@"basicInfo"]objectId]


//SandBox for User Login
#define KUSER_EMAIL @"USER_EMAIL"
#define KUSER_PASSWORD @"USER_PASSWORD"
#define KUSER_FIRST_REGISTER @"USER_FIRST_REGISTER" 
#define KUSER_SCHOOL_NAME @"USER_SCHOOL_NAME"

//SanBox for Other Uses
#define KUSER_EDIT_PROFILE @"EDIT_USER_PROFILE"

#endif /* globalMacros_h */
