//
//  LocalDataManager.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/9/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "LocalDataManager.h"
#import <AVObject.h>
#import <AVUser.h>
#import <AVQuery.h>
#import <AVFile.h>
#import "SNUser.h"
#import "ProgressHUD.h"
#import "MessageManager.h"

static LocalDataManager *center = nil;

@interface LocalDataManager ()

@property(nonatomic) NSMutableArray *allUserInfo;

@end
@implementation LocalDataManager

+(instancetype)defaultManager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^ {
        center = (LocalDataManager*)@"LocalDataManager";
        center = [[LocalDataManager alloc]init];
    });
    return center;
}
-(instancetype)init {

    NSString *str = (NSString *)center;
    if([str isKindOfClass:[NSString class]] & [str isEqualToString:@"LocalDataManager"]) {
        self = [super init];
        if(self) {}
        return self;
    } else return nil;
}


+(void)fetchProfileInfoFromCloud {
    AVQuery *query = [SNUser query];
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    NSArray *fetchObjects = [query findObjects];
    if(fetchObjects.count == 0){
        
        return;
    }
    SNUser *basicInfo = fetchObjects.firstObject;
    
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    
    NSMutableArray *imageUrlArr = [[NSMutableArray alloc]init];
    NSArray *arr = [basicInfo objectForKey:@"PicUrls"];
    for(NSString *url in arr) {
        
        [imageUrlArr addObject:[[AVFile fileWithURL:url]getData]];
    }
    NSDictionary *plistDict = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects: [[basicInfo objectForKey:@"name"] componentsSeparatedByString:@" "][0], [[basicInfo objectForKey:@"name"] componentsSeparatedByString:@" "][1], [basicInfo objectForKey:@"gender"], [basicInfo objectForKey:@"dateOfBirth"], [basicInfo objectForKey:@"gradYear"], [basicInfo objectForKey:@"bestSport"], [basicInfo objectForKey:@"sportTimeSlot"],[basicInfo objectForKey:@"aboutMe"], imageUrlArr, nil] forKeys:[NSArray arrayWithObjects: @"firstName", @"lastName",@"gender", @"dateOfBirth",@"gradYear",@"bestSport",@"sportTimeSlot",@"aboutMe",@"photoes", nil]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
//        NSLog(@"plist writte successfully");
    } else {
        
//        NSLog(@"plist failed");
    }

}
+(void)updateProfileInfoOnCloudInBackground {
    
        //更新的时候，得把NSInteger值转为NSNumber

    AVQuery *query = [SNUser query];
        //选取当前登陆用户的所有记录
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    NSArray *fetchedPrayers = [query findObjects];
    SNUser *user;
    if(fetchedPrayers.count)
    {
       user = fetchedPrayers[0];
    }
    else {
        user = [[SNUser alloc]init];
        user.voteNumber = 0;
        NSDictionary *schools = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"emailToSchool" ofType:@"plist"]];
        NSString *lastComponet = [[[AVUser currentUser].email componentsSeparatedByString:@"@"]lastObject];
        NSArray *array = schools[lastComponet];
        [user setObject:[array firstObject] forKey:@"school"];
    }
    
    bool editProfile = [[NSUserDefaults standardUserDefaults]boolForKey:KUSER_EDIT_PROFILE];
    if (editProfile) {
        
        NSArray *imageUrls = [user objectForKey:@"PicUrls"];
        if (imageUrls.count) {
            
            for (NSString *imageUrl in imageUrls) {
                
                AVFile *imageFile = [AVFile fileWithURL:imageUrl];
                [imageFile getData];
                [imageFile deleteInBackground];
            }
        }
    }
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"basicInfo" ofType:@"plist"];
    }else {
        
        
        [user setObject:[NSString stringWithFormat:@"%@ %@", dict[@"firstName"], dict[@"lastName"]] forKey:@"name"];
        [user setObject:dict[@"gradYear"] forKey:@"gradYear"];
        [user setObject:dict[@"gender"] forKey:@"gender"];
        [user setObject:dict[@"bestSport"] forKey:@"bestSport"];
        [user setObject:dict[@"sportTimeSlot"] forKey:@"sportTimeSlot"];
        [user setObject:dict[@"dateOfBirth"] forKey:@"dateOfBirth"];
        [user setObject:dict[@"aboutMe"] forKey:@"aboutMe"];
        [user setObject:[AVUser currentUser].objectId forKey:@"userID"];
        [user setObject:[[AVUser currentUser]objectForKey:@"icon"] forKey:@"icon"];
        NSArray *imageData = dict[@"photoes"];
        NSMutableArray *arrayM = [NSMutableArray array];
        
        
            for (NSData *data in imageData) {
                
                AVFile *file = [AVFile fileWithData:data];
                [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        
                        [user setObject:arrayM forKey:@"PicUrls"];
                        [arrayM addObject:file.url];
                        [user save];
                        
                        //Start Message Manager
                        
                        [[MessageManager defaultManager] startMessageService];
                    }else {
                        
//                        NSLog(@"Saving Pics Error %@", error.description); 
                    }
                    
                }];
            }
        
        [[AVUser currentUser]setObject:[NSString stringWithFormat:@"%@ %@", dict[@"firstName"], dict[@"lastName"]] forKey:@"name"];
        [[AVUser currentUser]setObject:dict[@"sportTimeSlot"] forKey:@"sportTimeSlot"];
        [[AVUser currentUser]setObject:dict[@"bestSport"] forKey:@"bestSport"];
        [[AVUser currentUser]setObject:user forKey:@"basicInfo"];
        [[AVUser currentUser]setObject:@(YES) forKey:@"User_Registered"];
        [[AVUser currentUser]saveInBackground];
        [user saveInBackground];
        
        //Set Current User's Notification
        
        AVInstallation *installation = [AVInstallation currentInstallation];
        AVObject *owner = [[AVUser currentUser] objectForKey:@"basicInfo"];
        [owner fetch];
        [installation setObject:[owner objectForKey:@"name"] forKey:@"Owner"];

        [installation saveInBackground];


        }

    
}
-(NSMutableArray*)fetchCurrentAllUserInfo {
    
    return [self refreshAndFetchAllUserInfo];

}


//ZY
-(NSMutableArray*)fetchNearByUserInfo:(AVGeoPoint*)point withinDist:(CGFloat)dist {
    
        AVQuery *query = [SNUser query];
        [query includeKey:@"icon"];
        [query whereKey:@"GeoLocation" nearGeoPoint:point withinMiles:dist];
        [query whereKey:@"objectId" notEqualTo:SELF_ID];
        self.allUserInfo = [[query findObjects]mutableCopy];
        return _allUserInfo;
        
        

}


-(NSMutableArray*)filterUserByGenderFromList:(NSMutableArray*)userlist{
    BOOL isMaleSwitchOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"searchPreferenceMale"];
    BOOL isfemaleSwitchOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"searchPreferenceFemale"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *user = (AVObject*)obj;
        if (isMaleSwitchOn) {
            if (isfemaleSwitchOn) {
                return [[user objectForKey:@"gender"]integerValue] == 0 || [[user objectForKey:@"gender"]integerValue] == 1;
            }
            return [[user objectForKey:@"gender"]integerValue] == 0;
        } else{
            return [[user objectForKey:@"gender"]integerValue] == 1;
        }
        
        
    }];
    return [[userlist filteredArrayUsingPredicate:predicate]mutableCopy];
    
}

-(NSMutableArray*)fetchUserFromBlackList:(NSMutableArray*)userlist withBlackList:(NSMutableArray*)blacklist{
    //        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
    //
    //            AVObject *user = (AVObject*)obj;
    //
    //            return [user objectForKey:@"objectId"] != blacklist;
    //
    //    }];
    //    return [[userlist filteredArrayUsingPredicate:predicate]mutableCopy];
    //
    NSMutableArray *list = [NSMutableArray array];
    
    for (AVObject *user in userlist) {
        [user fetch];
        NSString *userid = [user objectForKey:@"objectId"];
        if (![blacklist containsObject:userid]){
            [list addObject:user];
        }
    }
    return list;
    
    //    NSMutableArray *list;
    //    NSPredicate *blacklisted = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)",blacklist];
    //    [userlist filterUsingPredicate:blacklisted];
    //    return list;
}

-(NSMutableArray*)fetchUserFromList:(NSMutableArray*)userlist withSportType:(NSInteger)sportType{
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *user = (AVObject*)obj;

        return [[user objectForKey:@"bestSport"]integerValue] == sportType;
        
    }];
    return [[userlist filteredArrayUsingPredicate:predicate]mutableCopy];
    
}

-(NSMutableArray*)fetchUserInfoBySportType:(NSInteger)sportType {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *user = (AVObject*)obj;
        return [[user objectForKey:@"bestSport"]integerValue] == sportType;
    }];
    return [[_allUserInfo filteredArrayUsingPredicate:predicate]mutableCopy];

}
-(NSMutableArray*)refreshAndFetchAllUserInfo {
    AVQuery *query = [SNUser query];
    [query includeKey:@"icon"];
    [query orderByDescending:@"voteNumber"];
    query.cachePolicy = kAVCachePolicyNetworkOnly; 
    NSArray *users = [query findObjects];
    self.allUserInfo = [users mutableCopy];

    return self.allUserInfo;
    
}
-(BOOL)filterError:(NSError *)error{
    if (error) {
//        NSLog(@"%@", error);
        return NO;
    } else {
        return YES;
    }
}
@end
