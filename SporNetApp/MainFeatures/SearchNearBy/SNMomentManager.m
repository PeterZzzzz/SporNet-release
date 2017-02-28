//
//  SNMomentManager.m
//  SporNetApp
//
//  Created by ZhengYang on 17/1/5.
//  Copyright © 2017年 Peng Wang. All rights reserved.
//

#import "SNMomentManager.h"
#import "FriendsMomentModel.h"
#import "ProgressHUD.h"
#import "TimeManager.h"

@interface SNMomentManager()

@property (nonatomic, strong) NSMutableArray *momentsUserM;
@property (nonatomic, strong) NSMutableArray *myMomentsOnly;

@end

static SNMomentManager *manger = nil;

@implementation SNMomentManager

- (NSMutableArray *)momentsUserM {
    
    if (_momentsUserM == nil) {
        
        _momentsUserM = [NSMutableArray array];
        
    }
    
    return _momentsUserM;
}

- (NSMutableArray *)myMomentsOnly {
    
    if (_myMomentsOnly == nil) {
        
        _myMomentsOnly = [NSMutableArray array];
    }
    
    return _myMomentsOnly;
}

+(instancetype)defaultManager{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [[self alloc]init];
    });
    return manger;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manger = [super allocWithZone:zone];
    });
    return manger;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(NSMutableArray*)fetchAllUserMoments{
    
    AVQuery *query = [AVQuery queryWithClassName:@"MomentsShare"];

    self.momentsUserM = [[[query findObjects]sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [obj1 objectForKey:@"createdAt"];
        NSDate *date2 = [obj2 objectForKey:@"createdAt"];
        return [date2 compare:date1];
    }]mutableCopy];
    return self.momentsUserM;

}

-(NSMutableArray *)fetchOnlyUserMoments {
    
    AVQuery *query = [AVQuery queryWithClassName:@"MomentsShare"];
    
    [query whereKey:@"UserID" equalTo:SELF_ID];
    
    self.myMomentsOnly = [[[query findObjects]sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [obj1 objectForKey:@"createdAt"];
        NSDate *date2 = [obj2 objectForKey:@"createdAt"];
        return [date2 compare:date1];
    }]mutableCopy];
    
    return self.myMomentsOnly; 
    
}

-(void)publishUserMomentsWithUser:(AVObject *)user Text:(NSString *)post {
    
    [user setObject:SELF_ID forKey:@"UserID"];
    [user setObject:post forKey:@"MomentStatus"];

    [user saveEventually:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (succeeded) {
            
            [ProgressHUD dismiss]; 
            
            if ([self.delegate respondsToSelector:@selector(publishSuccessfully)]) {
                
                [self.delegate publishSuccessfully];
            }
            
        }else {
            
            
            if ([self.delegate respondsToSelector:@selector(publishFailure)]) {
                
                [self.delegate publishFailure];
            }
        }
    }];
}

@end
