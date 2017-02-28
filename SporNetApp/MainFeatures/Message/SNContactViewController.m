//
//  SNContactViewController.m
//  SporNetApp
//
//  Created by Peng Wang on 8/26/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNContactViewController.h"
#import "MessageManager.h"
#import "SNContactCell.h"
#import "SNChatViewController.h"
@interface SNContactViewController ()

@property (weak, nonatomic) IBOutlet UIView *indexView;
@property (nonatomic, strong) NSMutableArray *indexIcons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *allContacts;

@end

@implementation SNContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.allContacts = [[MessageManager defaultManager]fetchAllContacts];
    [self.tableView registerNib:[UINib nibWithNibName:@"SNContactCell" bundle:nil] forCellReuseIdentifier:@"SNContactCell"];
    [self loadIndexView];
    [self.view bringSubviewToFront:self.indexView];
}

-(void)loadIndexView {
    _indexIcons = [[NSMutableArray alloc]init];
    int i = 1;
    for(NSString *str in self.allContacts.allKeys) {
        UIImage *image = [UIImage imageNamed:SPORT_IMAGE_DIC[str]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 50, 50);
        imageView.center = CGPointMake(self.indexView.frame.size.width / 2.0, self.indexView.frame.size.height / (self.allContacts.count + 1) * i );
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(indexIconClicked:)]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = [SPORT_ARRAY indexOfObject:str];
        i++;
        [self.indexView addSubview:imageView];
    }
}
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allContacts.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *category = self.allContacts.allKeys[section];
    return [self.allContacts[category] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SNContactCell" forIndexPath:indexPath];
    
    NSString *category = self.allContacts.allKeys[indexPath.section];
    [cell configureCellWithConversation:_allContacts[category][indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont systemFontOfSize:18];
    myLabel.textColor = [UIColor lightGrayColor];
    myLabel.text = self.allContacts.allKeys[section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    return headerView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *category = self.allContacts.allKeys[indexPath.section];
    SNChatViewController *vc = [[SNChatViewController alloc]init];
    vc.conversation = _allContacts[category][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)indexIconClicked:(UITapGestureRecognizer*)tap {
//    NSLog(@"来来来");
    NSIndexPath *iPath = [NSIndexPath indexPathForRow:0 inSection:[self.allContacts.allKeys indexOfObject:SPORT_ARRAY[tap.view.tag]]];

    [self.tableView scrollToRowAtIndexPath:iPath atScrollPosition:UITableViewScrollPositionTop  animated:YES];
}
@end
