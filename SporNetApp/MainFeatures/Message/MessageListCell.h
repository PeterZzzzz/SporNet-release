//
//  MessageListCell.h
//  SporNetApp
//
//  Created by Peng Wang on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
#import <JSBadgeView.h>
@interface MessageListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bestSportImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (nonatomic, strong) JSBadgeView *badgeView;
-(void)configureCellWithConversation:(Conversation*)c;
@end
