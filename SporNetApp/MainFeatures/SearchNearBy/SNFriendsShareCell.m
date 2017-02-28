//
//  SNFriendsShareCell.m
//  SporNetApp
//
//  Created by Peng on 1/2/17.
//  Copyright © 2017 Peng Wang. All rights reserved.
//

#import "SNFriendsShareCell.h"
#import "TimeManager.h"
#import "UIImageView+WebCache.h"


@interface SNFriendsShareCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *UserProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *UserSportTypePic;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *UserLatestStatusTime;
@property (weak, nonatomic) IBOutlet UILabel *UserPopularityCount;
@property (weak, nonatomic) IBOutlet UITextView *UserStatus;
@property (weak, nonatomic) IBOutlet UIScrollView *UserSharedPhotoes;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *UserProfileImageBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic, strong) NSNumber *likedNumber;

@end

@implementation SNFriendsShareCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.UserProfileImageBackgroundView.layer setCornerRadius:28];
    self.UserProfileImageBackgroundView.clipsToBounds = YES;
    self.UserProfileImage.clipsToBounds = YES;
    [self.UserProfileImage.layer setCornerRadius:25];
    
    self.UserSharedPhotoes.delegate = self;

}

- (void)setMomentModel:(FriendsMomentModel *)momentModel {
    
    _momentModel = momentModel;
    self.likedNumber = [momentModel objectForKey:@"Liked"];
    [self.UserSharedPhotoes.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj removeFromSuperview];
        
    }];
    NSArray *likedUsers = [momentModel objectForKey:@"LikedUsers"];
    
    if (likedUsers.count == 0) {
        
        self.likeBtn.selected = NO;
        self.likeBtn.userInteractionEnabled = YES;

    }else {
        
        for (NSString *userID in likedUsers) {
            
            if ([userID isEqualToString:SELF_ID]) {
                
                self.likeBtn.selected = YES;
                self.likeBtn.userInteractionEnabled = NO;
                break;
            }
        }
    }
    
    NSString *userID = [momentModel objectForKey:@"UserID"];
    AVObject *userOJ = [AVObject objectWithClassName:@"SNUser" objectId:userID];
    
    [userOJ fetchInBackgroundWithBlock:^(AVObject * _Nullable userOJ, NSError * _Nullable error) {
        
        self.UserProfileImage.image = [UIImage imageWithData:[(AVFile*)[userOJ objectForKey:@"icon"]getData]];
        self.UserProfileImageBackgroundView.backgroundColor = SPORTSLOT_COLOR_ARRAY[[[userOJ objectForKey:@"sportTimeSlot"]integerValue]];
        NSInteger sportInt = [[userOJ objectForKey:@"bestSport"]integerValue] - 1;
        self.UserSportTypePic.image =(UIImage *)BEST_SPORT_IMAGE_ARRAY[sportInt];
        self.UserName.text = [userOJ objectForKey:@"name"];
        self.UserStatus.text = [momentModel objectForKey:@"MomentStatus"];
        self.UserStatus.textColor = [UIColor whiteColor]; 
        self.UserLatestStatusTime.text = [TimeManager getTimeLabelString:[momentModel objectForKey:@"createdAt"] refreshTime:[NSDate date]];
        self.UserPopularityCount.text = [self.likedNumber stringValue];
        NSArray *imagesUrls = [momentModel objectForKey:@"MomentsPhotoArray"];
        CGFloat xPos = 0.0;
        
        self.pageControl.numberOfPages = imagesUrls.count;
        self.UserSharedPhotoes.contentSize = CGSizeMake(SCREEN_WIDTH * imagesUrls.count, self.UserSharedPhotoes.frame.size.height*0.2);
        for(NSString *url in imagesUrls) {
            
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(xPos, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT*0.33);
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.UserSharedPhotoes addSubview:imageView];
            
//            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (error) {
//                    NSLog(@"%@", error.description);
//                }
//                [self.photoArray addObject:image];
//                [imageView setContentMode:UIViewContentModeScaleAspectFit];
//                imageView.frame = CGRectMake(xPos, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT*0.33);
//                [self.UserSharedPhotoes addSubview:imageView];
//            }];
            xPos += SCREEN_WIDTH;
        }
    }];
    
    
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = self.UserSharedPhotoes.contentOffset.x / SCREEN_WIDTH;
}

- (IBAction)likedClicked:(UIButton *)sender {
    
    sender.selected = YES; 
    NSInteger newLiked = self.likedNumber.integerValue + 1;
    self.UserPopularityCount.text = [NSString stringWithFormat:@"%ld",(long)newLiked];
    [self.momentModel setObject:[NSNumber numberWithInteger:newLiked] forKey:@"Liked"];
    [self.momentModel addObject:SELF_ID forKey:@"LikedUsers"]; 
    [self.momentModel saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
//            NSLog(@"%@", error.description); 
        }
        
        NSString *objectID = [self.momentModel objectForKey:@"UserID"];
        
        AVObject *userObj = [AVObject objectWithClassName:@"SNUser" objectId:objectID];
        [userObj fetchInBackgroundWithBlock:^(AVObject * _Nullable userObj, NSError * _Nullable error) {
            
            NSInteger totalNum = [[userObj objectForKey:@"voteNumber"]integerValue];
            
            totalNum ++;
            
            [userObj setObject:[NSNumber numberWithInteger:totalNum] forKey:@"voteNumber"];
            [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
//                    NSLog(@"error %@", error.description);
                }
                
            }];
        }];
    }];
    
    sender.userInteractionEnabled = NO;
}

- (IBAction)reportClicked {
    [self.Delegate enterAlertView];
    
}

@end











