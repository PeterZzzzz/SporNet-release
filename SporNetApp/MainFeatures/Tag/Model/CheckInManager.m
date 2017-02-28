//
//  CheckInManager.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/10/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "CheckInManager.h"
#import <AVObject+Subclass.h>
#import <AVUser.h>
#import <AVQuery.h>
#import "ProgressHUD.h"
#import "TimeManager.h"
static CheckInManager *center = nil;

@interface CheckInManager ()

@property(nonatomic) NSMutableArray *allCheckIns;
@end
@implementation CheckInManager
+(instancetype)defaultManager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^ {
        center = (CheckInManager*)@"CheckInManager";
        center = [[CheckInManager alloc]init];
    });
    return center;
}
-(instancetype)init {
    //    if(_allPrayers == nil) {
    //        _allPrayers = [[NSMutableArray alloc]init];
    //        _prayerDic = [[NSMutableDictionary alloc]init];
    //    }
    NSString *str = (NSString *)center;
    if([str isKindOfClass:[NSString class]] & [str isEqualToString:@"CheckInManager"]) {
        self = [super init];
        if(self) {}
        return self;
    } else return nil;
}
-(void)checkinWithGymname:(NSString*)gymName sportType:(NSInteger)sportType viewController:(UIViewController*)vc {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AVObject *checkin;
        if([[AVUser currentUser]objectForKey:@"CheckIn"]) checkin = [[AVUser currentUser]objectForKey:@"CheckIn"];
        else  {
            checkin = [AVObject objectWithClassName:@"CheckIn"];
            NSLog(@"嘎嘎嘎嘎");
        }
        
        [checkin setObject:[AVUser currentUser].objectId forKey:@"userID"];
        [checkin setObject:gymName forKey:@"gymName"];
        NSLog(@"哈哈哈哈");
        [checkin setObject:[NSNumber numberWithInteger:sportType] forKey:@"sport"];
        [checkin setObject:[NSDate date] forKey:@"checkinTime"];
        [checkin setObject:[[AVUser currentUser] objectForKey:@"name"] forKey:@"name"];
        [checkin setObject:[[AVUser currentUser] objectForKey:@"sportTimeSlot"] forKey:@"sportTimeSlot"];
        
        [checkin setObject:[[AVUser currentUser] objectForKey:@"icon"] forKey:@"icon"];
        [checkin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error.code == -1009) {
                [ProgressHUD showError:@"Bad connection. Please check in later!"];
                NSLog(@"当前网络状况不佳");
                return;
            }
            NSLog(@"error is %@", error);
            [ProgressHUD showSuccess:@"Check in successfully"];
            [vc performSegueWithIdentifier:@"toSecondTagVC" sender:nil];
            [[AVUser currentUser]setObject:checkin forKey:@"CheckIn"];
            [[AVUser currentUser]saveInBackground];
        }];
    });

}
-(NSMutableArray*)refreshAndFetchAllCheckinsWithGymName:(NSString*)gymName {
    AVQuery *query1 = [AVQuery queryWithClassName:@"CheckIn"];
    [query1 whereKey:@"gymName" equalTo:gymName];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *checkin = (AVObject*)obj;
        return [[TimeManager getDateString:[checkin objectForKey:@"checkinTime"]] isEqualToString:[TimeManager getDateString:[NSDate date]]];
    }];
    self.allCheckIns = [[[[[query1 findObjects]filteredArrayUsingPredicate:predicate]mutableCopy]sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [obj1 objectForKey:@"checkinTime"];
        NSDate *date2 = [obj2 objectForKey:@"checkinTime"];
        return [date2 compare:date1];
    }]mutableCopy];
    return self.allCheckIns;
}
@end
