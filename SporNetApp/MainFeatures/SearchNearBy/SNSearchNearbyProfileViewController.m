//
//  SNSearchNearbyProfileViewController.m
//  SporNetApp
//
//  Created by Peng Wang on 8/3/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNSearchNearbyProfileViewController.h"
#import "TimeManager.h"
#import "SNUser.h"
#import "ViewBigPhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "MessageManager.h"

@interface SNSearchNearbyProfileViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboutMeHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraintHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *contentImageScrollView;

@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolButton;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UILabel *gradYearLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (nonatomic,assign) CGFloat x;

@property NSMutableArray *currentImages;
@end

@implementation SNSearchNearbyProfileViewController
NSInteger width;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scrollView setContentSize:CGSizeMake(0, self.scrollView.contentSize.height)];
    self.scrollView.scrollEnabled = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self loadUserProfile];
    [self.contentImageScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewBigPicture)]];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    self.voteNumberLabel.text = [NSString stringWithFormat:@"%d",(int) [[self.currentUserProfile objectForKey:@"voteNumber"]integerValue]];
    if([[[AVUser currentUser]objectForKey:@"votedPeople"]containsObject:[self.currentUserProfile objectForKey:@"userID"]]) {
        self.voteButton.backgroundColor = [UIColor lightGrayColor];
        self.voteButton.userInteractionEnabled = NO;
    }
    
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (IBAction)moreInfoButtonClicked:(UIButton *)sender {
    self.scrollView.scrollEnabled = YES;
    self.moreInfoButton.hidden = YES;
    self.aboutMeHeight.constant = SCREEN_HEIGHT*0.1 + self.aboutMeLabel.frame.size.height;
    self.contentViewBottomConstraint.constant = SCREEN_HEIGHT * 0.2 + 20 + _aboutMeLabel.frame.size.height;
}
-(void)loadUserProfile {
    if (self.isSearchNearBy) {
        self.x = SCREEN_WIDTH-40;
    } else {
        self.x = SCREEN_WIDTH;
    }
    
    
    self.firstNameLabel.text = [self.currentUserProfile objectForKey:@"name"];
    self.aboutMeLabel.text = [self.currentUserProfile objectForKey:@"aboutMe"];
    self.schoolButton.text = [self.currentUserProfile objectForKey:@"school"];
    self.ageLabel.text = [NSString stringWithFormat:@"%ld", (long)[TimeManager calculateAgeByBirthday:[self.currentUserProfile objectForKey:@"dateOfBirth"]]];
    self.sportTimeLabel.text = SPORTSLOT_ARRAY[[[self.currentUserProfile objectForKey:@"sportTimeSlot"] integerValue]];
    self.gradYearLabel.text = [NSString stringWithFormat:@"%d",(int) [[self.currentUserProfile objectForKey:@"gradYear"] integerValue]];
    self.imageConstraintHeight.constant = SCREEN_HEIGHT*0.33;
    
    //set user profile images
    NSArray *imagesUrls = [self.currentUserProfile objectForKey:@"PicUrls"];
    CGFloat xPos;
    self.currentImages = [[NSMutableArray alloc]init];
    if(imagesUrls.count == 0) {
        
        return;
        
    }
    
    self.pageControl.numberOfPages = imagesUrls.count;
    self.contentImageScrollView.contentSize = CGSizeMake(self.x * imagesUrls.count, self.contentImageScrollView.frame.size.height*0.2);
    for(NSString *url in imagesUrls) {
//        NSLog(@"url is %@", url);
    
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.currentImages addObject:image];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            imageView.frame = CGRectMake(xPos, 0.0, self.x, SCREEN_HEIGHT*0.33);
            [self.contentImageScrollView addSubview:imageView];
        }];
        xPos += self.x;
    }
    
}
- (IBAction)voteButtonClicked:(UIButton *)sender {
    
    NSInteger voteNumber = [[self.currentUserProfile objectForKey:@"voteNumber"]integerValue];
    self.voteNumberLabel.text = [NSString stringWithFormat:@"%ld", (long)voteNumber + 1];
    [self.currentUserProfile setObject:[NSNumber numberWithInteger:voteNumber + 1] forKey:@"voteNumber"];
    [self.currentUserProfile saveInBackground];
    
    [[AVUser currentUser]addObject:[self.currentUserProfile objectForKey:@"userID"] forKey:@"votedPeople"];
    [[AVUser currentUser]saveInBackground];
    [self.voteButton setTitle:@"VOTED" forState:UIControlStateNormal];
    self.voteButton.backgroundColor = [UIColor lightGrayColor];
    self.voteButton.userInteractionEnabled = NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.contentImageScrollView.contentOffset.x / self.x;
}
-(void)viewBigPicture {
    ViewBigPhotoViewController *vc = [[ViewBigPhotoViewController alloc]init];
    vc.pictures = self.currentImages;
    vc.currentImageIndex = self.pageControl.currentPage;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)crossButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if ([self.delegate respondsToSelector:@selector(didClickCrossButton)]) {
        
        [self.delegate didClickCrossButton];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)addFriendButtonClicked:(UIButton *)sender {
    
//    if (self.isFromNotication) {
//        
//        [[MessageManager defaultManager]acceptFriendRequest:self.currentUserCon];
//        self.isFromNotication = NO; 
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }else {
//        
//        AVObject *myself = [AVObject objectWithClassName:@"SNUser" objectId:SELF_ID];
//        [myself fetch];
//        NSArray *myfriendsList = [myself objectForKey:@"MyFriends"];
//        
//        if ([myfriendsList containsObject:self.currentUserProfile.objectId]) {
//            
//            [ProgressHUD showError:@"This is your friend already"];
//            [self.navigationController popViewControllerAnimated:YES];
//            
//            
//        }else {
//            
//            [[MessageManager defaultManager]sendAddFrendRequst:self.currentUserProfile.objectId];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        
//    }
//    
    
    
    if (self.isFromNotication) {
        
        [[MessageManager defaultManager]acceptFriendRequest:self.currentUserCon];
        self.isFromNotication = NO;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        AVObject *myself = [AVObject objectWithClassName:@"SNUser" objectId:SELF_ID];
        [myself fetch];
        NSArray *myfriendsList = [myself objectForKey:@"MyFriends"];
        NSArray *blockList = [myself objectForKey:@"MyBlocks"];
        
        if ([myfriendsList containsObject:self.currentUserProfile.objectId]) {
            
            [ProgressHUD showError:@"This is your friend already"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else if ([blockList containsObject:self.currentUserProfile.objectId]) {
            
            [ProgressHUD showError:@"This person blocked you"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            
            [[MessageManager defaultManager]sendAddFrendRequst:self.currentUserProfile.objectId];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
}


    
    

@end
