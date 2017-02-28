//
//  SNSettingViewController.m
//  SporNetApp
//
//  Created by Peng Wang on 7/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNSettingViewController.h"
#import "SNPreferenceViewController.h"
#import "SNUserProfileViewController.h"
#import "AVUser.h"
#import "AVFile.h"
#import "ProgressHUD.h"
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSInteger, SettingRow) {
    
    SettingRowSearchPreference= 0,
    SettingRowChangePassword,
    SettingRowContactUs,
    SettingRowRateUs,
    SettingRowNumber
};

@interface SNSettingViewController ()<MFMailComposeViewControllerDelegate, SNUserProfileViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *sportColorView;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userBlurImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bestSportImageView;

//Text array for setting view.
@property(nonatomic) NSArray *settingTextArray;
@end

@implementation SNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set user photo to round shape
    self.sportColorView.clipsToBounds = YES;
    [self.sportColorView.layer setCornerRadius:55];
    self.userImageView.clipsToBounds = YES;
    [self.userImageView.layer setCornerRadius:50];
    //load profile image
    [self loadProfileView];
    //add tap gesture to user photo. When tapped, go to user profile page.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(userImageTapped)];
    [self.userImageView addGestureRecognizer:tap];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}


#pragma mark- table view delegate & datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return SettingRowNumber;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"simpleTableIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.settingTextArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case SettingRowSearchPreference:{
            
            [self performSegueWithIdentifier:@"toPreferenceSegue" sender:nil];
            
        }
            break;
        case SettingRowChangePassword:{
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Please Reset Your Password" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Old Password";
                textField.secureTextEntry = YES;
            }];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Password";
                textField.secureTextEntry = YES;
            }];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Confirm Password";
                textField.secureTextEntry = YES;
            }];
            //按钮按下时，让程序读取文本框中的值
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField * oldPassword = alertController.textFields.firstObject;
                UITextField * firstPassword = alertController.textFields[1];
                UITextField * confirmPassword = alertController.textFields.lastObject;
                if (firstPassword.text == confirmPassword.text) {
                    [[AVUser currentUser]updatePassword:oldPassword.text newPassword:firstPassword.text block:^(id object, NSError *error) {
                        
                        if (error) {
                            
                            [ProgressHUD showError:@"Your Password Doesn't Match Our Record"];
                        }else {
                            [ProgressHUD showSuccess:@"Update Successful"];
                        }
                    }];
                    
                }else {
                    
                    [ProgressHUD showError:@"Your Passwords Doesn't Match"];
                }
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        case SettingRowContactUs:
            if ([MFMailComposeViewController canSendMail]) {
                [self sendEmailAction]; // 调用发送邮件的代码
            }
            
            break;
        case SettingRowRateUs:
//            NSLog(@"%@", @"Rate us");
            break;
        default:
            break;
    }
}

#pragma mark - Private Methods
- (void)sendEmailAction {
    
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"New Message"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"info@spornetapp.com"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"Email"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"Email"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"I'm a user from SporNet";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    
    [self presentViewController:mailCompose animated:YES completion:nil];
    
}

// blur the top background image
-(void)setBlurTopImage:(UIImage*)image {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    // create gaussian blur filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputRadius"];
    // blur image
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    self.userBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGImageRef cgImage = [context createCGImage:result fromRect:CGRectMake(75, 375, SCREEN_WIDTH+150, self.userBlurImageView.frame.size.height + 80)];
    UIImage *blurImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    self.userBlurImageView.image = blurImage;
    self.userBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
}

//load setting profile
-(void)loadProfileView {
    
    // 1. 从本地获取照片
    NSString *plistPath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        // Set User Picture
        NSDictionary *userBasicInfo = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
        NSArray *imageDataArr = [userBasicInfo objectForKey:@"photoes"];
        NSData *profilePic = [imageDataArr firstObject];
        self.userImageView.image = [UIImage imageWithData:profilePic];
        // Set User Sport Time Color
        NSInteger userSportColor = [[userBasicInfo objectForKey:@"sportTimeSlot"]integerValue];
        self.sportColorView.backgroundColor = SPORTSLOT_COLOR_ARRAY[userSportColor];
        // Set User Sport
        NSInteger userSport = [[userBasicInfo objectForKey:@"bestSport"]integerValue];
        self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[userSport]];
        
    }else {
        //2. 本地没有照片，从网上获取
        
        if([[AVUser currentUser]objectForKey:@"icon"])
        {
            self.userImageView.image = [UIImage imageWithData:[[[AVUser currentUser]objectForKey:@"icon"]getData]];
            self.sportColorView.backgroundColor = SPORTSLOT_COLOR_ARRAY[[[[AVUser currentUser]objectForKey:@"sportTimeSlot"]integerValue]];
            self.bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[[AVUser currentUser]objectForKey:@"bestSport"]integerValue]]];
        }
    }
    [self setBlurTopImage:self.userImageView.image];
    
    
}
//setter for text array
-(NSArray*)settingTextArray {
    if(_settingTextArray == nil) {
        _settingTextArray = @[@"Search Preference",@"Change Password", @"Contact Us", @"Rate Us"];
    }
    return _settingTextArray;
}
//go to user profile page when image tapped
-(void)userImageTapped {
    SNUserProfileViewController *profileVC = [[SNUserProfileViewController alloc] init];
    profileVC.delegate = self;
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:KUSER_EDIT_PROFILE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController pushViewController:profileVC animated:YES];
}

- (IBAction)logOutAction:(id)sender {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KUSER_EMAIL];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KUSER_PASSWORD];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KUSER_EDIT_PROFILE];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KUSER_FIRST_REGISTER];
    [self cleanSandbox];
    UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
    UIViewController *loginVC = [login instantiateInitialViewController];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)cleanSandbox {
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"basicInfo.plist"];
    
    [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    
}

#pragma mark - SNUserProfileViewControllerDelegate

- (void)EditDoneDidClicked {
    
    [self loadProfileView];
}

#pragma mark - MFMailControlDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
//            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
//            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
//            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
//            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Terms of Service and Privacy Policy

- (IBAction)showTermsOfService:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://spornetapp.com/terms.html"]];
}

- (IBAction)showPrivacyPolicy:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.iubenda.com/privacy-policy/7900019/full-legal"]];
}


@end










