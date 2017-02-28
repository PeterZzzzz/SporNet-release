//
//  SNFriendRequestCell.m
//  SporNetApp
//
//  Created by Peng Wang on 8/25/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNFriendRequestCell.h"
#import "SNUser.h"
#import "MessageManager.h"
#import "UIImageView+WebCache.h"
@implementation SNFriendRequestCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = 20;
}

- (IBAction)acceptButtonClicked:(UIButton *)sender {
    [[MessageManager defaultManager] acceptFriendRequest:self.conversation];

}
- (IBAction)removeButtonClicked:(UIButton *)sender {
    
    [[MessageManager defaultManager] rejectFriendRequest:self.conversation];
}
-(void)configureCellWithConversation:(Conversation*)conversation {
    self.conversation = conversation;
    
//    NSLog(@"conversation user %@", conversation.myInfo); 
    
    AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:conversation.myInfo];
    
    [user fetch];
                
    self.nameLabel.text = [user objectForKey:@"name"];
    self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[user objectForKey:@"bestSport"]integerValue]]];
    [[_userImageView layer] setBorderWidth:2.0f];
    NSInteger colorIndex =[[user objectForKey:@"sportTimeSlot"]integerValue];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[colorIndex];
    [_userImageView.layer setBorderColor:color.CGColor];
                
    self.schoolLabel.text = [user objectForKey:@"school"];
    NSArray *imageURLs = [user objectForKey:@"PicUrls"];
    NSString *profileURL = [imageURLs firstObject];
//    UIImage *image = [UIImage imageWithData:[[user objectForKey:@"icon"]getData]];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:profileURL] placeholderImage:[UIImage imageNamed:@"profile"]];
          
    
}

@end
