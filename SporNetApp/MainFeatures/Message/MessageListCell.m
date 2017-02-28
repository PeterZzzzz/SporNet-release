//
//  MessageListCell.m
//  SporNetApp
//
//  Created by Peng Wang on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "MessageListCell.h"
#import "TimeManager.h"
#import <JSBadgeView.h>
#import "UIImageView+WebCache.h"

@implementation MessageListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self.userImageView alignment:JSBadgeViewAlignmentTopLeft];
    self.badgeView.badgePositionAdjustment = CGPointMake(12, 12);
    self.badgeView.badgeBackgroundColor = [UIColor redColor];
    self.badgeView.badgeOverlayColor = [UIColor clearColor];
    self.badgeView.badgeStrokeColor = [UIColor redColor];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 20;
}


-(void)configureCellWithConversation:(Conversation*)c {
    
    AVObject *myself;
//    NSLog(@"myself Id %@, another ID %@, %@", SELF_ID, c.myInfo, c.friendBasicInfo); 
    if ([c.myInfo isEqualToString:SELF_ID]) {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:c.friendBasicInfo];
    }else {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:c.myInfo];
    }
    
    
        [myself fetch];
    
        NSInteger colorIndex = [[myself objectForKey:@"sportTimeSlot"]integerValue];
        UIColor *color = SPORTSLOT_COLOR_ARRAY[colorIndex];
        [_userImageView.layer setBorderColor:color.CGColor];
        [[_userImageView layer] setBorderWidth:2.0f];
    
        NSArray *imageURLs = [myself objectForKey:@"PicUrls"];
        NSString *profileURL = [imageURLs firstObject];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:profileURL] placeholderImage:[UIImage imageNamed:@"profile"]];
        if(c.unreadMessageNumber > 0) {
            self.badgeView.badgeText = [NSString stringWithFormat:@"%ld", (long)c.unreadMessageNumber];
        
        }else {
            
            self.badgeView.badgeText = nil;
                    }
        [self.badgeView setNeedsLayout];
        self.userNameLabel.text = [myself objectForKey:@"name"];
        self.lastTimeLabel.text = [TimeManager getTimeStringFromNSDate:c.conversation.lastMessageAt];
        self.bestSportImage.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[myself objectForKey:@"bestSport"]integerValue]]];
        

    [c.conversation queryMessagesWithLimit:1 callback:^(NSArray *objects, NSError *error) {
        AVIMMessage *message = (AVIMMessage*)objects[0];
        self.lastMessageLabel.text = [objects[0]text];
        self.lastTimeLabel.text = [TimeManager getConvastionTimeStr: [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000]];
    }];
    
}
@end
