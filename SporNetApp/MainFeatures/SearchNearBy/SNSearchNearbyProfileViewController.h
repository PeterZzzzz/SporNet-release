//
//  SNSearchNearbyProfileViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/3/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNUser.h"
#import "Conversation.h"


@protocol SNSearchNearbyProfileVCDelegate <NSObject>
- (void)didClickCrossButton;
@end
@interface SNSearchNearbyProfileViewController : UIViewController<UIScrollViewAccessibilityDelegate>
@property (nonatomic, strong) SNUser *currentUserProfile;
@property (nonatomic, strong) Conversation *currentUserCon; 
@property (nonatomic, assign) BOOL isSearchNearBy;
@property (nonatomic, assign) BOOL isFromNotication; 
@property (nonatomic, assign) id<SNSearchNearbyProfileVCDelegate> delegate;
@end
