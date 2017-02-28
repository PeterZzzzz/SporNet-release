//
//  SNContactCell.h
//  SporNetApp
//
//  Created by Peng Wang on 8/26/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
@interface SNContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameField;
@property (weak, nonatomic) IBOutlet UIImageView *bestSportImageView;
-(void)configureCellWithConversation:(Conversation*)c;
@end
