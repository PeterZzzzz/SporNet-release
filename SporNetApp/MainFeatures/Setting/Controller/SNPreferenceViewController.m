//
//  SNPreferenceViewController.m
//  SporNetApp
//
//  Created by Peng Wang on 7/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNPreferenceViewController.h"

typedef NS_ENUM(NSInteger, PreferenceRow) {
    PreferenceRowGender= 0,
    PreferenceRowRadius,
    PreferenceRowSchool,
    PreferenceRowGraduationYear,
    PreferenceRowNumber
};
typedef NS_ENUM(NSInteger, PreferenceSwitch) {
    PreferenceSwitchMale= 1,
    PreferenceSwitchFemale,
    PreferenceSwitchSchool
};

@interface SNPreferenceViewController ()
//IBOutlets of all cells
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *radiusCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *schoolCell;

@property (weak, nonatomic) IBOutlet UISwitch *maleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *femaleSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *mySchoolOnlySwitch;
@property (weak, nonatomic) IBOutlet UILabel *mileLabel;
@property (weak, nonatomic) IBOutlet UISlider *mileSlider;

//array of cells for preference table.
@property (nonatomic) NSArray *cellArray;
@end

@implementation SNPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //set cell array
    self.cellArray = @[self.genderCell, self.radiusCell, self.schoolCell];
}
#pragma mark - table view delegate & datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellArray[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.cellArray[indexPath.row];
    return cell.frame.size.height;
}
//IBOutlet for three switches.
- (IBAction)switchValueChanged:(UISwitch *)sender {
    switch (sender.tag) {
        case PreferenceSwitchMale:
            [[NSUserDefaults standardUserDefaults] setBool:sender.isOn?YES:NO forKey:@"searchPreferenceMale"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if (!self.maleSwitch.isOn) {
                if (self.femaleSwitch.isOn) {
                    return;
                } else {
                    self.femaleSwitch.on = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"searchPreferenceFemale"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            break;
        case PreferenceSwitchFemale:
            [[NSUserDefaults standardUserDefaults] setBool:sender.isOn?YES:NO forKey:@"searchPreferenceFemale"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if (!self.femaleSwitch.isOn) {
                if (self.maleSwitch.isOn) {
                    return;
                } else {
                    self.maleSwitch.on = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"searchPreferenceMale"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            break;
        case PreferenceSwitchSchool:
            [[NSUserDefaults standardUserDefaults] setBool:sender.isOn?YES:NO forKey:@"searchPreferenceOnlyMySchool"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            break;
        default:
            break;
    }
    
    
}

- (IBAction)mileSliderValueDidChange:(UISlider *)sender {
    
    
    _mileLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    [[NSUserDefaults standardUserDefaults]setFloat:sender.value forKey:@"Radius"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)viewWillAppear:(BOOL)animated{
    
    float f = [[NSUserDefaults standardUserDefaults]floatForKey:@"Radius"];
    _mileLabel.text = [NSString stringWithFormat:@"%.0f", f];
    self.mileSlider.value = f;
    
    BOOL isMaleSwitchOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"searchPreferenceMale"];
    BOOL isfemaleSwitchOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"searchPreferenceFemale"];
    BOOL ismySchoolOnlySwitchOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"searchPreferenceOnlyMySchool"];
    
    self.maleSwitch.on = isMaleSwitchOn;
    self.femaleSwitch.on = isfemaleSwitchOn;
    self.mySchoolOnlySwitch.on = ismySchoolOnlySwitchOn;
    
}

@end
