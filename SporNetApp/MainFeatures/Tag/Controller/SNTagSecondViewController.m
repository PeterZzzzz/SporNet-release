//
//  TagSecondViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 7/28/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNTagSecondViewController.h"
#import "TimeManager.h"
#import <AVUser.h>
#import <AVObject.h>
#import <AVQuery.h>
#import "SNTagCell.h"
#import <MJRefresh.h>
#import <DXPopover.h>
#import "ProgressHUD.h"
#import "SNUser.h"
#import "CheckInManager.h"
#import "SNSearchNearbyProfileViewController.h"
@interface SNTagSecondViewController ()

{
    DXPopover *popover;
}

@property (weak, nonatomic)  IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allCheckIns;
@property (weak, nonatomic) IBOutlet UILabel *gymNameLabel;
@property (strong, nonatomic) IBOutlet UIView *popPanel;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (nonatomic, strong) NSMutableArray *currentCheckins;
@property (nonatomic, strong) NSMutableArray *currentUserBasicInfos;

@end


@implementation SNTagSecondViewController

-(NSMutableArray *)currentUserBasicInfos {
    
    if (_currentUserBasicInfos == nil) {
        
        self.currentUserBasicInfos = [[NSMutableArray alloc]init];
        
    }
    
    return _currentUserBasicInfos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gymNameLabel.text = self.gymName;
    [_tableView registerNib:[UINib nibWithNibName:@"SNTagCell" bundle:nil] forCellReuseIdentifier:@"SNTagCell"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.tabBarItem.enabled = YES;
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = NO;
    
    BOOL updateTag = [[NSUserDefaults standardUserDefaults]boolForKey:@"UpdateTag"];
    if (updateTag) {
        
        self.navigationController.tabBarItem.enabled = NO;
        
        self.updateBtn.enabled = NO;
    }
    
}

-(void)refresh {
    self.allCheckIns = [[CheckInManager defaultManager]refreshAndFetchAllCheckinsWithGymName:self.gymNameLabel.text];
    self.currentCheckins = self.allCheckIns;
    [self fetchCurrentUserBasicInfoInBackground];
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
}

-(void)fetchCurrentUserBasicInfoInBackground {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.currentUserBasicInfos removeAllObjects];
        for(AVObject *checkin in self.currentCheckins) {
            AVQuery *query = [SNUser query];
            [query whereKey:@"userID" equalTo:[checkin objectForKey:@"userID"]];
            
            NSArray *checkIns = [query findObjects];
            
            if (checkIns.count) {
                
                [self.currentUserBasicInfos addObject:[checkIns lastObject]];
                
            }else {
                
                return;
            }
            
        }
    });
}
#pragma mark - table view delegate & datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentCheckins.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNTagCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"SNTagCell" forIndexPath:indexPath];
    [cell configureCellWithCheckinInfo:self.currentCheckins[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    if(indexPath.row >= self.currentUserBasicInfos.count) {
        [ProgressHUD show:@"Loading information. Please wait..."];
        AVQuery *query = [SNUser query];
        [query whereKey:@"userID" equalTo:[self.currentCheckins[indexPath.row] objectForKey:@"userID"]];
        vc.currentUserProfile = [query findObjects][0];
    } else {
        SNUser *myself = self.currentUserBasicInfos[indexPath.row];
        if (![myself.objectId isEqualToString:SELF_ID]) {
            
            vc.currentUserProfile = self.currentUserBasicInfos[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        vc.currentUserProfile = self.currentUserBasicInfos[indexPath.row];
    }
    [ProgressHUD dismiss];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)filterButtonClicked:(UIButton *)sender {
    if(popover == nil) {
        popover = [DXPopover popover];
    }
    popover.backgroundColor = [UIColor whiteColor];
    popover.cornerRadius = 8;
    [popover showAtPoint:CGPointMake(self.filterButton.frame.origin.x, self.filterButton.frame.origin.y+20) popoverPostion:DXPopoverPositionDown withContentView:_popPanel inView:self.view];
}
- (IBAction)tagSportButtonOnPopverClicked:(UIButton *)sender {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *checkin = (AVObject*)obj;
        return [[checkin objectForKey:@"sport"]integerValue] == _todaySport;
    }];
    self.currentCheckins = [[self.allCheckIns filteredArrayUsingPredicate:predicate]mutableCopy];
    [self fetchCurrentUserBasicInfoInBackground];
    [_tableView reloadData];
    [popover dismiss];
}
- (IBAction)myTimeButtonOnPopoverClicked:(UIButton *)sender {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        AVObject *checkin = (AVObject*)obj;
        return [[checkin objectForKey:@"sportTimeSlot"]integerValue] == [[[AVUser currentUser]objectForKey:@"sportTimeSlot"]integerValue];
    }];
    self.currentCheckins = [[self.allCheckIns filteredArrayUsingPredicate:predicate]mutableCopy];
    [self fetchCurrentUserBasicInfoInBackground];
    [_tableView reloadData];
    [popover dismiss];
}
- (IBAction)allButtonOnPopoverClicked:(UIButton *)sender {
    self.currentCheckins = self.allCheckIns;
    [self fetchCurrentUserBasicInfoInBackground];
    [_tableView reloadData];
    [popover dismiss];
}
@end
