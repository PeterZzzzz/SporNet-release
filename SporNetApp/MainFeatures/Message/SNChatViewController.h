//
//  SNChatViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@interface SNChatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AVIMClientDelegate>
@property(strong) Conversation *conversation;
@end
