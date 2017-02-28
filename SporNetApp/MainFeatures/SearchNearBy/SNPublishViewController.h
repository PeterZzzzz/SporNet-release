//
//  SNPublishViewController.h
//  SporNetApp
//
//  Created by ZhengYang on 17/1/4.
//  Copyright © 2017年 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNPublishViewControllerDelegate <NSObject>

@optional

- (void)publishSuccessful;

@end

@interface SNPublishViewController : UIViewController

@property (nonatomic, assign) id<SNPublishViewControllerDelegate> delegate;

@end
