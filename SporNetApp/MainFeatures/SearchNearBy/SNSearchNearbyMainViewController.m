//
//  ViewController.m
//  SearchNearBy_Demo
//
//  Created by ZhengYang on 16/7/28.
//  Copyright © 2016年 ZhengYang. All rights reserved.
//

#import "SNSearchNearbyMainViewController.h"
#import "WaterView.h"
#import <pop/POP.h>
#import "LocalDataManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <AVFile.h>
#import <AVObject.h>
#import "UserView.h"
#import "ProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "AVUser.h"
#import "SNFriendsShareCell.h"
#import "SNPublishViewController.h"
#import "SNMomentManager.h"
#import "FriendsMomentModel.h"
#import "MJRefresh.h"

#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication]statusBarFrame].size.height
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define R ([UIScreen mainScreen].bounds.size.width/2-50)

@interface SNSearchNearbyMainViewController ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource, SNPublishViewControllerDelegate,SNMomentManagerDelegate>
@property (weak, nonatomic ) UIButton                         *filterBtnInBlurView;
@property (weak, nonatomic ) UIButton                         *basketballBtn;
@property (weak, nonatomic ) UIButton                         *footballBtn;
@property (weak, nonatomic ) UIButton                         *fitnessBtn;
@property (weak, nonatomic ) UIButton                         *runBtn;
@property (weak, nonatomic ) UIButton                         *yogaBtn;
@property (weak, nonatomic ) UIButton                         *allBtn;
@property (weak,nonatomic  ) UIVisualEffectView               *blurView;

@property (nonatomic       ) BOOL                             isFinishLoad;
@property (nonatomic       ) BOOL                             isMyTimeLine;
@property (weak, nonatomic ) UIImageView                      *galaxyImageView;
@property (weak, nonatomic ) UIView                           *topBtnView;
@property (weak, nonatomic ) UISegmentedControl               *segSwitch;
@property (weak, nonatomic ) UIButton                         *refreshBtn;
@property (weak, nonatomic ) UIButton                         *viewMTLBtn;
@property (weak,nonatomic  ) UIView                           *circleView;
@property (weak, nonatomic ) UILabel                          *radiusLabel;
@property (weak, nonatomic ) UIView                           *user1Area;
@property (weak, nonatomic ) UIView                           *user2Area;
@property (weak, nonatomic ) UIView                           *user3Area;
@property (weak, nonatomic ) UIView                           *user4Area;
@property (weak, nonatomic ) UIView                           *user5Area;
@property (weak, nonatomic ) UIView                           *user6Area;
@property (weak, nonatomic ) UIView                           *user7Area;
@property (weak, nonatomic ) UIView                           *user8Area;
@property (weak, nonatomic ) UIView                           *momentView;
@property (weak, nonatomic ) UITableView                      *momentTableView;

@property (weak, nonatomic ) UIButton                         *filterBtn;
@property (weak, nonatomic ) UIButton                         *user1;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView1;
@property (weak, nonatomic ) UIButton                         *user2;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView2;
@property (weak, nonatomic ) UIButton                         *user3;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView3;
@property (weak, nonatomic ) UIButton                         *user4;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView4;
@property (weak, nonatomic ) UIButton                         *user5;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView5;
@property (weak, nonatomic ) UIButton                         *user6;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView6;
@property (weak, nonatomic ) UIButton                         *user7;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView7;
@property (weak, nonatomic ) UIButton                         *user8;
@property (weak, nonatomic ) UIImageView                      *bestSportImageView8;

@property (nonatomic,assign) CGFloat                          x0;
@property (nonatomic,assign) CGFloat                          y0;
@property (nonatomic,assign) CGFloat                          x1;
@property (nonatomic,assign) CGFloat                          y1;
@property (nonatomic,assign) CGFloat                          x2;
@property (nonatomic,assign) CGFloat                          y2;
@property (nonatomic,assign) CGFloat                          x3;
@property (nonatomic,assign) CGFloat                          y3;
@property (nonatomic,assign) CGFloat                          x4;
@property (nonatomic,assign) CGFloat                          y4;
@property (nonatomic,assign) CGFloat                          x5;
@property (nonatomic,assign) CGFloat                          y5;
@property (nonatomic,assign) CGFloat                          x6;
@property (nonatomic,assign) CGFloat                          y6;
@property (nonatomic,assign) CGFloat                          x7;
@property (nonatomic,assign) CGFloat                          y7;
@property (nonatomic,assign) CGFloat                          x8;
@property (nonatomic,assign) CGFloat                          y8;
@property (nonatomic,assign) CGFloat                          dist1;
@property (nonatomic,assign) CGFloat                          dist2;
@property (nonatomic,assign) CGFloat                          dist3;
@property (nonatomic,assign) CGFloat                          dist4;
@property (nonatomic,assign) CGFloat                          dist5;
@property (nonatomic,assign) CGFloat                          dist6;
@property (nonatomic,assign) CGFloat                          dist7;
@property (nonatomic,assign) CGFloat                          dist8;
@property (nonatomic,assign) BOOL                             isTabBarHide;
@property (nonatomic,assign) BOOL                             isUser1Null;
@property (nonatomic,assign) BOOL                             isUser2Null;
@property (nonatomic,assign) BOOL                             isUser3Null;
@property (nonatomic,assign) BOOL                             isUser4Null;
@property (nonatomic,assign) BOOL                             isUser5Null;
@property (nonatomic,assign) BOOL                             isUser6Null;
@property (nonatomic,assign) BOOL                             isUser7Null;
@property (nonatomic,assign) BOOL                             isUser8Null;
@property (nonatomic,assign) BOOL                             photoShowedOnFilterBtn;
@property (nonatomic,weak  ) NSTimer                          *loadingTimer;

//用户的半径，更确切的说是用户生成地点距离所在view的边距。用户按钮的大小主要有pop函数的toValue来控制，如果toValue是50，但是userR＝100则在view内边距为userR－toValue的范围内活动。
@property (nonatomic,assign) CGFloat                          userR;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currlocation;
//经度
@property (nonatomic,assign) CGFloat                          longitude;
//纬度
@property (nonatomic,assign) CGFloat                          latitude;
//本机用户地点
@property AVGeoPoint *currentUserLocation;
//其他用户到本用户的距离
@property (nonatomic,assign) CGFloat                          dist;

@property NSMutableArray *allUsers;
//最终符合所选搜索条件的Array，直接作用于CreatUser方法
@property NSMutableArray *currentUsers;
//永不相见用户列表
@property (nonatomic) NSMutableArray *neverSeeAgain;
//朋友圈用户集合
@property (nonatomic, strong) NSMutableArray *momentsUsers;

-(void)loadingMoments;
@end

@implementation SNSearchNearbyMainViewController
NSInteger indexOfCurrentUser;


-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self locationManager];
    self.dist = [[NSUserDefaults standardUserDefaults]floatForKey:@"Radius"];
    [self setBackgroundGalaxy];
    [self addTopView];
    [self addCircleView];
    self.userR = 50;
    
    [self load4AllUser];
}

-(void)load4AllUser{
    [self.loadingTimer setFireDate:[NSDate distantFuture]];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        [self fetchUserByLocation];
        [self fetchCurrentUsersFromAllUsers];
    });
    
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [self showLoadView];
        self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshAnimation) userInfo:nil repeats:YES];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self creatUserFromCurrentUsers];
        if (self.currentUsers.count != 0) {
            [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
        }
    });
    
}

-(void)fetchUserByLocation{
    //初始化在appDelegate里面的首次定位位置
    NSString *lo = [[NSUserDefaults standardUserDefaults]valueForKey:@"Lo"];
    NSString *la = [[NSUserDefaults standardUserDefaults]valueForKey:@"La"];
    AVGeoPoint *p =[AVGeoPoint geoPointWithLatitude:([la doubleValue]) longitude:[lo doubleValue]];
    
    
    
    
//#warning BlackList
    //            self.neverSeeAgain = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"blackList"]];
    
    if (p) {
        self.allUsers = [[LocalDataManager defaultManager]fetchNearByUserInfo:p withinDist:self.dist];
        if (self.allUsers.count == 0) {
            return;
        }
        self.allUsers = [[LocalDataManager defaultManager]filterUserByGenderFromList:self.allUsers];
//#warning BlackList
        //        self.allUsers = [[LocalDataManager defaultManager]fetchUserFromBlackList:self.allUsers withBlackList:self.neverSeeAgain];
        
        
        if(_allUsers.count == 0) {
            [ProgressHUD showError:@"Bad connection. Please try later."];
            return;
        }
        
        
    }else{
        [ProgressHUD showError:@"No location."];
    }
    
}

-(void)fetchCurrentUsersFromAllUsers{
    switch (self.allUsers.count) {
        case 0:
            //网络出错&筛选体育运动的时候没有选择自己的运动
            self.currentUsers = nil;
            break;
            
        case 1:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0]]];
            indexOfCurrentUser = 1;
            break;
            
        case 2:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0],_allUsers[1]]];
            indexOfCurrentUser = 2;
            break;
            
        case 3:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0],_allUsers[1],_allUsers[2]]];
            indexOfCurrentUser = 3;
            break;
            
        case 4:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0],_allUsers[1],_allUsers[2],_allUsers[3]]];
            indexOfCurrentUser = 4;
            break;
            
        case 5:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0],_allUsers[1],_allUsers[2],_allUsers[3],_allUsers[4]]];
            indexOfCurrentUser = 5;
            break;
            
        case 6:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0],_allUsers[1],_allUsers[2],_allUsers[3],_allUsers[4],_allUsers[5]]];
            indexOfCurrentUser = 6;
            break;
            
            
        case 7:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0],_allUsers[1],_allUsers[2],_allUsers[3],_allUsers[4],_allUsers[5],_allUsers[6]]];
            indexOfCurrentUser = 7;
            break;
            
            
        default:
            self.currentUsers = [NSMutableArray arrayWithArray:@[_allUsers[0],_allUsers[1],_allUsers[2],_allUsers[3],_allUsers[4],_allUsers[5],_allUsers[6],_allUsers[7]]];
            indexOfCurrentUser = 8;
            break;
            
            
    }
    
}

-(void)creatUserFromCurrentUsers{
    switch (self.currentUsers.count) {
        case 0:
            
            break;
            
        case 1:
        {
            [self createUser1Btn];
            self.isUser2Null = YES;
            self.isUser3Null = YES;
            self.isUser4Null = YES;
            self.isUser5Null = YES;
            self.isUser6Null = YES;
            self.isUser7Null = YES;
            self.isUser8Null = YES;
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
        }
            break;
            
        case 2:
            [self createUser1Btn];
            [self createUser2Btn];
            self.isUser3Null = YES;
            self.isUser4Null = YES;
            self.isUser5Null = YES;
            self.isUser6Null = YES;
            self.isUser7Null = YES;
            self.isUser8Null = YES;
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 3:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            self.isUser4Null = YES;
            self.isUser5Null = YES;
            self.isUser6Null = YES;
            self.isUser7Null = YES;
            self.isUser8Null = YES;
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 4:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            [self createUser4Btn];
            self.isUser5Null = YES;
            self.isUser6Null = YES;
            self.isUser7Null = YES;
            self.isUser8Null = YES;
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 5:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            [self createUser4Btn];
            [self createUser5Btn];
            self.isUser6Null = YES;
            self.isUser7Null = YES;
            self.isUser8Null = YES;
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 6:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            [self createUser4Btn];
            [self createUser5Btn];
            [self createUser6Btn];
            self.isUser7Null = YES;
            self.isUser8Null = YES;
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 7:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            [self createUser4Btn];
            [self createUser5Btn];
            [self createUser6Btn];
            [self createUser7Btn];
            self.isUser8Null = YES;
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
        case 8:
            [self createUser1Btn];
            [self createUser2Btn];
            [self createUser3Btn];
            [self createUser4Btn];
            [self createUser5Btn];
            [self createUser6Btn];
            [self createUser7Btn];
            [self createUser8Btn];
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            self.refreshBtn.enabled = YES;
            
            self.photoShowedOnFilterBtn = NO;
            [self refreshAnimation];
            break;
            
            
        default:
            
            break;
            
            
    }
}

-(void)firstTimeAlert{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"If you remove user from the screen, you'll never see this use again" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.locationManager startUpdatingLocation];
    
    self.dist = [[NSUserDefaults standardUserDefaults]floatForKey:@"Radius"];
    self.radiusLabel.text = [NSString stringWithFormat:@"%.0f Miles", self.dist];
    
    [self tapCircleView];
//    NSLog(@"%@",self.neverSeeAgain);
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.blurView removeFromSuperview];
    //    [self.loadingTimer setFireDate:[NSDate distantPast]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    //    [self.loadingTimer setFireDate:[NSDate distantFuture]];
}

-(void)createUser1Btn{
    [self randomUser1Coordinate];
    UIButton *user1 = [[UIButton alloc]initWithFrame:CGRectMake(self.x1, self.y1, self.userR, self.userR)];
    if([_currentUsers[0] objectForKey:@"icon"]) [user1 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[0] objectForKey:@"icon"]getData]] forState:normal];
    else [user1 setImage:[UIImage imageNamed:@"profile"] forState:normal];
    [[user1 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[0] objectForKey:@"sportTimeSlot"]integerValue]];
    [user1.layer setBorderColor:color.CGColor];
    user1.layer.masksToBounds = YES;
    user1.layer.cornerRadius = user1.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x1 + 41, self.y1 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[0] objectForKey:@"bestSport"]integerValue]]];
//    NSLog(@"current user name is %@", [self.currentUsers[0] objectForKey:@"name"]);
    [self.user1Area addSubview:user1];
    [self.user1Area addSubview:bestsportView];
    self.user1 = user1;
    self.bestSportImageView1 = bestsportView;
    [self.user1 addTarget:self action:@selector(dragUser1Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user1 addTarget:self action:@selector(ifUser1Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user1 addTarget:self action:@selector(rememberUser1OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user1.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView1.layer pop_addAnimation:animSport forKey:@"size"];
    
    //        NSLog(@"%f %f",self.x,self.y);
    self.isUser1Null = NO;
    self.dist1 = 0;
    
}

-(void)createUser2Btn{
    [self randomUser2Coordinate];
    UIButton *user2 = [[UIButton alloc]initWithFrame:CGRectMake(self.x2, self.y2, self.userR, self.userR)];
    if([_currentUsers[1] objectForKey:@"icon"]) [user2 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[1] objectForKey:@"icon"]getData]] forState:normal];
    else [user2 setImage:[UIImage imageNamed:@"profile"] forState:normal];
//    NSLog(@"current user name is %@", [self.currentUsers[1] objectForKey:@"name"]);
    
    [[user2 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[1] objectForKey:@"sportTimeSlot"]integerValue]];
    [user2.layer setBorderColor:color.CGColor];
    user2.layer.masksToBounds = YES;
    user2.layer.cornerRadius = user2.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x2 + 41, self.y2 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[1] objectForKey:@"bestSport"]integerValue]]];
    [self.user2Area addSubview:user2];
    [self.user2Area addSubview:bestsportView];
    self.user2 = user2;
    self.bestSportImageView2 = bestsportView;
    [self.user2 addTarget:self action:@selector(dragUser2Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user2 addTarget:self action:@selector(ifUser2Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user2 addTarget:self action:@selector(rememberUser2OrignXY:) forControlEvents:UIControlEventTouchDown];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user2.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView2.layer pop_addAnimation:animSport forKey:@"size"];
    
    //        NSLog(@"%f %f",self.x,self.y);
    self.isUser2Null = NO;
    self.dist2 = 0;
    
}

-(void)createUser3Btn{
    [self randomUser3Coordinate];
    UIButton *user3 = [[UIButton alloc]initWithFrame:CGRectMake(self.x3, self.y3, self.userR, self.userR)];
    if([_currentUsers[2] objectForKey:@"icon"]) [user3 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[2] objectForKey:@"icon"]getData]] forState:normal];
    else [user3 setImage:[UIImage imageNamed:@"profile"] forState:normal];
//    NSLog(@"current user name is %@", [self.currentUsers[2] objectForKey:@"name"]);
    [[user3 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[2] objectForKey:@"sportTimeSlot"]integerValue]];
    [user3.layer setBorderColor:color.CGColor];
    user3.layer.masksToBounds = YES;
    user3.layer.cornerRadius = user3.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x3 + 41, self.y3 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[2] objectForKey:@"bestSport"]integerValue]]];
    [self.user3Area addSubview:user3];
    [self.user3Area addSubview:bestsportView];
    self.user3 = user3;
    self.bestSportImageView3 = bestsportView;
    [self.user3 addTarget:self action:@selector(dragUser3Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user3 addTarget:self action:@selector(ifUser3Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user3 addTarget:self action:@selector(rememberUser3OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user3.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView3.layer pop_addAnimation:animSport forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    self.isUser3Null = NO;
    self.dist3 = 0;
    
}

-(void)createUser4Btn{
    [self randomUser4Coordinate];
    UIButton *user4 = [[UIButton alloc]initWithFrame:CGRectMake(self.x4, self.y4, self.userR, self.userR)];
    if([_currentUsers[3] objectForKey:@"icon"]) [user4 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[3] objectForKey:@"icon"]getData]] forState:normal];
    else [user4 setImage:[UIImage imageNamed:@"profile"] forState:normal];
//    NSLog(@"current user name is %@", [self.currentUsers[3] objectForKey:@"name"]);
    [[user4 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[3] objectForKey:@"sportTimeSlot"]integerValue]];
    [user4.layer setBorderColor:color.CGColor];
    user4.layer.masksToBounds = YES;
    user4.layer.cornerRadius = user4.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x4 + 41, self.y4 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[3] objectForKey:@"bestSport"]integerValue]]];
    [self.user4Area addSubview:user4];
    [self.user4Area addSubview:bestsportView];
    self.user4 = user4;
    self.bestSportImageView4 = bestsportView;
    [self.user4 addTarget:self action:@selector(dragUser4Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user4 addTarget:self action:@selector(ifUser4Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user4 addTarget:self action:@selector(rememberUser4OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user4.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView4.layer pop_addAnimation:animSport forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    self.isUser4Null = NO;
    self.dist4 = 0;
    
}

-(void)createUser5Btn{
    [self randomUser5Coordinate];
    UIButton *user5 = [[UIButton alloc]initWithFrame:CGRectMake(self.x5, self.y5, self.userR, self.userR)];
    if([_currentUsers[4] objectForKey:@"icon"]) [user5 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[4] objectForKey:@"icon"]getData]] forState:normal];
    ;
//    NSLog(@"current user name is %@", [self.currentUsers[4] objectForKey:@"name"]);
    [[user5 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[4] objectForKey:@"sportTimeSlot"]integerValue]];
    [user5.layer setBorderColor:color.CGColor];
    user5.layer.masksToBounds = YES;
    user5.layer.cornerRadius = user5.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x5 + 41, self.y5 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[4] objectForKey:@"bestSport"]integerValue]]];
    [self.user5Area addSubview:user5];
    [self.user5Area addSubview:bestsportView];
    self.user5 = user5;
    self.bestSportImageView5 = bestsportView;
    [self.user5 addTarget:self action:@selector(dragUser5Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user5 addTarget:self action:@selector(ifUser5Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user5 addTarget:self action:@selector(rememberUser5OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user5.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView5.layer pop_addAnimation:animSport forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    self.isUser5Null = NO;
    self.dist5 = 0;
    
}

-(void)createUser6Btn{
    [self randomUser6Coordinate];
    UIButton *user6 = [[UIButton alloc]initWithFrame:CGRectMake(self.x6, self.y6, self.userR, self.userR)];
    if([_currentUsers[5] objectForKey:@"icon"]) [user6 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[5] objectForKey:@"icon"]getData]] forState:normal];
    ;
//    NSLog(@"current user name is %@", [self.currentUsers[5] objectForKey:@"name"]);
    [[user6 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[5] objectForKey:@"sportTimeSlot"]integerValue]];
    [user6.layer setBorderColor:color.CGColor];
    user6.layer.masksToBounds = YES;
    user6.layer.cornerRadius = user6.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x6 + 41, self.y6 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[5] objectForKey:@"bestSport"]integerValue]]];
    [self.user6Area addSubview:user6];
    [self.user6Area addSubview:bestsportView];
    self.user6 = user6;
    self.bestSportImageView6 = bestsportView;
    [self.user6 addTarget:self action:@selector(dragUser6Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user6 addTarget:self action:@selector(ifUser6Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user6 addTarget:self action:@selector(rememberUser6OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user6.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView6.layer pop_addAnimation:animSport forKey:@"size"];
    
    //    NSLog(@"%f %f",self.x,self.y);
    self.isUser6Null = NO;
    self.dist6 = 0;
    
}

-(void)createUser7Btn{
    [self randomUser7Coordinate];
    UIButton *user7 = [[UIButton alloc]initWithFrame:CGRectMake(self.x7, self.y7, self.userR, self.userR)];
    if([_currentUsers[6] objectForKey:@"icon"]) [user7 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[6] objectForKey:@"icon"]getData]] forState:normal];
    ;
//    NSLog(@"current user name is %@", [self.currentUsers[6] objectForKey:@"name"]);
    [[user7 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[6] objectForKey:@"sportTimeSlot"]integerValue]];
    [user7.layer setBorderColor:color.CGColor];
    user7.layer.masksToBounds = YES;
    user7.layer.cornerRadius = user7.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x7 + 41, self.y7 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[6] objectForKey:@"bestSport"]integerValue]]];
    [self.user7Area addSubview:user7];
    [self.user7Area addSubview:bestsportView];
    self.user7 = user7;
    self.bestSportImageView7 = bestsportView;
    [self.user7 addTarget:self action:@selector(dragUser7Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user7 addTarget:self action:@selector(ifUser7Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user7 addTarget:self action:@selector(rememberUser7OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user7.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView7.layer pop_addAnimation:animSport forKey:@"size"];
    
//        NSLog(@"%f %f",self.x,self.y);
    self.isUser7Null = NO;
    self.dist7 = 0;
    
}

-(void)createUser8Btn{
    [self randomUser8Coordinate];
    UIButton *user8 = [[UIButton alloc]initWithFrame:CGRectMake(self.x8, self.y8, self.userR, self.userR)];
    if([_currentUsers[7] objectForKey:@"icon"]) [user8 setImage:[UIImage imageWithData:[(AVFile*)[_currentUsers[7] objectForKey:@"icon"]getData]] forState:normal];
    ;
//    NSLog(@"current user name is %@", [self.currentUsers[7] objectForKey:@"name"]);
    [[user8 layer] setBorderWidth:2.0f];
    UIColor *color = SPORTSLOT_COLOR_ARRAY[[[_currentUsers[7] objectForKey:@"sportTimeSlot"]integerValue]];
    [user8.layer setBorderColor:color.CGColor];
    user8.layer.masksToBounds = YES;
    user8.layer.cornerRadius = user8.frame.size.width / 2.0;
    UIImageView *bestsportView = [[UIImageView alloc]init];
    bestsportView.frame = CGRectMake(self.x8 + 41, self.y8 + 16, 18, 18);
    bestsportView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[_currentUsers[7] objectForKey:@"bestSport"]integerValue]]];
    [self.user8Area addSubview:user8];
    [self.user8Area addSubview:bestsportView];
    self.user8 = user8;
    self.bestSportImageView8 = bestsportView;
    [self.user8 addTarget:self action:@selector(dragUser8Moving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.user8 addTarget:self action:@selector(ifUser8Remove) forControlEvents:UIControlEventTouchUpInside];
    [self.user8 addTarget:self action:@selector(rememberUser8OrignXY:) forControlEvents:UIControlEventTouchDown];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
    anim.springSpeed = 50.0;
    anim.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim.springBounciness = 6;
    //震动的明显程度
    anim.dynamicsMass = 10;
    
    POPSpringAnimation *animSport = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animSport.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    animSport.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 18, 18)];
    animSport.springSpeed = 50.0;
    animSport.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    animSport.springBounciness = 6;
    //震动的明显程度
    animSport.dynamicsMass = 10;
    
    [self.user8.layer pop_addAnimation:anim forKey:@"size"];
    [self.bestSportImageView8.layer pop_addAnimation:animSport forKey:@"size"];
    
//        NSLog(@"%f %f",self.x,self.y);
    self.isUser8Null = NO;
    self.dist8 = 0;
    
}

-(void)ifUser1Remove{
    
    if (self.dist1 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[0]];
    }else if(self.dist1 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x1+self.userR/2, self.y1+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user1.center=location;
            self.bestSportImageView1.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        
        self.dist1 = 0;
    }else{
        //移除的动画效果
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user1.frame];
        [self.user1 removeFromSuperview];
        [self.bestSportImageView1 removeFromSuperview];
        [self.user1Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //                NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //                self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[0]objectForKey:@"objectId"];
        //
        //                NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //                [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //                [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser1Null = YES;
        if(indexOfCurrentUser == self.allUsers.count) {
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[0] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser1Btn];
            //放在creatBtn中
            //self.dist1 = 0;
        }
    }
    
}

-(void)ifUser2Remove{
    if (self.dist2 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[1]];
    }else if(self.dist2 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x2+self.userR/2, self.y2+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user2.center=location;
            self.bestSportImageView2.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        self.dist2 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user2.frame];
        [self.user2 removeFromSuperview];
        [self.bestSportImageView2 removeFromSuperview];
        [self.user2Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[1]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser2Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[1] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser2Btn];
            //            self.dist2 = 0;
        }
    }
    
}

-(void)ifUser3Remove{
    
    if (self.dist3 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[2]];
    } else if(self.dist3 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x3+self.userR/2, self.y3+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user3.center=location;
            self.bestSportImageView3.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        self.dist3 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user3.frame];
        [self.user3 removeFromSuperview];
        [self.bestSportImageView3 removeFromSuperview];
        [self.user3Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[2]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser3Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[2] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser3Btn];
            //            self.dist3 = 0;
        }
    }
    
}

-(void)ifUser4Remove{
    
    if (self.dist4 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[3]];
    }else if(self.dist4 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x4+self.userR/2, self.y4+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user4.center=location;
            self.bestSportImageView4.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        self.dist4 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user4.frame];
        [self.user4 removeFromSuperview];
        [self.bestSportImageView4 removeFromSuperview];
        [self.user4Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[3]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser4Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[3] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser4Btn];
            //            self.dist4 = 0;
        }
    }
    
}

-(void)ifUser5Remove{
    
    if (self.dist5 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[4]];
    }else if(self.dist5 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x5+self.userR/2, self.y5+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user5.center=location;
            self.bestSportImageView5.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        
        
        self.dist5 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user5.frame];
        [self.user5 removeFromSuperview];
        [self.bestSportImageView5 removeFromSuperview];
        [self.user5Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[4]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser5Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[4] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser5Btn];
            //            self.dist5 = 0;
        }
    }
    
}

-(void)ifUser6Remove{
    
    if (self.dist6 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[5]];
    }else if(self.dist6 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x6+self.userR/2, self.y6+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user6.center=location;
            self.bestSportImageView6.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        
        
        self.dist6 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user6.frame];
        [self.user6 removeFromSuperview];
        [self.bestSportImageView6 removeFromSuperview];
        [self.user6Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[5]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser6Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[5] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser6Btn];
        }
    }
    
}

-(void)ifUser7Remove{
    
    if (self.dist7 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[6]];
    }else if(self.dist7 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x7+self.userR/2, self.y7+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user7.center=location;
            self.bestSportImageView7.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        
        
        self.dist7 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user7.frame];
        [self.user7 removeFromSuperview];
        [self.bestSportImageView7 removeFromSuperview];
        [self.user7Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[6]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser7Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[6] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser7Btn];
        }
    }
    
}

-(void)ifUser8Remove{
    
    if (self.dist8 < 15) {
//        NSLog(@"用户信息");
        [self configreBlurView];
        [self showUserInfo:self.currentUsers[7]];
    }else if(self.dist8 < 100){
//        NSLog(@"弹簧效果");
        
        CGPoint location= CGPointMake(self.x8+self.userR/2, self.y8+self.userR/2);
        /*创建弹性动画
         damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
         velocity:弹性复位的速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.user8.center=location;
            self.bestSportImageView8.center = CGPointMake(location.x + 25, location.y);
        } completion:nil];
        
        
        self.dist8 = 0;
    }else{
        UIImageView *bombView = [[UIImageView alloc]initWithFrame:self.user8.frame];
        [self.user8 removeFromSuperview];
        [self.bestSportImageView8 removeFromSuperview];
        [self.user8Area addSubview:bombView];
        [bombView setAnimationImages:@[[UIImage imageNamed:@"bomb0"],[UIImage imageNamed:@"bomb1"], [UIImage imageNamed:@"bomb2"],[UIImage imageNamed:@"bomb3"],[UIImage imageNamed:@"bomb4"]]];
        [bombView setAnimationRepeatCount:1];
        [bombView setAnimationDuration:0.5];
        [bombView startAnimating];
//#warning BlackList
        //        NSInteger indexOfBlackList = self.neverSeeAgain.count;
        //        self.neverSeeAgain[indexOfBlackList] = [self.currentUsers[7]objectForKey:@"objectId"];
        
        //        NSArray *array = [NSArray arrayWithArray:self.neverSeeAgain];
        //        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"blackList"];
        //        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        self.isUser8Null = YES;
        if(indexOfCurrentUser == self.allUsers.count){
            if (self.isUser1Null && self.isUser2Null && self.isUser3Null && self.isUser4Null && self.isUser5Null && self.isUser6Null && self.isUser7Null && self.isUser8Null) {
                [self load4AllUser];
            } else {
                return;
            }
        }else{
            self.currentUsers[7] = self.allUsers[indexOfCurrentUser];
            indexOfCurrentUser++;
            [self createUser8Btn];
        }
    }
    
}


/**
 *  add circle view and filter btn
 */
-(void)addCircleView{
    
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBtnView.frame), MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - CGRectGetMaxY(self.topBtnView.frame) - 49)];
    //    circleView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:circleView];
    self.circleView = circleView;
    self.circleView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    [self.circleView addGestureRecognizer:tapGesturRecognizer];
    
    
    UIImageView *radiusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.bounds) -25, CGRectGetMinY(self.circleView.bounds), 50, 50)];
    radiusImageView.backgroundColor = [UIColor clearColor];
    radiusImageView.image = [UIImage imageNamed:@"radius"];
    [self.circleView addSubview:radiusImageView];
    
    /**
     *  黑洞效果
     */
    //
    //    UIImageView *radiusBGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topBtnView.bounds.size.width/2 -40, self.topBtnView.bounds.size.height/2 -40, 80, 80)];
    //    radiusBGImageView.image = [UIImage imageNamed:@"blackhole"];
    //    radiusBGImageView.layer.masksToBounds = YES;
    //    radiusBGImageView.layer.cornerRadius = radiusBGImageView.frame.size.width / 2.0;
    //    UIImageView *radiusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.topBtnView.bounds.size.width/2 -30, self.topBtnView.bounds.size.height/2 -30, 60, 60)];
    //    radiusImageView.image = [UIImage imageNamed:@"blackhole2"];
    //    radiusImageView.layer.masksToBounds = YES;
    //    radiusImageView.layer.cornerRadius = radiusImageView.frame.size.width / 2.0;
    //
    //    CGFloat angleBG = -M_1_PI;
    //    CGFloat angle = M_PI;
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:50];
    //    for (int i = 1; i<50; i++) {
    //        radiusImageView.transform = CGAffineTransformRotate(radiusImageView.transform, angle);
    //        radiusBGImageView.transform = CGAffineTransformRotate(radiusBGImageView.transform, angleBG);
    //    }
    //    [UIView commitAnimations];
    //
    //    [self.topBtnView addSubview:radiusBGImageView];
    //    [self.topBtnView addSubview:radiusImageView];
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.bounds) - 75, CGRectGetMaxY(radiusImageView.frame) + 10, 150, 20)];
    //    topLabel.text = @"我是距离";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.backgroundColor = [UIColor clearColor];
    [self.circleView addSubview:topLabel];
    self.radiusLabel = topLabel;
    self.radiusLabel.text = [NSString stringWithFormat:@"%.0f Miles", self.dist];
    
    
    
    UIView *user1Area = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.radiusLabel.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
    //    user1Area.backgroundColor = [UIColor redColor];
    [self.circleView addSubview:user1Area];
    self.user1Area = user1Area;
    UITapGestureRecognizer *tapGesturRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user1Area.userInteractionEnabled = YES;
    [self.user1Area addGestureRecognizer:tapGesturRecognizer1];
    
    UIView *user2Area = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.user1Area.frame), CGRectGetMaxY(self.radiusLabel.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
    //    user2Area.backgroundColor = [UIColor orangeColor];
    [self.circleView addSubview:user2Area];
    self.user2Area = user2Area;
    UITapGestureRecognizer *tapGesturRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user2Area.userInteractionEnabled = YES;
    [self.user2Area addGestureRecognizer:tapGesturRecognizer2];
    
    UIView *user3Area = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.user2Area.frame), CGRectGetMaxY(self.radiusLabel.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
    //    user3Area.backgroundColor = [UIColor yellowColor];
    [self.circleView addSubview:user3Area];
    self.user3Area = user3Area;
    UITapGestureRecognizer *tapGesturRecognizer3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user3Area.userInteractionEnabled = YES;
    [self.user3Area addGestureRecognizer:tapGesturRecognizer3];
    
    UIView *user4Area = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.user1Area.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
    //    user4Area.backgroundColor = [UIColor greenColor];
    [self.circleView addSubview:user4Area];
    self.user4Area = user4Area;
    UITapGestureRecognizer *tapGesturRecognizer4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user4Area.userInteractionEnabled = YES;
    [self.user4Area addGestureRecognizer:tapGesturRecognizer4];
    
    UIView *user5Area = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.user2Area.frame), CGRectGetMaxY(self.user3Area.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
    //    user5Area.backgroundColor = [UIColor blueColor];
    [self.circleView addSubview:user5Area];
    self.user5Area = user5Area;
    UITapGestureRecognizer *tapGesturRecognizer5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user5Area.userInteractionEnabled = YES;
    [self.user5Area addGestureRecognizer:tapGesturRecognizer5];
    
    UIView *user6Area = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.user4Area.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
//    user6Area.backgroundColor = [UIColor whiteColor];
    [self.circleView addSubview:user6Area];
    self.user6Area = user6Area;
    UITapGestureRecognizer *tapGesturRecognizer6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user6Area.userInteractionEnabled = YES;
    [self.user6Area addGestureRecognizer:tapGesturRecognizer6];
    
    UIView *user7Area = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.user6Area.frame), CGRectGetMaxY(self.user4Area.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
//    user7Area.backgroundColor = [UIColor brownColor];
    [self.circleView addSubview:user7Area];
    self.user7Area = user7Area;
    UITapGestureRecognizer *tapGesturRecognizer7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user7Area.userInteractionEnabled = YES;
    [self.user7Area addGestureRecognizer:tapGesturRecognizer7];
    
    UIView *user8Area = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.user7Area.frame), CGRectGetMaxY(self.user5Area.frame), MAIN_SCREEN_WIDTH/3, (self.circleView.bounds.size.height - CGRectGetMaxY(self.radiusLabel.frame))/3)];
//    user8Area.backgroundColor = [UIColor blackColor];
    [self.circleView addSubview:user8Area];
    self.user8Area = user8Area;
    UITapGestureRecognizer *tapGesturRecognizer8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCircleView)];
    self.user8Area.userInteractionEnabled = YES;
    [self.user8Area addGestureRecognizer:tapGesturRecognizer8];
    
    UIButton *filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.bounds) - 37.5, CGRectGetMidY(self.circleView.bounds) - 37.5, 75, 75)];
    filterBtn.imageView.layer.masksToBounds = YES;
    filterBtn.imageView.layer.cornerRadius = filterBtn.imageView.frame.size.width / 2;
    [self.circleView addSubview:filterBtn];
    self.filterBtn = filterBtn;
    [self.filterBtn addTarget:self action:@selector(sportFilterClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)clickRefreshBtn{
    
    NSInteger index = self.segSwitch.selectedSegmentIndex;
    if (index) {
        
        //    [self 加载数据];
        
        [self.user1 removeFromSuperview];
        [self.user2 removeFromSuperview];
        [self.user3 removeFromSuperview];
        [self.user4 removeFromSuperview];
        [self.user5 removeFromSuperview];
        [self.user6 removeFromSuperview];
        [self.user7 removeFromSuperview];
        [self.user8 removeFromSuperview];
        
        [self.bestSportImageView1 removeFromSuperview];
        [self.bestSportImageView2 removeFromSuperview];
        [self.bestSportImageView3 removeFromSuperview];
        [self.bestSportImageView4 removeFromSuperview];
        [self.bestSportImageView5 removeFromSuperview];
        [self.bestSportImageView6 removeFromSuperview];
        [self.bestSportImageView7 removeFromSuperview];
        [self.bestSportImageView8 removeFromSuperview];
        
        if (indexOfCurrentUser == _allUsers.count) {
            
            [self load4AllUser];
            
        } else {
            for(int i = 0; i < 8; i++) {
                if(indexOfCurrentUser == _allUsers.count) continue;
                self.currentUsers[i] = self.allUsers[indexOfCurrentUser];
                
                switch (i) {
                    case 0:
                        [self createUser1Btn];
                        break;
                    case 1:
                        [self createUser2Btn];
                        break;
                    case 2:
                        [self createUser3Btn];
                        break;
                    case 3:
                        [self createUser4Btn];
                        break;
                    case 4:
                        [self createUser5Btn];
                        break;
                    case 5:
                        [self createUser6Btn];
                        break;
                    case 6:
                        [self createUser7Btn];
                        break;
                    case 7:
                        [self createUser8Btn];
                        break;
                    default:
                        break;
                }
                indexOfCurrentUser++;
                [self refreshAnimation];
            }
        }
        
    } else {
        SNPublishViewController *publishVc = [[SNPublishViewController alloc]init];
        [self presentViewController:publishVc animated:YES completion:nil];
    }
    
}

-(void)refreshAnimation{
    
    __block WaterView *waterView = [[WaterView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.bounds) - 20, CGRectGetMidY(self.circleView.bounds) - 20, 40, 40)];
    
    waterView.backgroundColor = [UIColor clearColor];
    
    [self.circleView addSubview:waterView];
    
    [UIView animateWithDuration:4 animations:^{
        
        waterView.transform = CGAffineTransformScale(waterView.transform, 9, 9);
        waterView.alpha = 0;
    }completion:^(BOOL finished){
        [waterView removeFromSuperview];
    }];
    
    
    
    POPSpringAnimation *anim4FilterBtn = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim4FilterBtn.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
    anim4FilterBtn.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 75, 75)];
    anim4FilterBtn.springSpeed = 50.0;
    anim4FilterBtn.dynamicsFriction = 20.0;
    //震动的次数～约等于springBounciness－10
    anim4FilterBtn.springBounciness = 6;
    //震动的明显程度
    anim4FilterBtn.dynamicsMass = 10;
    
    [self.filterBtn.layer pop_addAnimation:anim4FilterBtn forKey:@"size"];
    
    
}

-(void)sportFilterClick{
    
    if (self.photoShowedOnFilterBtn) {
        //调用load画面
        //
        //        dispatch_group_t group = dispatch_group_create();
        //        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //
        //        dispatch_group_async(group, queue, ^{
        //            [self fetchUserByLocation];
        //            [self fetchCurrentUsersFromAllUsers];
        //        });
        //
        //        dispatch_group_async(group, dispatch_get_main_queue(), ^{
        //            [self showLoadView];
        //            self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshAnimation) userInfo:nil repeats:YES];
        //        });
        //
        //        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //            [self creatUserFromCurrentUsers];
        //            [self.filterBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
        //
        //        });
        
    } else {
        
        [self configreBlurView];
        [self addSportBtn];
        
        
        UIButton *filterBtnInBlurView = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.frame) - 37.5, CGRectGetMidY(self.circleView.frame) - 37.5, 75, 75)];
        [filterBtnInBlurView setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [self.blurView addSubview:filterBtnInBlurView];
        self.filterBtnInBlurView = filterBtnInBlurView;
        [self.filterBtnInBlurView addTarget:self action:@selector(removeBlurView) forControlEvents:UIControlEventTouchUpInside];
        
        [self beginAnimation];
        
    }
}

-(void)bestSportSelected:(id)sender{
    
    NSString *imageName = [[NSString alloc]init];
    
    switch (((UIButton*)sender).tag) {
        case BestSportsBasketball:
            imageName = @"basketballSelected";
            break;
        case BestSportsSoccer:
            imageName = @"soccerSelected";
            break;
        case BestSportsMuscle:
            imageName = @"muscleSelected";
            break;
        case BestSportsJogging:
            imageName = @"joggingSelected";
            break;
        case BestSportsYoga:
            imageName = @"yogaSelected";
            break;
        default:
            break;
    }
    
    [self.filterBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self removeBlurView];
    
    
    [self.user1 removeFromSuperview];
    [self.user2 removeFromSuperview];
    [self.user3 removeFromSuperview];
    [self.user4 removeFromSuperview];
    [self.user5 removeFromSuperview];
    [self.user6 removeFromSuperview];
    [self.user7 removeFromSuperview];
    [self.user8 removeFromSuperview];
    
    [self.bestSportImageView1 removeFromSuperview];
    [self.bestSportImageView2 removeFromSuperview];
    [self.bestSportImageView3 removeFromSuperview];
    [self.bestSportImageView4 removeFromSuperview];
    [self.bestSportImageView5 removeFromSuperview];
    [self.bestSportImageView6 removeFromSuperview];
    [self.bestSportImageView7 removeFromSuperview];
    [self.bestSportImageView8 removeFromSuperview];
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        
        //为了重置一下currentUsers，因为上面已经用相应的体育运动筛选了一遍，如果不重置，换其他运动的时候currentUsers就为空了。
        [self fetchUserByLocation];
        self.allUsers = [[LocalDataManager defaultManager]fetchUserFromList:self.allUsers withSportType:((UIView*)sender).tag];
        [self fetchCurrentUsersFromAllUsers];
        
        
    });
    
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [self showLoadView];
        self.loadingTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshAnimation) userInfo:nil repeats:YES];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (self.allUsers.count==0) {
            [self.loadingTimer setFireDate:[NSDate distantFuture]];
            
            UIAlertController *noUserAlertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Currently no one interested in this sport" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self load4AllUser];
                return;
            }];
            [noUserAlertController addAction:action];
            [self presentViewController:noUserAlertController animated:YES completion:nil];
            return;
        }
        [self creatUserFromCurrentUsers];
        [self.filterBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        
    });
    
    
}

-(void)allSportSelected {
    [self removeBlurView];
    [self.user1 removeFromSuperview];
    [self.user2 removeFromSuperview];
    [self.user3 removeFromSuperview];
    [self.user4 removeFromSuperview];
    [self.user5 removeFromSuperview];
    [self.user6 removeFromSuperview];
    [self.user7 removeFromSuperview];
    [self.user8 removeFromSuperview];
    
    [self.bestSportImageView1 removeFromSuperview];
    [self.bestSportImageView2 removeFromSuperview];
    [self.bestSportImageView3 removeFromSuperview];
    [self.bestSportImageView4 removeFromSuperview];
    [self.bestSportImageView5 removeFromSuperview];
    [self.bestSportImageView6 removeFromSuperview];
    [self.bestSportImageView7 removeFromSuperview];
    [self.bestSportImageView8 removeFromSuperview];
    
    
    [self load4AllUser];
    
}

-(void)showLoadView{
    
    self.refreshBtn.enabled = NO;
    [self.filterBtn setImage:[UIImage imageWithData:[[[AVUser currentUser]objectForKey:@"icon"]getData]] forState:UIControlStateNormal];
    self.filterBtn.imageView.layer.masksToBounds = YES;
    self.filterBtn.imageView.layer.cornerRadius = self.filterBtn.imageView.frame.size.width / 2.0;
    self.photoShowedOnFilterBtn = YES;
    
}

/**
 *  Add galaxy background image with animation
 */
-(void)setBackgroundGalaxy{
    UIImageView *galaxyImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgn"]];
    galaxyImageView.frame = CGRectMake(-50, -50, MAIN_SCREEN_WIDTH +100, MAIN_SCREEN_HEIGHT +100);
    //    galaxyImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIInterpolatingMotionEffect *xEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xEffect.minimumRelativeValue = [NSNumber numberWithFloat:50.0];
    xEffect.maximumRelativeValue = [NSNumber numberWithFloat:-50.0];
    
    UIInterpolatingMotionEffect *yEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yEffect.minimumRelativeValue = [NSNumber numberWithFloat:50.0];
    yEffect.maximumRelativeValue = [NSNumber numberWithFloat:-50.0];
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[xEffect,yEffect];
    [galaxyImageView addMotionEffect:group];
    [self.view addSubview:galaxyImageView];
    self.galaxyImageView = galaxyImageView;
}

/**
 *  add top button view
 */
-(void)addTopView{
    
    UIView *topBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, MAIN_SCREEN_WIDTH, 53)];
    //        topBtnView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topBtnView];
    self.topBtnView = topBtnView;
    
    
    NSArray *segName = [[NSArray alloc]initWithObjects:@"Discover",@"Nearby", nil];
    UISegmentedControl *seg = [[UISegmentedControl alloc]initWithItems:segName];
    seg.frame = CGRectMake(CGRectGetMidX(self.topBtnView.bounds) - 63, CGRectGetMinY(self.topBtnView.bounds) + 10, 126, 33);
    seg.selectedSegmentIndex = 1;
    seg.tintColor = [UIColor colorWithRed:53/255.0 green:183/255.0 blue:162/255.0 alpha:1.0];
    NSDictionary *attribute = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:53/255.0 green:183/255.0 blue:162/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName];
    [seg setTitleTextAttributes:attribute forState:UIControlStateNormal];
    NSDictionary *highlightAttribute = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:242 green:242 blue:242 alpha:1.0] forKey:NSForegroundColorAttributeName];
    [seg setTitleTextAttributes:highlightAttribute forState:UIControlStateSelected];
    [seg addTarget:self action:@selector(clickSegSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.topBtnView addSubview:seg];
    self.segSwitch = seg;
    
    
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.topBtnView.bounds) - 15 - 35, CGRectGetMinY(self.topBtnView.bounds) + 10, 35, 35)];
    refreshBtn.backgroundColor = [UIColor clearColor];
    [refreshBtn setImage:[UIImage imageNamed:@"nearbyRefresh"] forState:UIControlStateNormal];
    _isFinishLoad = YES;
    self.refreshBtn = refreshBtn;
    [self.refreshBtn addTarget:self action:@selector(clickRefreshBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.topBtnView addSubview:self.refreshBtn];
    
    UIButton *viewMyTimeLineBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.topBtnView.bounds) - 10, CGRectGetMinY(self.topBtnView.bounds) + 10, 150, 35)];
    viewMyTimeLineBtn.backgroundColor = [UIColor clearColor];
    [viewMyTimeLineBtn setTitle:@"My TimeLine" forState:UIControlStateNormal];
    [self.topBtnView addSubview:viewMyTimeLineBtn];
    self.viewMTLBtn = viewMyTimeLineBtn;
    [self.viewMTLBtn addTarget:self action:@selector(clickViewMTLBtn) forControlEvents:UIControlEventTouchUpInside];
    self.viewMTLBtn.hidden = YES;
    self.isMyTimeLine = NO;
    
}

-(void)clickViewMTLBtn{
    if (self.isMyTimeLine) {
        self.momentsUsers = [[SNMomentManager defaultManager]fetchAllUserMoments];
        [self.momentTableView reloadData];
        [self.viewMTLBtn setTitle:@"My TimeLine" forState:UIControlStateNormal];
        self.isMyTimeLine = NO;
    } else {
        self.momentsUsers = [[SNMomentManager defaultManager]fetchOnlyUserMoments];
        if (self.momentsUsers.count == 0) {
            UIAlertController *noMTLAlertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You didn't publish anything = =!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                return;
            }];
            [noMTLAlertController addAction:action];
            [self presentViewController:noMTLAlertController animated:YES completion:nil];
        }else{
            [self.momentTableView reloadData];
            [self.viewMTLBtn setTitle:@"All TimeLine" forState:UIControlStateNormal];
            self.isMyTimeLine = YES;
        }
    }
}

-(float)distanceFromPointA:(CGPoint)start toPointB:(CGPoint)end{
    float distance;
    CGFloat xDist = end.x - start.x;
    CGFloat yDist = end.y - start.y;
    distance = sqrtf((xDist * xDist) + (yDist * yDist));
    return distance;
}

-(void)randomUser1Coordinate{
    
    CGFloat xRange = self.user1Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user1Area.bounds.origin.x;
    self.x1 = xValue;
    
    CGFloat yRange = self.user1Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user1Area.bounds.origin.y;
    self.y1 = yValue;
    
}

-(void)randomUser2Coordinate{
    
    CGFloat xRange = self.user2Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user2Area.bounds.origin.x;
    self.x2 = xValue;
    
    CGFloat yRange = self.user2Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user2Area.bounds.origin.y;
    self.y2 = yValue;
    
}

-(void)randomUser3Coordinate{
    
    CGFloat xRange = self.user3Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user3Area.bounds.origin.x;
    self.x3 = xValue;
    
    CGFloat yRange = self.user3Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user3Area.bounds.origin.y;
    self.y3 = yValue;
    
}

-(void)randomUser4Coordinate{
    
    CGFloat xRange = self.user4Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user4Area.bounds.origin.x;
    self.x4 = xValue;
    
    CGFloat yRange = self.user4Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user4Area.bounds.origin.y;
    self.y4 = yValue;
    
}

-(void)randomUser5Coordinate{
    
    CGFloat xRange = self.user5Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user5Area.bounds.origin.x;
    self.x5 = xValue;
    
    CGFloat yRange = self.user5Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user5Area.bounds.origin.y;
    self.y5 = yValue;
    
}

-(void)randomUser6Coordinate{
    
    CGFloat xRange = self.user6Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user6Area.bounds.origin.x;
    self.x6 = xValue;
    
    CGFloat yRange = self.user6Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user6Area.bounds.origin.y;
    self.y6 = yValue;
    
}

-(void)randomUser7Coordinate{
    
    CGFloat xRange = self.user7Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user7Area.bounds.origin.x;
    self.x7 = xValue;
    
    CGFloat yRange = self.user7Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user7Area.bounds.origin.y;
    self.y7 = yValue;
    
}

-(void)randomUser8Coordinate{
    
    CGFloat xRange = self.user8Area.bounds.size.width;
    CGFloat xValue = arc4random_uniform(xRange - self.userR)+self.user8Area.bounds.origin.x;
    self.x8 = xValue;
    
    CGFloat yRange = self.user8Area.bounds.size.height;
    CGFloat yValue = arc4random_uniform(yRange - self.userR)+self.user8Area.bounds.origin.y;
    self.y8 = yValue;
    
}

-(void)rememberUser1OrignXY:(UIButton *)btn{
    self.x1 = btn.frame.origin.x;
    self.y1 = btn.frame.origin.y;
}

-(void)rememberUser2OrignXY:(UIButton *)btn{
    self.x2 = btn.frame.origin.x;
    self.y2 = btn.frame.origin.y;
}

-(void)rememberUser3OrignXY:(UIButton *)btn{
    self.x3 = btn.frame.origin.x;
    self.y3 = btn.frame.origin.y;
}

-(void)rememberUser4OrignXY:(UIButton *)btn{
    self.x4 = btn.frame.origin.x;
    self.y4 = btn.frame.origin.y;
}

-(void)rememberUser5OrignXY:(UIButton *)btn{
    self.x5 = btn.frame.origin.x;
    self.y5 = btn.frame.origin.y;
}

-(void)rememberUser6OrignXY:(UIButton *)btn{
    self.x6 = btn.frame.origin.x;
    self.y6 = btn.frame.origin.y;
}

-(void)rememberUser7OrignXY:(UIButton *)btn{
    self.x7 = btn.frame.origin.x;
    self.y7 = btn.frame.origin.y;
}

-(void)rememberUser8OrignXY:(UIButton *)btn{
    self.x8 = btn.frame.origin.x;
    self.y8 = btn.frame.origin.y;
}

-(void)showUserInfo:(AVObject*)userInfo {
    
    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    vc.delegate = self;
    vc.currentUserProfile = (SNUser*)userInfo;
    vc.isSearchNearBy = YES;
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(20, 50, SCREEN_WIDTH-40, SCREEN_HEIGHT-100);
    
    [self.blurView addSubview:vc.view];
    
//    NSLog(@"user name is %@", [userInfo objectForKey:@"name"]);
}

- (void) dragUser1Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user1Area];
    float dist1 = [self distanceFromPointA:CGPointMake(self.x1+self.userR/2, self.y1+self.userR/2) toPointB:c.center];
    self.dist1 = dist1;
    self.bestSportImageView1.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser2Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user2Area];
    float dist2 = [self distanceFromPointA:CGPointMake(self.x2+self.userR/2, self.y2+self.userR/2) toPointB:c.center];
    self.dist2 = dist2;
    self.bestSportImageView2.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser3Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user3Area];
    float dist3 = [self distanceFromPointA:CGPointMake(self.x3+self.userR/2, self.y3+self.userR/2) toPointB:c.center];
    self.dist3 = dist3;
    self.bestSportImageView3.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser4Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user4Area];
    float dist4 = [self distanceFromPointA:CGPointMake(self.x4+self.userR/2, self.y4+self.userR/2) toPointB:c.center];
    self.dist4 = dist4;
    self.bestSportImageView4.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser5Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user5Area];
    float dist5 = [self distanceFromPointA:CGPointMake(self.x5+self.userR/2, self.y5+self.userR/2) toPointB:c.center];
    self.dist5 = dist5;
    self.bestSportImageView5.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser6Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user6Area];
    float dist6 = [self distanceFromPointA:CGPointMake(self.x6+self.userR/2, self.y6+self.userR/2) toPointB:c.center];
    self.dist6 = dist6;
    self.bestSportImageView6.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser7Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user7Area];
    float dist7 = [self distanceFromPointA:CGPointMake(self.x7+self.userR/2, self.y7+self.userR/2) toPointB:c.center];
    self.dist7 = dist7;
    self.bestSportImageView7.center = CGPointMake(c.center.x + 25, c.center.y);
}

- (void) dragUser8Moving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self.user8Area];
    float dist8 = [self distanceFromPointA:CGPointMake(self.x8+self.userR/2, self.y8+self.userR/2) toPointB:c.center];
    self.dist8 = dist8;
    self.bestSportImageView8.center = CGPointMake(c.center.x + 25, c.center.y);
}

-(void)clickSegSwitch:(UISegmentedControl *)seg{
    
    
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self.circleView removeFromSuperview];
            [self.refreshBtn setImage:[UIImage imageNamed:@"vote"] forState:UIControlStateNormal];
            self.refreshBtn.enabled = YES;
            self.viewMTLBtn.hidden = NO;
            [self loadingMoments];
            [self addMomentView];
            
            break;
            
        case 1:
            [self.momentView removeFromSuperview];
            [self.refreshBtn setImage:[UIImage imageNamed:@"nearbyRefresh"] forState:UIControlStateNormal];
            if (indexOfCurrentUser == _allUsers.count) {
                self.refreshBtn.enabled = NO;
            }
            [self.viewMTLBtn setTitle:@"My TimeLine" forState:UIControlStateNormal];
            self.isMyTimeLine = NO;
            self.viewMTLBtn.hidden = YES;
            [self addCircleView];
            [self load4AllUser];
            
            break;
            
        default:
            break;
    }
}

//hide or show TabBar
-(void)tapCircleView{
    CGFloat offset = self.isTabBarHide ? -self.tabBarController.tabBar.bounds.size.height : self.tabBarController.tabBar.bounds.size.height;
    CGFloat y = self.tabBarController.tabBar.center.y + offset;
    
    
    if (self.isTabBarHide) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, y);
            self.isTabBarHide = NO;
        }];
        
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.tabBarController.tabBar.center = CGPointMake(self.tabBarController.tabBar.center.x, y);
            self.isTabBarHide = YES;
        }];
        
    }
    
}

-(void)addSportBtn{
    UIButton *basketballBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.frame) - 25, CGRectGetMidY(self.circleView.frame) - 25, 50, 50)];
    [basketballBtn setImage:[UIImage imageNamed:@"basketballSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:basketballBtn];
    self.basketballBtn = basketballBtn;
    self.basketballBtn.tag = BestSportsBasketball;
    [self.basketballBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *footballBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.frame) - 25, CGRectGetMidY(self.circleView.frame) - 25, 50, 50)];
    [footballBtn setImage:[UIImage imageNamed:@"soccerSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:footballBtn];
    self.footballBtn = footballBtn;
    self.footballBtn.tag = BestSportsSoccer;
    [self.footballBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fitnessBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.frame) - 25, CGRectGetMidY(self.circleView.frame) - 25, 50, 50)];
    [fitnessBtn setImage:[UIImage imageNamed:@"muscleSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:fitnessBtn];
    self.fitnessBtn = fitnessBtn;
    self.fitnessBtn.tag = BestSportsMuscle;
    [self.fitnessBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *runBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.frame) - 25, CGRectGetMidY(self.circleView.frame) - 25, 50, 50)];
    [runBtn setImage:[UIImage imageNamed:@"joggingSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:runBtn];
    self.runBtn = runBtn;
    self.runBtn.tag = BestSportsJogging;
    [self.runBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yogaBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.frame) - 25, CGRectGetMidY(self.circleView.frame) - 25, 50, 50)];
    [yogaBtn setImage:[UIImage imageNamed:@"yogaSelected"] forState:UIControlStateNormal];
    [self.blurView addSubview:yogaBtn];
    self.yogaBtn = yogaBtn;
    self.yogaBtn.tag = BestSportsYoga;
    [self.yogaBtn addTarget:self action:@selector(bestSportSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *allBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.circleView.frame) - 25, CGRectGetMidY(self.circleView.frame) - 25, 50, 50)];
    [allBtn setImage:[UIImage imageNamed:@"ALL"] forState:UIControlStateNormal];
    [self.blurView addSubview:allBtn];
    self.allBtn = allBtn;
    [self.allBtn addTarget:self action:@selector(allSportSelected) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) beginAnimation{
    /*篮球动画设置*/
    CAKeyframeAnimation *basketballAnimation = [CAKeyframeAnimation animation];
    basketballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *basketballPath = [UIBezierPath bezierPath];
    CGPoint originalPosition = self.basketballBtn.layer.position;
    CGFloat originalX = originalPosition.x;
    self.x0 = originalX;
    CGFloat originalY = originalPosition.y;
    self.y0 = originalY;
    [basketballPath moveToPoint:CGPointMake(originalX, originalY)];
    [basketballPath addQuadCurveToPoint:CGPointMake(originalX - R, originalY) controlPoint:CGPointMake(originalX-R/2, originalY + R)];
    basketballAnimation.path = basketballPath.CGPath;
    
    /*足球动画设置*/
    CAKeyframeAnimation *footballAnimation = [CAKeyframeAnimation animation];
    footballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *footballPath = [UIBezierPath bezierPath];
    [footballPath moveToPoint:CGPointMake(originalX, originalY)];
    [footballPath addQuadCurveToPoint:CGPointMake(originalX + R/2, originalY + R) controlPoint:CGPointMake(originalX + R, originalY)];
    footballAnimation.path = footballPath.CGPath;
    
    /*健身动画设置*/
    CAKeyframeAnimation *fitnessAnimation = [CAKeyframeAnimation animation];
    fitnessAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *fitnessPath = [UIBezierPath bezierPath];
    [fitnessPath moveToPoint:CGPointMake(originalX, originalY)];
    [fitnessPath addQuadCurveToPoint:CGPointMake(originalX - R/2, originalY + R) controlPoint:CGPointMake(originalX + R/2, originalY + R)];
    fitnessAnimation.path = fitnessPath.CGPath;
    
    /*跑步动画设置*/
    CAKeyframeAnimation *runAnimation = [CAKeyframeAnimation animation];
    runAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *runPath = [UIBezierPath bezierPath];
    [runPath moveToPoint:CGPointMake(originalX, originalY)];
    [runPath addQuadCurveToPoint:CGPointMake(originalX + R, originalY) controlPoint:CGPointMake(originalX + R/2, originalY - R)];
    runAnimation.path = runPath.CGPath;
    
    /*瑜伽动画设置*/
    CAKeyframeAnimation *yogaAnimation = [CAKeyframeAnimation animation];
    yogaAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *yogaPath = [UIBezierPath bezierPath];
    [yogaPath moveToPoint:CGPointMake(originalX, originalY)];
    [yogaPath addQuadCurveToPoint:CGPointMake(originalX + R/2, originalY - R) controlPoint:CGPointMake(originalX - R/2, originalY - R)];
    yogaAnimation.path = yogaPath.CGPath;
    
    /*ALL动画设置*/
    CAKeyframeAnimation *allAnimation = [CAKeyframeAnimation animation];
    allAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *allPath = [UIBezierPath bezierPath];
    [allPath moveToPoint:CGPointMake(originalX, originalY)];
    [allPath addQuadCurveToPoint:CGPointMake(originalX - R/2, originalY - R) controlPoint:CGPointMake(originalX - R, originalY)];
    allAnimation.path = allPath.CGPath;
    
    
    /*放大效果设置*/
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.keyPath = @"transform.scale";
    animation2.values = @[@(0.2),@(1.0)];
    /*透明度设置*/
    
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animation];
    animation3.keyPath = @"opacity";
    animation3.values = @[@(0.2),@(1.0)];
    
    /*篮球动画组*/
    CAAnimationGroup *basketballAnimationGroup = [CAAnimationGroup animation];
    basketballAnimationGroup.animations = @[basketballAnimation,animation2,animation3];
    basketballAnimationGroup.duration = 0.5;
    basketballAnimationGroup.repeatCount = 1;
    basketballAnimationGroup.removedOnCompletion = NO;
    basketballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.basketballBtn.layer addAnimation:basketballAnimationGroup forKey:nil];
    self.basketballBtn.center = CGPointMake(originalX - R, originalY);
    
    /*足球动画组*/
    CAAnimationGroup *footballAnimationGroup = [CAAnimationGroup animation];
    footballAnimationGroup.animations = @[footballAnimation,animation2,animation3];
    footballAnimationGroup.duration = 0.5;
    footballAnimationGroup.repeatCount = 1;
    footballAnimationGroup.removedOnCompletion = NO;
    footballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.footballBtn.layer addAnimation:footballAnimationGroup forKey:nil];
    self.footballBtn.center = CGPointMake(originalX + R/2, originalY + R);
    
    /*健身动画组*/
    CAAnimationGroup *fitnessAnimationGroup = [CAAnimationGroup animation];
    fitnessAnimationGroup.animations = @[fitnessAnimation,animation2,animation3];
    fitnessAnimationGroup.duration = 0.5;
    fitnessAnimationGroup.repeatCount = 1;
    fitnessAnimationGroup.removedOnCompletion = NO;
    fitnessAnimationGroup.fillMode = kCAFillModeForwards;
    [self.fitnessBtn.layer addAnimation:fitnessAnimationGroup forKey:nil];
    self.fitnessBtn.center = CGPointMake(originalX - R/2, originalY + R);
    
    /*跑步动画组*/
    CAAnimationGroup *runAnimationGroup = [CAAnimationGroup animation];
    runAnimationGroup.animations = @[runAnimation,animation2,animation3];
    runAnimationGroup.duration = 0.5;
    runAnimationGroup.repeatCount = 1;
    runAnimationGroup.removedOnCompletion = NO;
    runAnimationGroup.fillMode = kCAFillModeForwards;
    [self.runBtn.layer addAnimation:runAnimationGroup forKey:nil];
    self.runBtn.center = CGPointMake(originalX + R, originalY);
    
    /*瑜伽动画组*/
    CAAnimationGroup *yogaAnimationGroup = [CAAnimationGroup animation];
    yogaAnimationGroup.animations = @[yogaAnimation,animation2,animation3];
    yogaAnimationGroup.duration = 0.5;
    yogaAnimationGroup.repeatCount = 1;
    yogaAnimationGroup.removedOnCompletion = NO;
    yogaAnimationGroup.fillMode = kCAFillModeForwards;
    [self.yogaBtn.layer addAnimation:yogaAnimationGroup forKey:nil];
    self.yogaBtn.center = CGPointMake(originalX + R/2, originalY - R);
    
    /*ALL动画组*/
    CAAnimationGroup *allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = @[allAnimation,animation2,animation3];
    allAnimationGroup.duration = 0.5;
    allAnimationGroup.repeatCount = 1;
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    [self.allBtn.layer addAnimation:allAnimationGroup forKey:nil];
    self.allBtn.center = CGPointMake(originalX - R/2, originalY - R);
    
}

-(void) endAnimation{
    /*篮球动画设置*/
    CAKeyframeAnimation *basketballAnimation = [CAKeyframeAnimation animation];
    basketballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *basketballPath = [UIBezierPath bezierPath];
    CGPoint originalPosition1 = self.basketballBtn.layer.position;
    CGFloat originalX1 = originalPosition1.x;
    CGFloat originalY1 = originalPosition1.y;
    [basketballPath moveToPoint:CGPointMake(originalX1, originalY1)];
    [basketballPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0-R/2, self.y0 + R)];
    basketballAnimation.path = basketballPath.CGPath;
    
    /*足球动画设置*/
    CAKeyframeAnimation *footballAnimation = [CAKeyframeAnimation animation];
    footballAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *footballPath = [UIBezierPath bezierPath];
    CGPoint originalPosition2 = self.footballBtn.layer.position;
    CGFloat originalX2 = originalPosition2.x;
    CGFloat originalY2 = originalPosition2.y;
    [footballPath moveToPoint:CGPointMake(originalX2, originalY2)];
    [footballPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 + R, self.y0)];
    footballAnimation.path = footballPath.CGPath;
    
    /*健身动画设置*/
    CAKeyframeAnimation *fitnessAnimation = [CAKeyframeAnimation animation];
    fitnessAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *fitnessPath = [UIBezierPath bezierPath];
    CGPoint originalPosition3 = self.fitnessBtn.layer.position;
    CGFloat originalX3 = originalPosition3.x;
    CGFloat originalY3 = originalPosition3.y;
    [fitnessPath moveToPoint:CGPointMake(originalX3, originalY3)];
    [fitnessPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 + R/2, self.y0 + R)];
    fitnessAnimation.path = fitnessPath.CGPath;
    
    /*跑步动画设置*/
    CAKeyframeAnimation *runAnimation = [CAKeyframeAnimation animation];
    runAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *runPath = [UIBezierPath bezierPath];
    CGPoint originalPosition4 = self.runBtn.layer.position;
    CGFloat originalX4 = originalPosition4.x;
    CGFloat originalY4 = originalPosition4.y;
    [runPath moveToPoint:CGPointMake(originalX4, originalY4)];
    [runPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 + R/2, self.y0 - R)];
    runAnimation.path = runPath.CGPath;
    
    /*瑜伽动画设置*/
    CAKeyframeAnimation *yogaAnimation = [CAKeyframeAnimation animation];
    yogaAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *yogaPath = [UIBezierPath bezierPath];
    CGPoint originalPosition5 = self.yogaBtn.layer.position;
    CGFloat originalX5 = originalPosition5.x;
    CGFloat originalY5 = originalPosition5.y;
    [yogaPath moveToPoint:CGPointMake(originalX5, originalY5)];
    [yogaPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 - R/2, self.y0 - R)];
    yogaAnimation.path = yogaPath.CGPath;
    
    /*ALL动画设置*/
    CAKeyframeAnimation *allAnimation = [CAKeyframeAnimation animation];
    allAnimation.keyPath = @"position";
    
    //BezierPath
    UIBezierPath *allPath = [UIBezierPath bezierPath];
    CGPoint originalPosition6 = self.allBtn.layer.position;
    CGFloat originalX6 = originalPosition6.x;
    CGFloat originalY6 = originalPosition6.y;
    [allPath moveToPoint:CGPointMake(originalX6, originalY6)];
    [allPath addQuadCurveToPoint:CGPointMake(self.x0, self.y0) controlPoint:CGPointMake(self.x0 - R, self.y0)];
    allAnimation.path = allPath.CGPath;
    
    
    /*放大效果设置*/
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animation];
    animation2.keyPath = @"transform.scale";
    animation2.values = @[@(1.0),@(0.2)];
    
    /*透明度设置*/
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animation];
    animation3.keyPath = @"opacity";
    animation3.values = @[@(1.0),@(0.2)];
    
    /*篮球动画组*/
    CAAnimationGroup *basketballAnimationGroup = [CAAnimationGroup animation];
    basketballAnimationGroup.animations = @[basketballAnimation,animation2,animation3];
    basketballAnimationGroup.duration = 0.5;
    basketballAnimationGroup.repeatCount = 1;
    basketballAnimationGroup.removedOnCompletion = NO;
    basketballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.basketballBtn.layer addAnimation:basketballAnimationGroup forKey:nil];
    
    /*足球动画组*/
    CAAnimationGroup *footballAnimationGroup = [CAAnimationGroup animation];
    footballAnimationGroup.animations = @[footballAnimation,animation2,animation3];
    footballAnimationGroup.duration = 0.5;
    footballAnimationGroup.repeatCount = 1;
    footballAnimationGroup.removedOnCompletion = NO;
    footballAnimationGroup.fillMode = kCAFillModeForwards;
    [self.footballBtn.layer addAnimation:footballAnimationGroup forKey:nil];
    
    /*健身动画组*/
    CAAnimationGroup *fitnessAnimationGroup = [CAAnimationGroup animation];
    fitnessAnimationGroup.animations = @[fitnessAnimation,animation2,animation3];
    fitnessAnimationGroup.duration = 0.5;
    fitnessAnimationGroup.repeatCount = 1;
    fitnessAnimationGroup.removedOnCompletion = NO;
    fitnessAnimationGroup.fillMode = kCAFillModeForwards;
    [self.fitnessBtn.layer addAnimation:fitnessAnimationGroup forKey:nil];
    
    /*跑步动画组*/
    CAAnimationGroup *runAnimationGroup = [CAAnimationGroup animation];
    runAnimationGroup.animations = @[runAnimation,animation2,animation3];
    runAnimationGroup.duration = 0.5;
    runAnimationGroup.repeatCount = 1;
    runAnimationGroup.removedOnCompletion = NO;
    runAnimationGroup.fillMode = kCAFillModeForwards;
    [self.runBtn.layer addAnimation:runAnimationGroup forKey:nil];
    
    /*瑜伽动画组*/
    CAAnimationGroup *yogaAnimationGroup = [CAAnimationGroup animation];
    yogaAnimationGroup.animations = @[yogaAnimation,animation2,animation3];
    yogaAnimationGroup.duration = 0.5;
    yogaAnimationGroup.repeatCount = 1;
    yogaAnimationGroup.removedOnCompletion = NO;
    yogaAnimationGroup.fillMode = kCAFillModeForwards;
    [self.yogaBtn.layer addAnimation:yogaAnimationGroup forKey:nil];
    
    /*ALL动画组*/
    CAAnimationGroup *allAnimationGroup = [CAAnimationGroup animation];
    allAnimationGroup.animations = @[allAnimation,animation2,animation3];
    allAnimationGroup.duration = 0.5;
    allAnimationGroup.repeatCount = 1;
    allAnimationGroup.removedOnCompletion = NO;
    allAnimationGroup.fillMode = kCAFillModeForwards;
    [self.allBtn.layer addAnimation:allAnimationGroup forKey:nil];
    
}

-(void)configreBlurView {
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
    //设置模糊透明度
    effectView.alpha = 0.9f;
    [self.view addSubview:effectView];
    self.blurView = effectView;
    
}

-(void)removeBlurView{
    
    [self endAnimation];
    [self performSelector:@selector(removeBlurViewSelector) withObject:nil afterDelay:0.5f];
    
}

-(void)removeBlurViewSelector{
    [self.blurView removeFromSuperview];
}

- (CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精度设置
        _locationManager.distanceFilter = 1.0f;//设备移动后获得位置信息的最小距离
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
        //        [_locationManager requestAlwaysAuthorization];//始终授权
    }
    return _locationManager;
}

//定位成功时调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currlocation = [locations lastObject];//获取当前位置
    self.longitude = self.currlocation.coordinate.longitude;//获取经度
    self.latitude = self.currlocation.coordinate.latitude;//获取纬度
//    NSLog(@"%f %f",self.longitude, self.latitude);
    AVGeoPoint *currentUserLocation = [AVGeoPoint geoPointWithLatitude:self.latitude longitude:self.longitude];
    self.currentUserLocation = currentUserLocation;
    
    AVQuery *query = [SNUser query];
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    NSArray *fetchObjects = [query findObjects];
    if(fetchObjects.count == 0) return;
    SNUser *basicInfo = fetchObjects[0];
    [basicInfo setObject:self.currentUserLocation forKey:@"GeoLocation"];
    [basicInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSLog(@"error %@", error.description);
    }];
    [self.locationManager stopUpdatingLocation];
    
}

//定位失败调用
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//        NSLog(@"%ld 调用失败",(long)error.code);
    
    [manager stopUpdatingLocation];
    switch((long)error.code) {
        case 1:{
            //定位没打开
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Access to Location Services denied by user" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
        case kCLErrorLocationUnknown:
            //@"Location data unavailable";
            break;
        default:
            //@"An unknown error has occurred";
            break;
    }
    
    
}

//授权状态发生变化调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (!status) {
//                NSLog(@"请打开定位");
        [self.locationManager requestWhenInUseAuthorization];
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(NSMutableArray *)neverSeeAgain{
    if (_neverSeeAgain==nil) {
        _neverSeeAgain=[[NSMutableArray alloc]init];
    }
    return _neverSeeAgain;
}

-(void)didClickCrossButton {
    [self.blurView removeFromSuperview];
}

//add moment UIView
-(void)addMomentView{
    
    UIView *momentView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBtnView.frame), MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT-self.topBtnView.frame.size.height - 60)];
    //    momentView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:momentView];
    self.momentView = momentView;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(self.momentView.bounds.origin.x, self.momentView.bounds.origin.y, self.momentView.bounds.size.width, self.momentView.bounds.size.height)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.allowsSelection = NO;
    [self.momentView addSubview:table];
    self.momentTableView = table;
    self.momentTableView.backgroundColor = [UIColor clearColor];
    self.momentTableView.separatorColor = [UIColor clearColor];
    self.momentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refleshMoments];
    }];
    
    [self.momentTableView registerNib:[UINib nibWithNibName:@"SNFriendsShareCell" bundle:nil] forCellReuseIdentifier:@"FriendsShareCell"];
    
}

-(void)loadingMoments {
    
    self.momentsUsers = [[SNMomentManager defaultManager]fetchAllUserMoments];
    
    
}

- (NSMutableArray *)momentsUsers {
    
    if (_momentsUsers == nil) {
        
        _momentsUsers = [NSMutableArray array];
        
    }
    
    return _momentsUsers;
}

#pragma tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.momentsUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SNFriendsShareCell *cell = [self.momentTableView dequeueReusableCellWithIdentifier:@"FriendsShareCell"];
    FriendsMomentModel *momentModel = self.momentsUsers[indexPath.row];
    cell.momentModel = momentModel;
    cell.Delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 442;
}

#pragma mark - TableView HeaderReflesh
- (void)refleshMoments {
    
    [self.momentTableView.mj_header beginRefreshing];
    
    [self loadingMoments];
    
    [self.momentTableView reloadData];
    
    [self.momentTableView.mj_header endRefreshing];
    
}

#pragma mark - SNPublishViewControllerDelegate
- (void)publishSuccessful {
    [ProgressHUD show:@"Loading..."];
    [self loadingMoments];
    [self.momentTableView reloadData];
    [ProgressHUD dismiss];
}

#pragma SNMomentMangerDelegate
- (void)enterAlertView{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Are you sure to report this user?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString *mailUrl = [[NSMutableString alloc]init];
        //添加收件人
        NSArray *toRecipients = @[@"info@spornetapp.com"];
        [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
        //添加主题
        [mailUrl appendString:@"?subject=Report"];
        //添加邮件内容
        [mailUrl appendString:@"&body=<b>Please fillout the user name and the reason why you report this user</b>"];
        NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
        
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:yesAction];
    [alertVC addAction:noAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
