//
//  ChatCell.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "ChatCell.h"
#import "TimeManager.h"
#import "NSDate+DateTools.h"
#define timeLabelBGColor [UIColor colorWithRed:200 green:200 blue:200 alpha:1]
#define timeLabelFont [UIFont systemFontOfSize:13]
#define textButtonFont [UIFont systemFontOfSize:15]
#define marginFromIconToLeftEdge 10
#define marginFromIconToTopEdge 18
#define marginFromBubbleToIcon 10
#define iconWidth 40
#define bestSportImageWidth 15
#define timeLabelWidth 200
#define insetToBubbleEdge 30
@implementation ChatCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _userImageView = [[UIImageView alloc]init];
    
    _textButton = [[UIButton alloc]init];
    _timeLabel = [[UILabel alloc]init];
    _indicator = [[UIActivityIndicatorView alloc]init];
    _bestSportImageView = [[UIImageView alloc]init];
    self.showTimeLabel = NO;
    
}

-(void)configureCellWithMessage:(AVIMMessage*)message previousMessage:(AVIMMessage *)previousMessage receiver:(AVObject*)receiver loadingStatus:(BOOL)alreadySent{
    if(previousMessage == nil) self.showTimeLabel = YES;
    else  {
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000.0];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:previousMessage.sendTimestamp / 1000.0];
    
        if ([date1 secondsFrom:date2] >= 60) self.showTimeLabel = YES;
        else self.showTimeLabel = NO;
    }
    
    
    self.timeLabel.frame = self.showTimeLabel?CGRectMake(0, 0, timeLabelWidth, 15):CGRectMake(0, 0, 0, 0);
    self.timeLabel.font = timeLabelFont;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.center = CGPointMake(SCREEN_WIDTH / 2,10);
    self.timeLabel.text =[TimeManager getConvastionTimeStr: [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000]];
    self.timeLabel.textColor = [UIColor darkGrayColor];
    self.timeLabel.backgroundColor = timeLabelBGColor;
    self.timeLabel.layer.masksToBounds = YES;
    [self.timeLabel.layer setCornerRadius:0.2];
    [self.contentView addSubview:self.timeLabel];
    
    NSString *text = [(AVIMTypedMessage*)message text];
    CGSize contentStrSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:17.0]}
                                               context:nil].size;
    
    if(message.ioType == AVIMMessageIOTypeIn) {
        //add user image with time slot circle
        _userImageView.frame = CGRectMake(marginFromIconToLeftEdge, self.timeLabel.frame.size.height + marginFromIconToTopEdge, iconWidth, iconWidth);
        self.userImageView.image = [UIImage imageWithData:[[receiver objectForKey:@"icon"]getData]];
        [[_userImageView layer] setBorderWidth:2.0f];
        UIColor *color = SPORTSLOT_COLOR_ARRAY[[[receiver objectForKey:@"sportTimeSlot"]integerValue]];
        [_userImageView.layer setBorderColor:color.CGColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2.0;
        //add user's best sport image
        _bestSportImageView.frame = CGRectMake(0, 0, bestSportImageWidth, bestSportImageWidth);
        _bestSportImageView.center = CGPointMake(_userImageView.center.x + iconWidth * 0.35, _userImageView.center.y - iconWidth * 0.3);
        _bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[receiver objectForKey:@"bestSport"]integerValue]]];
        //set message content
        _textButton.frame = CGRectMake(marginFromIconToLeftEdge + marginFromBubbleToIcon + iconWidth, self.timeLabel.frame.size.height + marginFromIconToTopEdge, contentStrSize.width + insetToBubbleEdge, contentStrSize.height + 10);
        _textButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(40, 15, 0, 5);
        UIImage *backgroundButtonImage = [[UIImage imageNamed:@"messageBubbleLeft"]
                                          resizableImageWithCapInsets:edgeInsets];
        [self.textButton setBackgroundImage:backgroundButtonImage
                                   forState:UIControlStateNormal];

    }
    else  {
        _userImageView.frame = CGRectMake(SCREEN_WIDTH - marginFromIconToLeftEdge - iconWidth, self.timeLabel.frame.size.height + marginFromIconToTopEdge, iconWidth, iconWidth);
        self.userImageView.image = [UIImage imageWithData:[[[AVUser currentUser] objectForKey:@"icon"]getData]];
        [[_userImageView layer] setBorderWidth:2.0f];
        UIColor *color = SPORTSLOT_COLOR_ARRAY[[[[AVUser currentUser] objectForKey:@"sportTimeSlot"]integerValue]];
        [_userImageView.layer setBorderColor:color.CGColor];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2.0;
        
        //add user's best sport image
        _bestSportImageView.frame = CGRectMake(0, 0, bestSportImageWidth, bestSportImageWidth);
        _bestSportImageView.center = CGPointMake(_userImageView.center.x + iconWidth * 0.35, _userImageView.center.y - iconWidth * 0.3);
        _bestSportImageView.image = [UIImage imageNamed:BESTSPORT_IMAGE_ARRAY[[[[AVUser currentUser] objectForKey:@"bestSport"]integerValue]]];
        
        _textButton.frame = CGRectMake(SCREEN_WIDTH - marginFromIconToLeftEdge - marginFromBubbleToIcon - insetToBubbleEdge - iconWidth- contentStrSize.width, self.timeLabel.frame.size.height + marginFromIconToTopEdge, contentStrSize.width + insetToBubbleEdge, contentStrSize.height + 10);
        //_textButton.backgroundColor = [UIColor greenColor];
        _textButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(40, 5, 0, 15);
        UIImage *backgroundButtonImage = [[UIImage imageNamed:@"messageBubbleRight"]
                                          resizableImageWithCapInsets:edgeInsets];
        [self.textButton setBackgroundImage:backgroundButtonImage
                                   forState:UIControlStateNormal];
        self.indicator.frame = CGRectMake(0, 0, 20, 20);
        self.indicator.center = CGPointMake(-23, _textButton.frame.size.height / 2.0);
        if(!alreadySent) {
            self.indicator.color = [UIColor redColor];
            [self.indicator startAnimating];
        } else {
            [self.indicator stopAnimating];
        }

    }
    [self addSubview:self.bestSportImageView];
    self.textButton.titleLabel.numberOfLines = 0;
    [self.textButton.titleLabel setFont:textButtonFont];
    self.textButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.textButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.textButton setTitle:text forState:normal];
    
    
    
    [self.contentView addSubview:_userImageView];
    [self.contentView addSubview:_textButton];
    [self.textButton addSubview:self.indicator];
    
    

}
@end
