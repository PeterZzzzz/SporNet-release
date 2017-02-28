//
//  SNFpDreViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/12.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNFpDreViewController.h"
#import "AVUser.h"
#import "ProgressHUD.h"
@interface SNFpDreViewController ()<UITextFieldDelegate>
//textfield for email
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;
@end

@implementation SNFpDreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _emailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"input your school email" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//method for back button
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//method for resend button
- (IBAction)resend:(id)sender {
    
    if ([self.emailTextfield.text isEqualToString:@""]) {
        
        [ProgressHUD showError:@"Please input your email"];
        
        return;
    }
    
    if (_isFp) {
//#warning 这里要重新检测
        [AVUser requestPasswordResetForEmailInBackground:_emailTextfield.text block:^(BOOL succeeded, NSError *error) {
            
            if(error.code == 205) {
                
                [ProgressHUD showError:@"Email not found"];
            }
            else {
             [ProgressHUD showSuccess:@"Please check your email to reset password"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        
         [ProgressHUD showSuccess:@"Please check your email again"];
        
        [AVUser requestEmailVerify:self.emailTextfield.text withBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (error) {
                
                
            }
            
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.viewBottom.constant = 100;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.viewBottom.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
