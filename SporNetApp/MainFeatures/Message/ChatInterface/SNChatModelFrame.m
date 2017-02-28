//
//  SNChatModelFrame.m
//  Messaging
//
//  Created by Peng on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNChatModelFrame.h"
@interface SNChatModelFrame ()

/** timeLab */
@property (nonatomic, assign) CGRect timeFrame;

/** 头像frame */
@property (nonatomic, assign) CGRect iconFrame;

/** 内容的frame */
@property (nonatomic, assign) CGRect contentFrame;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellH;

@end

@implementation SNChatModelFrame

- (void)setChat:(AVIMMessage *)chat
{
    _chat = chat;
    self.alreadySent = YES;
    NSString *text = [(AVIMTextMessage*)_chat text];
    //NSString *text = @"what the fuck? Why should i do these shit.";
    CGSize contentStrSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial" size:17.0]}
                                               context:nil].size;
    
//
//    CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
//    CGFloat margin = 10;
//    CGFloat timeX;
////    CGFloat timeY = 0;
//    CGFloat timeW;
//    
//    CGFloat timeH = chat.transient ? 20: 0;
//    
//    CGSize timeStrSize = [[(AVIMTextMessage*)chat text] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20)
//                                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                                 attributes:@{NSFontAttributeName: kTimeFont}
//                                                    context: nil].size;
//    timeW = timeStrSize.width + 5;
//    timeX = (screenW - timeW) * 0.5;
//    self.timeFrame = CGRectMake(timeX, timeH, timeW, timeH);
//    
//    CGFloat iconX;
//    CGFloat iconY = margin + CGRectGetMaxY(self.timeFrame);
//    CGFloat iconW = 44;
//    CGFloat iconH = iconW;
//    
//    
//    CGFloat contentX;
//    CGFloat contentY = iconY;
//    CGFloat contentW;
//    CGFloat contentH;
//    
//    CGFloat contentMaxW = screenW - 2 * (margin + iconW + margin);
//    CGSize contentStrSize = [[(AVIMTextMessage*)chat text] boundingRectWithSize:CGSizeMake(contentMaxW, CGFLOAT_MAX)
//                                                           options:NSStringDrawingUsesLineFragmentOrigin
//                                                        attributes:@{NSFontAttributeName: kContentTextFont}
//                                                           context:nil].size;
//    
//    contentW = contentStrSize.width + kContentEdgeLeft + kContentEdgeRight;
//    contentH = contentStrSize.height + kContentEdgeTop + kContentEdgeBottom;
//    if (chat.ioType == AVIMMessageIOTypeOut) {
//        iconX = screenW - margin - iconW;
//        contentX = iconX - margin - contentW;
//    }else
//    {
//        iconX = margin;
//        contentX = iconX + iconW + margin;
//    }
//    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
//    self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
//    
//    self.cellH = (contentH > iconH) ? CGRectGetMaxY(self.contentFrame) + margin: CGRectGetMaxY(self.iconFrame) + margin;
    self.cellH = contentStrSize.height + 50;
}


@end
