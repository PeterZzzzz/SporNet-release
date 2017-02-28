//
//  SNFriendRequestCell.h
//  SporNetApp
//
//  Created by Peng Wang on 8/25/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
@interface SNFriendRequestCell : UITableViewCell
@property Conversation *conversation;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bestSportImageView;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
-(void)configureCellWithConversation:(Conversation*)conversation;
@end
