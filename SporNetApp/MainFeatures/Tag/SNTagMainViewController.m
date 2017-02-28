//
//  TagMainViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/28/16.
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
@interface SNTagMainViewController ()
@property (weak, nonatomic) IBOutlet UIView *sportPanel;
@property(nonatomic) TodaySport todaySport;
@property (weak, nonatomic) IBOutlet UILabel *whereLabel;
@property UIImageView *selectedSportImageView;
@property (strong, nonatomic) IBOutlet UIView *relocatePanel;
@property (weak, nonatomic) IBOutlet UIButton *checkInBtn;
@property (weak, nonatomic) IBOutlet UIView *checkinPanel;
@end

@implementation SNTagMainViewController
NSArray *todaySportArraySelected;
NSArray *gymArray;
NSInteger checkinTimes;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    todaySportArraySelected = @[@"joggingSelected", @"muscleSelected", @"soccerSelected", @"basketballSelected", @"yogaSelected"];
    gymArray = @[@"Marino Center", @"Cabot Center", @"Badger & Rosen", @"NU Open Skate"];
    _whereLabel.text = gymArray[0];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.relocatePanel.frame = self.checkinPanel.frame;
    if(checkinTimes > 0) [self.view addSubview:self.relocatePanel];

}

-(void)viewDidAppear:(BOOL)animated{

self.todaySport = TodaySportJogging;
}

#pragma mark - set sport button click event.
- (IBAction)sportButtonClicked:(UIButton *)sender {
    self.todaySport = (TodaySport)sender.tag;
}

-(void)setTodaySport:(TodaySport)todaySport {
    _todaySport = todaySport;
    if(!_selectedSportImageView) {
        _selectedSportImageView = [[UIImageView alloc]init];
        [self.sportPanel addSubview:_selectedSportImageView];
    }
    UIImageView *imageView = (UIImageView*)[self.sportPanel viewWithTag:todaySport];
    _selectedSportImageView.frame = CGRectMake(imageView.frame.origin.x-5, imageView.frame.origin.y-5, imageView.frame.size.width+10, imageView.frame.size.height+10);
    _selectedSportImageView.image = [UIImage imageNamed: todaySportArraySelected[todaySport-1]];
}
#pragma mark - picker view delegate & datasource.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return gymArray.count;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.whereLabel.text = gymArray[row];
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return gymArray[row];
}
- (IBAction)checkInButtonClicked:(UIButton *)sender {
    [ProgressHUD show:@"Checking in now. Please wait..."];
    [self checkInAction];
    }
- (IBAction)updateButtonClicked:(UIButton *)sender {
    [ProgressHUD show:@"Updating in now. Please wait..."];
    [self checkInAction];
}
- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
}

-(void)checkInAction {
    [[CheckInManager defaultManager]checkinWithGymname:self.whereLabel.text sportType:_todaySport viewController:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"toSecondTagVC"]) {
        SNTagSecondViewController *vc = segue.destinationViewController;
        vc.gymName = _whereLabel.text;
        vc.todaySport = _todaySport;
    }
}

@end
