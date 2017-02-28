
//  SNLoginViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/11.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNLoginViewController.h"
#import "SNRegisterViewController.h"
#import "SNFpDreViewController.h"
#import "ProgressHUD.h"
#import "AVUser.h"
#import "AVFile.h"
#import "SNMainFeatureTabController.h"
#import "LocalDataManager.h"
#import "SNUser.h"
#import "MessageManager.h"

@interface SNLoginViewController ()<UITextFieldDelegate>
/**
 *  User Email Input
 */
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextfield;
/**
 *  User Password Input
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
/**
 *  Autolayout Constraint
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstrainatBottom;
/**
 *  App Logo Icon ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *logoIcon;



@end

@implementation SNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set NavigationBar Hidden
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //Set Up UI
    [self setUpAllUI];
    
    //Set Up Notification Center
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //Set Up Logo Icon
//#warning 这几行代码测试后没有反应
    self.logoIcon.layer.cornerRadius = self.logoIcon.frame.size.width/2;
    
    self.logoIcon.layer.masksToBounds = YES;
    
    //Check Sandbox to see if already have Email and Password Saved
    
    NSString *userEmail = [[NSUserDefaults standardUserDefaults]objectForKey:KUSER_EMAIL];
    NSString *userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:KUSER_PASSWORD];
    if (userEmail != nil && userPassword != nil) {
        
        [ProgressHUD show:@"Loading" Interaction:NO];
        
        [AVUser logInWithUsernameInBackground:userEmail password:userPassword block:^(AVUser *user, NSError *error) {
            
            if (error == nil) {
                
                [[MessageManager defaultManager] startMessageService];
                
                SNMainFeatureTabController *tabVC = [[SNMainFeatureTabController alloc]init];
                
                [self presentViewController:tabVC animated:NO completion:nil];
                
                [ProgressHUD dismiss];
            }else {
                
//                NSLog(@"%@",error.description);
            }
        }];
    }

}

#pragma marks - Init UI

- (void)setUpAllUI {
    
    _userEmailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"school email" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//method for login button
- (IBAction)login:(id)sender {

    if([_userEmailTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"Please input username!"];
    } else if([_passwordTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"Please input password!"];
    } else {
        
        //#warning 从网上去判断是否verified
        AVUser *currentUser = [AVUser currentUser];
        if (currentUser == nil) {
            
            AVQuery *query = [AVQuery queryWithClassName:@"_User"];
            
            [query whereKey:@"username" equalTo:_userEmailTextfield.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                if (objects.count == 0) {
                    
                    [ProgressHUD show:@"You need to register"];
                }else {
                    
                    AVUser *user = objects[0];
                    
                    bool isVerified = [[user objectForKey:@"emailVerified"] boolValue];
                    
                    if (isVerified) {
                        
                        [ProgressHUD show:@"Logging now..."];
                        [AVUser logInWithUsernameInBackground:_userEmailTextfield.text password:_passwordTextfield.text block:^(AVUser *user, NSError *error) {
                            if(error.code == 211) {
                                [ProgressHUD showError:@"Email doesn't exist!"];
                            } else if (error.code == 210) {
                                [ProgressHUD showError:@"Wrong password!"];
                            } else{
                                
                                AVQuery *query = [SNUser query];
                                [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
                                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    
                                    if (objects.count == 0) {
                                        
                                        [self performSegueWithIdentifier:@"firstTimeLoginSegue" sender:nil];
                                        //Save to SandBox
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:self.userEmailTextfield.text forKey:KUSER_EMAIL];
                                        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextfield.text forKey:KUSER_PASSWORD];
                                        
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        
                                    }else {
                                        [LocalDataManager fetchProfileInfoFromCloud];
                                        SNMainFeatureTabController *tabVC = [[SNMainFeatureTabController alloc]init];
                                        [[MessageManager defaultManager] startMessageService];
                                        
                                        [self presentViewController:tabVC animated:YES completion:nil];
                                    }
                                    
                                }];
                                
                                [ProgressHUD showSuccess:@"Welcome"];
                                
                                
                            }
                        }];
                        
                    }else {
                        
                        [ProgressHUD showError:@"Please go to school email to confirm"];
                    }
                    
                    
                }
                
            }];
        } else {
            
            AVQuery *query = [AVQuery queryWithClassName:@"_User"];
            
            [query whereKey:@"username" equalTo:_userEmailTextfield.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                if (objects.count == 0) {
                    
                    [ProgressHUD show:@"You need to register"];
                }else {
                    
                    AVUser *user = objects[0];
                    
                    bool isVerified = [[user objectForKey:@"emailVerified"] boolValue];
                    
                    if (isVerified) {
                        
                        [ProgressHUD show:@"Logging now..."];
                        [AVUser logInWithUsernameInBackground:_userEmailTextfield.text password:_passwordTextfield.text block:^(AVUser *user, NSError *error) {
                            if(error.code == 211) {
                                [ProgressHUD showError:@"Email doesn't exist!"];
                            } else if (error.code == 210) {
                                [ProgressHUD showError:@"Wrong password!"];
                            } else{
                                
                                AVQuery *query = [SNUser query];
                                [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
                                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                    
                                    if (objects.count == 0) {
                                        
                                        [self performSegueWithIdentifier:@"firstTimeLoginSegue" sender:nil];
                                        //Save to SandBox
                                        
                                        [[NSUserDefaults standardUserDefaults] setObject:self.userEmailTextfield.text forKey:KUSER_EMAIL];
                                        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextfield.text forKey:KUSER_PASSWORD];
                                        
                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                        
                                        
                                    }else {
                                        [LocalDataManager fetchProfileInfoFromCloud];
                                        SNMainFeatureTabController *tabVC = [[SNMainFeatureTabController alloc]init];
                                        [[MessageManager defaultManager] startMessageService];
                                        
                                        [self presentViewController:tabVC animated:YES completion:nil];
                                    }
                                    
                                }];
                                
                                [ProgressHUD showSuccess:@"Welcome"];
                                
                                
                            }
                        }];
                        
                    }else {
                        
                        [ProgressHUD showError:@"Please go to school email to confirm"];
                    }
                    
                    
                }
                
            }];
        }
        
    }
    
    

}



//method for forget password button
- (IBAction)forgetPassword {
    [self performSegueWithIdentifier:@"fpSegue" sender:nil];
}

//method for dont receive email
- (IBAction)dontRE {
    [self performSegueWithIdentifier:@"dreSegue" sender:nil];
}

//pass the segue condition in next view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SNFpDreViewController *destination = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"fpSegue"]) {
        destination.isFp = YES;
    } else if([segue.identifier isEqualToString:@"dreSegue"]){
        destination.isFp = NO;
    }
    
}

//method for signup button
- (IBAction)signup:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
    SNRegisterViewController *regVc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterPage"];
    
    [self.navigationController pushViewController:regVc animated:YES];

    
}

#pragma marks -KeyBoard Show&Hidden

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.inputViewConstrainatBottom.constant = 280;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.inputViewConstrainatBottom.constant = 200;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
