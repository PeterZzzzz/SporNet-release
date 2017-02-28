//
//  SNMomentManager.h
//  SporNetApp
//
//  Created by ZhengYang on 17/1/5.
//  Copyright © 2017年 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SNMomentManagerDelegate <NSObject>

@optional

- (void)publishSuccessfully;
- (void)publishFailure;
- (void)enterAlertView;


@end

@interface SNMomentManager : NSObject

@property (nonatomic, assign) id<SNMomentManagerDelegate>delegate;

+(instancetype)defaultManager;

-(NSMutableArray *)fetchAllUserMoments;

-(NSMutableArray *)fetchOnlyUserMoments; 

- (void)publishUserMomentsWithUser:(AVObject *)user Text:(NSString *)post;

@end
