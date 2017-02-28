//
//  SNLaunchPageViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/1.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNLaunchPageViewController.h"
#import "SNLoginViewController.h"

#define SNLaunchingPageNumber 3
#define SNLaunchingPageDisappearKey @"isScrollViewAppear"

@interface SNLaunchPageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *launchPages;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton      *startBtn;

@end

@implementation SNLaunchPageViewController


- (BOOL)prefersStatusBarHidden {
    return YES;
    
}


- (UIButton *)startBtn {
    
    if (_startBtn == nil) {
        
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(self.view.center.x - 55, self.view.frame.size.height - 114, 110, 44);
        [_startBtn setBackgroundColor:[UIColor colorWithRed:55 / 255.0 green:170 / 255.0 blue:157 / 255.0 alpha:1.0]];
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"Start" attributes:@{
                                                                                                     NSFontAttributeName : [UIFont fontWithName:@"Avenir Next" size:20],
                                                                
                                                                                                     NSForegroundColorAttributeName :[UIColor whiteColor]
                                                                                                     
                                                                                                }];
        
        [_startBtn setAttributedTitle:string forState:UIControlStateNormal];
        
        [_startBtn addTarget:self action:@selector(startLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _startBtn;
}

- (UIPageControl *)pageControl {
    
    if (_pageControl == nil) {
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.center.x - 25, self.view.frame.size.height - 60, 50, 40)];
        _pageControl.numberOfPages = SNLaunchingPageNumber;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:55 / 255.0 green:170 / 255.0 blue:157 / 255.0 alpha:1.0];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.tag = 102;
    }
    
    return _pageControl;
}

- (UIScrollView *)launchPages {
    
    if (_launchPages == nil) {
        
        _launchPages = [[UIScrollView alloc]init];
        _launchPages.frame = [UIScreen mainScreen].bounds;
        _launchPages.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * SNLaunchingPageNumber, [UIScreen mainScreen].bounds.size.height);
        _launchPages.bounces = NO;
        _launchPages.pagingEnabled = YES;
        _launchPages.showsVerticalScrollIndicator = NO;
        _launchPages.showsHorizontalScrollIndicator = NO;
        _launchPages.delegate = self;
        _launchPages.tag = 101;
        
        for (int i = 0; i < SNLaunchingPageNumber; i ++) {
            
            UIImageView *pageImage = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width *i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            pageImage.contentMode = UIViewContentModeScaleAspectFit; 
            UIImage *image;
            if (i == 0) {
                
                image = [UIImage imageNamed:@"SEARCH"];
                
            }else if (i == 1) {
                
                image = [UIImage imageNamed:@"TAG"];
                
            }else if (i == 2) {
                
                image = [UIImage imageNamed:@"RANKING"];
                
            }
            pageImage.image = image;
            
            [_launchPages addSubview:pageImage];
        }
        
    }
    
    return _launchPages;
}

- (void)viewDidLoad {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![@"YES" isEqualToString:[userDefaults objectForKey:SNLaunchingPageDisappearKey]]) {
        
        [self.view addSubview:self.launchPages];
        [self.view addSubview:self.pageControl];
    }else {
                SNLoginViewController *loginController = [[SNLoginViewController alloc]init];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = loginController;
    }
    
    
}

#pragma mark - ScrollView Delegate 

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:102];
    page.currentPage = current;
    
    if (page.currentPage == 2) {
        
        [self.view addSubview:self.startBtn];
    }
}

-(void)scrollViewDisappear{
    
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:102];
    
    [UIView animateWithDuration:3.0f animations:^{
        
        scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [scrollView removeFromSuperview];
        [page removeFromSuperview];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = [story instantiateInitialViewController];
        
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:SNLaunchingPageDisappearKey];
    
}

- (void)startLogin {
    

        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = [story instantiateInitialViewController];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"YES" forKey:SNLaunchingPageDisappearKey];

    

    
}
@end


















