//
//  UserView.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/11/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNUser.h"
@interface UserView : UIView
@property (weak, nonatomic) IBOutlet UIView *view;
//@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
-(void)configureUserViewWithUserInfo:(SNUser*)userInfo;
@end
