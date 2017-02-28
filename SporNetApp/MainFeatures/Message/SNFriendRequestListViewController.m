//
//  SNFriendRequestListViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/25/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNFriendRequestListViewController.h"
#import "SNFriendRequestCell.h"
#import "SNSearchNearbyProfileViewController.h"
#import "SNUser.h"
#import "Conversation.h"
@interface SNFriendRequestListViewController ()
@property NSMutableArray *currentFriendRequstList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isFromNotification;
@end


@implementation SNFriendRequestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"SNFriendRequestCell" bundle:nil] forCellReuseIdentifier:@"SNFriendRequestCell"];
    
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[MessageManager defaultManager] refreshAllFriendRequest];
    [MessageManager defaultManager].delegate = self;
    [MessageManager defaultManager].myClient.delegate = self;

    self.isFromNotification = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    self.isFromNotification = NO; 
    
}

- (void)didFinishRefreshing {
    
    self.currentFriendRequstList = [[MessageManager defaultManager]fetchAllCurrentFriendRequests];
    
    [self.tableView reloadData]; 

}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentFriendRequstList.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNFriendRequestCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SNFriendRequestCell" forIndexPath:indexPath];

    [cell configureCellWithConversation:self.currentFriendRequstList[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Conversation *c = self.currentFriendRequstList[indexPath.row];
    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    vc.isFromNotication = self.isFromNotification;
    vc.currentUserCon = c;
    AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:c.myInfo];
    [user fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        vc.currentUserProfile = (SNUser *)object;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - Message Manager Delegate

-(void)didAcceptFriendRequest {
    self.currentFriendRequstList = [[MessageManager defaultManager]fetchAllCurrentFriendRequests];
    [self.tableView reloadData];
}

@end
