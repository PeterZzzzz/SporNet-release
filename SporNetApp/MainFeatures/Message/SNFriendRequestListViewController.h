//
//  SNFriendRequestListViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/25/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageManager.h"
@interface SNFriendRequestListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MessageManagerDelegate, AVIMClientDelegate>

@end
