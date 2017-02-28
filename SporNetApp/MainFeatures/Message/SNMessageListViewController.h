//
//  SNMessageListViewController.h
//  SporNetApp
//
//  Created by Peng Wang on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVIMClient.h>
#import "MessageManager.h"
@interface SNMessageListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MessageManagerDelegate>

@end
