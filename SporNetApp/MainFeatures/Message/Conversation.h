//
//  Conversation.h
//  SporNetApp
//
//  Created by Peng Wang on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNUser;

@interface Conversation : NSObject
/**
 *  Conversation Model
 */
@property (nonatomic, strong) AVIMConversation *conversation;
/**
 *  User's Basic Info Model
 */
@property (nonatomic, copy) NSString *myInfo;
/**
 *  Message number hasn't read
 */
@property NSInteger unreadMessageNumber;
/**
 *  Friend's Basic info Model
 */
@property (nonatomic, copy) NSString *friendBasicInfo;
@end
