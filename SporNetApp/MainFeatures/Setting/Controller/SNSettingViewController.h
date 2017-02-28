//
//  SNSettingViewController.h
//  SporNetApp
//
//  Created by Peng Wang on 7/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVObject.h"
@interface SNSettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(strong) AVObject *basicInfo;
@end
