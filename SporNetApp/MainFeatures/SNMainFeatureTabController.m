//
//  SNMainFeatureTabController.m
//  SporNetApp
//
//  Created by Peng on 6/27/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNMainFeatureTabController.h"
#import "SNSettingViewController.h"
#import "SNTagSecondViewController.h"
#import "SNTagMainViewController.h"

@interface SNMainFeatureTabController () <UITabBarControllerDelegate>

@end

@implementation SNMainFeatureTabController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupTabbarItem];
        self.delegate = self;

        }
 
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbar];
    
    
    [self setupChildControllers];

}

#pragma mark - Private Methods

- (void)setupTabbarItem {
    
    NSArray *titleArray = @[@"Message",@"Tag",@"Search",@"Ranking",@"Settings"];
    
    for (int i = 0; i < [self.tabBar.items count]; i++){
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        item.title = titleArray[i];
        item.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabItem%d", i]];
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabItem%dSelected", i]];
    }
}

- (void)setupChildControllers {
    UIStoryboard *tag = [UIStoryboard storyboardWithName:@"TagStoryboard" bundle:nil];
    UIStoryboard *message = [UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil];
    UIStoryboard *ranking = [UIStoryboard storyboardWithName:@"RankingStoryboard" bundle:nil];
    UIStoryboard *search = [UIStoryboard storyboardWithName:@"SearchingStoryboard" bundle:nil];
    UIStoryboard *setting = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
    
    
    UIViewController *tagController = [tag instantiateInitialViewController];
    tagController.tabBarItem.tag = 1;
   
    
    UIViewController *messageController = [message instantiateInitialViewController];
    
    UIViewController *rankingController = [ranking instantiateInitialViewController];
    
    UIViewController *searchController = [search instantiateInitialViewController];
    
    
    SNSettingViewController *settingController = [setting instantiateInitialViewController];
    
    self.viewControllers = @[messageController, tagController, searchController, rankingController, settingController];
    
}

- (void)setupTabbar {
 
    UIColor * tabColor = [UIColor colorWithRed:246/255.0
                                         green:246/255.0
                                          blue:246/255.0
                                         alpha:0.5];
    [self.tabBar setTranslucent:YES];
    [self.tabBar setBarTintColor:tabColor];
    self.tabBar.backgroundColor = [UIColor clearColor];
    
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, 1);
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12 weight:UIFontWeightLight]} forState:UIControlStateNormal];
    self.tabBar.tintColor = [UIColor colorWithRed:53/255.0 green:183/255.0 blue:162/255.0 alpha:1.0];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:43/255.0
                                                       green:57/255.0
                                                        blue:74/255.0
                                                       alpha:1.0]}
                                           forState: UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName: [UIColor colorWithRed:53/255.0 green:183/255.0 blue:162/255.0 alpha:1.0]}
                                           forState: UIControlStateSelected];
}




//// 遍历tabBar上的子控件,给"UITabBarButton"类型的按钮绑定动画效果事件
////(注意:遍历添加动画事件的时机是在layoutSubviews布局子控件方法中)
//- (void)layoutSubviews{
//
//    [super layoutSubviews];
//
//    for (UIControl *tabBarButton in self) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }
//}


//// 动画效果(遍历UITabBarButton按钮的子控件,
////如果需要对图片添加动画,寻找"UITabBarSwappableImageView"类型的图片子控件;
////如果需要对按钮下面的文字添加动画,寻找"UITabBarButtonLabel"类型的文字子控件即可).
//- (void)tabBarButtonClick:(UIControl *)tabBarButton
//{
//    for (UIView *imageView in tabBarButton.subviews) {
//        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
//            // 需要实现的帧动画,这里根据需求自定义
//            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//            animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
//            animation.duration = 1;
//            animation.calculationMode = kCAAnimationCubic;
//            // 把动画添加到对应控件的layer上去就OK了
//            [imageView.layer addAnimation:animation forKey:nil];
//        }
//    }
//}

@end









