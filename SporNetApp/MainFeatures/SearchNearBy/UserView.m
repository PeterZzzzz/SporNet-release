//
//  UserView.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/11/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "UserView.h"
#import <AVObject.h>
@implementation UserView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [[NSBundle mainBundle]loadNibNamed:@"UserView" owner:self options:nil];
        //[self.view setFrame:self.frame];
        //[self.profileImageButton setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 50, 50)];
        self.profileImageButton.layer.masksToBounds = YES;
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.width / 2.0;
//        self.boxView.layer.masksToBounds = YES;
//        self.boxView.layer.cornerRadius = self.boxView.frame.size.width / 2.0;
        [self addSubview:self.view];
//        NSLog(@"%.f", self.view.frame.size.width);
//        NSLog(@"%.f", self.view.frame.origin.x);
//         NSLog(@"%.f", self.view.frame.origin.y);
    }
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil];
        self.profileImageButton.layer.masksToBounds = YES;
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.width / 2.0;
//        self.boxView.layer.masksToBounds = YES;
//        self.boxView.layer.cornerRadius = self.boxView.frame.size.width / 2.0;
        [self addSubview:self.view];
        
    }
    return self;
}

-(void)configureUserViewWithUserInfo:(AVObject*)userInfo {
    [self.profileImageButton setBackgroundImage:[UIImage imageWithData:[(AVFile*)[userInfo objectForKey:@"icon"]getData]] forState:normal];
//    self.boxView.backgroundColor = SPORTSLOT_COLOR_ARRAY[[[userInfo objectForKey:@"sportTimeSlot"]integerValue]];
//    self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[userInfo objectForKey:@"bestSport"]integerValue]]];
}
@end
