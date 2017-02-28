//
//  SNTagCell.h
//  SporNetApp
//
//  Created by 浦明晖 on 7/28/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVObject.h"
@interface SNTagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCheckinTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userSelectedSportLabel;
-(void)configureCellWithCheckinInfo:(AVObject*)checkinObject;
@end
