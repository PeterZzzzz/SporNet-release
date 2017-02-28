//
//  SNPolicyPageViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 17/2/14.
//  Copyright © 2017年 Peng Wang. All rights reserved.
//

#import "SNPolicyPageViewController.h"

@interface SNPolicyPageViewController ()

@end

@implementation SNPolicyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
