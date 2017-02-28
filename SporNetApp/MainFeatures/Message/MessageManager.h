//
//  MessageManager.h
//  SporNetApp
//
//  Created by Peng Wang on 8/17/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVIMClient.h>
#import "Conversation.h"

@protocol MessageManagerDelegate <NSObject>
@optional
-(void)didFinishRefreshing;
-(void)didAcceptFriendRequest;

@end
@interface MessageManager : NSObject

@property (nonatomic, strong) AVIMClient *myClient;
@property (nonatomic, strong) AVIMClient *friendClient;
@property(nonatomic) NSMutableArray *allFriendRequsts;


@property (nonatomic, weak) id<MessageManagerDelegate> delegate;
+ (instancetype)defaultManager;
- (void)startMessageService;
- (void)closeMessageService;
- (NSMutableArray*)fetchAllCurrentConversations;
- (NSMutableArray*)fetchAllCurrentFriendRequests;
- (NSMutableDictionary*)fetchAllContacts;
- (void)refreshAllConversations;
- (void)refreshAllFriendRequest;
- (void)sendAddFrendRequst:(NSString*)clientId;
- (void)acceptFriendRequest:(Conversation*)c;
- (void)rejectFriendRequest:(Conversation*)c;
- (void)sendPushNotificationTo:(NSString *)name withMessage:(NSString *)message;
//- (void)shouldSendFriendRequest:(NSString *)cliendID;
@end



