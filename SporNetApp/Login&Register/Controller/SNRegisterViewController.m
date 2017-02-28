//
//  SNRegisterViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/5.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNRegisterViewController.h"
#import "ProgressHUD.h"
#import "AVUser.h"


@interface SNRegisterViewController ()<UITextFieldDelegate>
/**
 *  New User Email Textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
/**
 *  New User Password Textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
/**
 *  New User Password Confirm Textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmPwTextfield;
/**
 *  Autolayout Constraint
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;

@property (nonatomic) BOOL isBoxChecked;

@end

@implementation SNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Up Navigation
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //Set Up UIAlert
    
//#warning 最后把所有其它学校加上去
    [self sendAlert:@"This app is targeting great Boston Area University..."];
    
    //Set Up UI
    [self setupUI];
    
    //Set Up Keyboard
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
}

#pragma marks - Private Methods

- (void)setupUI {
    
    _emailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"school email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _confirmPwTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"confirm password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//method for tip button
- (IBAction)tipClick {
    
    [self sendAlert:@"Please Use Your School Email"];

}

- (IBAction)checkBoxClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.isBoxChecked = YES;
    } else {
        self.isBoxChecked = NO;
    }
    
}


//method for submit
- (IBAction)submitClick {
    if (self.isBoxChecked) {
        if([_emailTextfield.text isEqual:@""]) {
            [ProgressHUD showError:@"Please enter your email address!"];
            return;
        }
        if(![self validSchoolEmail:_emailTextfield.text]) {
            [ProgressHUD showError:@"Your School is not on our list! Coming Soon!"];
            return;
        }
        if([_passwordTextfield.text isEqual:@""]) {
            [ProgressHUD showError:@"You must input a password!"];
            return;
        }
        if(![_confirmPwTextfield.text isEqual:_passwordTextfield.text]) {
            [ProgressHUD showError:@"Two passwords mismatch."];
            return;
        }
        
        AVUser *user = [AVUser user];
        user.username = _emailTextfield.text;
        user.email = _emailTextfield.text;
        user.password = _passwordTextfield.text;
        [ProgressHUD show:@"Signing Up Now..."];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error.code == 202) {
                [ProgressHUD showError:@"Username has already been taken!"];
                return;
            }
            if(error.code == 203) {
                [ProgressHUD showError:@"Email address has already been taken!"];
                return;
            }
            
            [ProgressHUD showSuccess:[NSString stringWithFormat:@"Signed up successfully! Please go to your school email to confirm"]];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    } else {
        [self sendAlert:@"Please Agree Above Policy"];

    }
    

}

-(BOOL)validSchoolEmail:(NSString*)email {
    
    
    NSString *emailPlist = [[NSBundle mainBundle] pathForResource:@"emailToSchool" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:emailPlist];
    
    NSArray *emailList = [dic allKeys];
    
        for (NSString *schoolEmail in emailList) {
            
            NSString *realEmail = [NSString stringWithString:schoolEmail];
            
            if ([email containsString:realEmail]) {
                
                NSString *schoolName = [dic[realEmail] firstObject];
//                NSLog(@"school name %@", schoolName); 
                
                [[NSUserDefaults standardUserDefaults]setObject:schoolName forKey:KUSER_SCHOOL_NAME];
                
                return YES;
            }
    }
    
    return NO;
}
-(void)sendAlert:(NSString*)message {
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma marks - Keyboard Show & Hide

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.viewBottom.constant = 200;
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
