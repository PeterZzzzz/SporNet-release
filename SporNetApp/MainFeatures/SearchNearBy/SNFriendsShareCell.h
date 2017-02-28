//
//  SNFriendsShareCell.h
//  SporNetApp
//
//  Created by Peng on 1/2/17.
//  Copyright © 2017 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsMomentModel.h"
#import "SNMomentManager.h"

@interface SNFriendsShareCell : UITableViewCell

@property (nonatomic, strong)FriendsMomentModel *momentModel;
@property (nonatomic,weak)id<SNMomentManagerDelegate> Delegate;
@end
