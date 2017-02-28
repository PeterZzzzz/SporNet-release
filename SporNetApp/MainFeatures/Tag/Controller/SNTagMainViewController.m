//
//  TagMainViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 7/28/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNTagMainViewController.h"
#import "SNTagSecondViewController.h"
#import "ProgressHUD.h"
#import <AVObject.h>
#import <AVUser.h>
#import <AVQuery.h>
#import <AVFile.h>
#import "CheckInManager.h"

@interface SNTagMainViewController () {
    
    //User Sports Selected Array
    NSArray  *_todaySportArraySelected;
    //School Gym Array
    NSArray  *_gymArray;
    
}

/**
 *  User Sports Selection View
 */
@property (weak, nonatomic) IBOutlet UIView *sportPanel;
/**
 *  User Location Selected Label
 */
@property (weak, nonatomic) IBOutlet UILabel *whereLabel;
/**
 *  User Relocate View
 */
@property (strong, nonatomic) IBOutlet UIView *relocatePanel;
/**
 *  User Checkin View
 */
@property (weak, nonatomic) IBOutlet UIView  *checkinPanel;
/**
 *  User Sports Selections
 */
@property (nonatomic, assign)     TodaySport  todaySport;
/**
 *  User Sport Selected ImageView
 */
@property (nonatomic, weak)       UIImageView *selectedSportImageView;

@end

@implementation SNTagMainViewController

#pragma mark - Setter Method

-(void)setTodaySport:(TodaySport)todaySport {
    _todaySport = todaySport;
    
    UIImageView *imageView = (UIImageView*)[self.sportPanel viewWithTag:todaySport];
    self.selectedSportImageView.frame = CGRectMake(imageView.frame.origin.x-5, imageView.frame.origin.y-5, imageView.frame.size.width+8, imageView.frame.size.height+8);
    self.selectedSportImageView.image = [UIImage imageNamed: _todaySportArraySelected[todaySport-1]];
}

#pragma mark - Lazy Load

- (UIImageView *)selectedSportImageView {
    
    if (_selectedSportImageView == nil) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [self.sportPanel addSubview:imageView];
        _selectedSportImageView = imageView;
    }
    
    return _selectedSportImageView;
}

#pragma mark - View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self initialSetUp];
    
    
}

-(void)checkDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter  =[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *todayDate = [dateformatter stringFromDate:date];
    
    NSString *lastDate = [[NSUserDefaults standardUserDefaults]valueForKey:@"LastCheckInDate"];
    
    if ([todayDate isEqualToString:lastDate]) {
        return;
    }else{
        [self updateUserDefaults];
        [[NSUserDefaults standardUserDefaults] setValue:todayDate forKey:@"LastCheckInDate"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

-(void)updateUserDefaults{
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstTag"];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"UpdateTag"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
    [self checkDate];
    BOOL updateTag = [[NSUserDefaults standardUserDefaults]boolForKey:@"UpdateTag"];
    if (updateTag) {
        
        [self performSegueWithIdentifier:@"toSecondTagVC" sender:nil];
        
    }
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    self.tabBarItem.enabled = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.todaySport = TodaySportJogging;
    
    BOOL firstTag = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstTag"];
    if (firstTag) {
        
        self.relocatePanel.frame = self.checkinPanel.frame;
        [self.view addSubview:self.relocatePanel];
        //        [self.checkinPanel removeFromSuperview];
        [self.view bringSubviewToFront:self.relocatePanel];
        
    }else{
        
        [self.relocatePanel removeFromSuperview];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"toSecondTagVC"]) {
        SNTagSecondViewController *vc = segue.destinationViewController;
        vc.gymName = _whereLabel.text;
        vc.todaySport = _todaySport;
    }
}

#pragma mark - Private Methods

- (void)initialSetUp {
    
    _todaySportArraySelected = @[@"joggingSelected", @"muscleSelected", @"soccerSelected", @"basketballSelected", @"yogaSelected"];
    
    
    NSString *email = [AVUser currentUser].email;
    NSString *emailPlist = [[NSBundle mainBundle] pathForResource:@"emailToSchool" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:emailPlist];
    
    NSArray *emailList = [dic allKeys];
    
    for (NSString *schoolEmail in emailList) {
        
        NSString *realEmail = [NSString stringWithString:schoolEmail];
        
        if ([email containsString:realEmail]) {
            
            _gymArray = [dic[realEmail] lastObject];
            
        }
    }
    _whereLabel.text = _gymArray[0];
    
}

-(void)checkInAction {
    [[CheckInManager defaultManager]checkinWithGymname:self.whereLabel.text sportType:_todaySport viewController:self];
}

#pragma mark - User Button Clicked

/**
 *  When User Select Sport
 *
 *  @param sender User Sport Select Button
 */
- (IBAction)sportButtonClicked:(UIButton *)sender {
    self.todaySport = (TodaySport)sender.tag;
}

/**
 *  When User Select CheckIn
 *
 */
- (IBAction)checkInButtonClicked:(UIButton *)sender {
    [ProgressHUD show:@"Checking in now. Please wait..."];
    [self checkInAction];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FirstTag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
/**
 *  When User Update Location
 *
 */
- (IBAction)updateButtonClicked:(UIButton *)sender {
    [ProgressHUD show:@"Updating now. Please wait..."];
    [self checkInAction];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"UpdateTag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}
/**
 *  When User Select Cancel
 *
 */
- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toSecondTagVC" sender:nil];
}

#pragma mark - picker view delegate & datasource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _gymArray.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.whereLabel.text = _gymArray[row];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _gymArray[row];
}





@end
