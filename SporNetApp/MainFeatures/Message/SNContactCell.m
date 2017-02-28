//
//  SNContactCell.m
//  SporNetApp
//
//  Created by Peng Wang on 8/26/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNContactCell.h"

@implementation SNContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.userImageView.layer.masksToBounds = YES;
//    self.userImageView.layer.cornerRadius = 30;
}
-(void)configureCellWithConversation:(Conversation *)c {
    
    AVObject *myself;
    if ([c.myInfo isEqualToString:SELF_ID]) {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:c.friendBasicInfo];
    }else {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:c.myInfo];
    }
    [myself fetch];
    
        UIColor *color = SPORTSLOT_COLOR_ARRAY[[[myself objectForKey:@"sportTimeSlot"]integerValue]];
        [self.userImageView.layer setBorderColor:color.CGColor];
        [self.userImageView.layer setBorderWidth:2.0f];

        self.userImageView.image = [UIImage imageWithData:[[myself objectForKey:@"icon"]getData]];
        self.userNameField.text = [myself objectForKey:@"name"];
        self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[myself objectForKey:@"bestSport"]integerValue]]];
    
}
@end
