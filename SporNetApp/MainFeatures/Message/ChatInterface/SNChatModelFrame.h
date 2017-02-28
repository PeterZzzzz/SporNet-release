//
//  SNChatModelFrame.h
//  Messaging
//
//  Created by Peng on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"
//#import <UIKit/UIKit.h>

#define kTimeFont [UIFont systemFontOfSize:13.0]
#define kContentTextFont [UIFont systemFontOfSize:14.0]

#define kContentEdgeTop 15
#define kContentEdgeLeft 20
#define kContentEdgeBottom 25
#define kContentEdgeRight 20

@class SNChatModel;

@interface SNChatModelFrame : NSObject

/**
 *  Chat Model
 */
@property (nonatomic, strong) AVIMMessage *chat;
@property(nonatomic) BOOL alreadySent;
//
///**
// *  Time Label Frame
// */
//@property (nonatomic, assign, readonly) CGRect timeFrame;
//
///**
// *  User Icon Frame
// */
//@property (nonatomic, assign, readonly) CGRect iconFrame;
//
///**
// *  Message Content Frame
// */
//@property (nonatomic, assign, readonly) CGRect contentFrame;

/**
 *  Cell Height
 */
@property (nonatomic, assign, readonly) CGFloat cellH;


@end
