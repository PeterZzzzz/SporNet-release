//
//  SNTagCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/28/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNTagCell.h"
#import <AVUser.h>
#import <AVFile.h>
#import <AVQuery.h>
#import "TimeManager.h"
@implementation SNTagCell
NSArray *todaySportImageArray;
- (void)awakeFromNib {
    _boxView.layer.masksToBounds = YES;
    _boxView.layer.cornerRadius = _boxView.frame.size.width / 2.0;
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2.0;
    todaySportImageArray = @[@"", @"joggingSelected", @"muscleSelected", @"soccerSelected", @"basketballSelected", @"yogaSelected"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configureCellWithCheckinInfo:(AVObject *)checkinObject {
//    NSString *userID = [checkinObject objectForKey:@"userID"];
//    AVQuery *q = [AVQuery queryWithClassName:@"SNUser"];
//    [q whereKey:@"userID" equalTo:userID];
//    AVObject *basicUser = [q findObjects][0];
    if([checkinObject objectForKey:@"icon"]) self.userImageView.image =  [UIImage imageWithData:[(AVFile*)[checkinObject objectForKey:@"icon"]getData]];
    
    self.boxView.backgroundColor = SPORTSLOT_COLOR_ARRAY[[[checkinObject objectForKey:@"sportTimeSlot"]integerValue]];
    
    self.userNameLabel.text = [checkinObject objectForKey:@"name"];
    self.userCheckinTimeLabel.text = [TimeManager getTimeLabelString:[checkinObject objectForKey:@"checkinTime"] refreshTime:[NSDate date]];
    self.userSelectedSportLabel.image = [UIImage imageNamed:todaySportImageArray[[[checkinObject objectForKey:@"sport"]integerValue]]];

}
@end
