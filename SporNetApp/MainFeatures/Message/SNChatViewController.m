//
//  SNChatViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 8/18/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNChatViewController.h"
#import "ChatCell.h"
#import "SNChatModelFrame.h"
#import "MessageManager.h"
@interface SNChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *frameArr;
@property (nonatomic, strong) AVObject *myself;
@property (weak, nonatomic) IBOutlet UITextView *messageInputTextView;
@property (weak, nonatomic) IBOutlet UILabel *talkToLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBoxBottomConstraint;

@end

@implementation SNChatViewController

- (NSMutableArray *)frameArr {
    
    if (_frameArr == nil) {
        
        _frameArr = [NSMutableArray array];
    }
    
    return _frameArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    [[MessageManager defaultManager] startMessageService];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if ([self.conversation.myInfo isEqualToString:SELF_ID]) {
        
        self.myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.friendBasicInfo];
    } else {
        
        self.myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.myInfo];
    }
    
    [self.myself fetch];
    self.talkToLabel.text = [self.myself objectForKey:@"name"];

    self.messages = [[self.conversation.conversation queryMessagesFromCacheWithLimit:100] mutableCopy];
    for(AVIMMessage *message in self.messages) {
        SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
        frame.chat = message;
        [self.frameArr addObject:frame];
    }
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapped)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MessageManager defaultManager].myClient.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self scrollToBottom];
    
}

-(void)keyboardWillChange:(NSNotification *)notification {
    
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if([self.messageInputTextView isFirstResponder]) {
        
        self.toolBoxBottomConstraint.constant = keyboardSize.height;
        [self.view bringSubviewToFront:[self.view viewWithTag:1]];

        CGFloat startYOffset = self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.bounds);
        CGFloat endYOffset = startYOffset - keyboardSize.height;
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
            [self.tableView setContentOffset:CGPointMake(0.0, endYOffset) animated:false];
        }];
    }

}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.messages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
        if(indexPath.row == 0) [cell configureCellWithMessage:_messages[0] previousMessage:nil receiver:self.myself loadingStatus:[self.frameArr[indexPath.row] alreadySent]];
        else [cell configureCellWithMessage:_messages[indexPath.row] previousMessage:_messages[indexPath.row - 1] receiver:self.myself loadingStatus:[self.frameArr[indexPath.row] alreadySent]];
    
    return cell;
}

-(void)tableViewTapped {
    [self dismissKeyboard];
}
//dismiss keyboard with animation
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.toolBoxBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.frameArr[indexPath.row] cellH];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [self sendMessageWithMessage:_messageInputTextView.text];
        return NO;
    }
    return YES;
}

-(void)sendMessageWithMessage:(NSString*)message {
    AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:message attributes:nil];
    [self.messages addObject:textMessage];
    
    SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
    frame.chat = textMessage;
    frame.alreadySent = NO;
    [_frameArr addObject:frame];
    self.messageInputTextView.text = @"";
    
    AVIMMessageOption *messageOption = [[AVIMMessageOption alloc]init];
    messageOption.receipt = YES;
    
    AVObject *myself;
    if ([self.conversation.myInfo isEqualToString:SELF_ID]) {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.friendBasicInfo];
    }else {
        
        myself = [AVObject objectWithClassName:@"SNUser" objectId:self.conversation.myInfo];
    }
    
    
    [myself fetch];
    
    
    [self.conversation.conversation sendMessage:textMessage option:messageOption callback:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (error) {
            // 此时聊天服务不可用。
//            NSLog(@"conversation error %@", error.description);
            [ProgressHUD showError:@"聊天不可用"];
        }
        else{
            
            frame.alreadySent = YES;
            
            [self.tableView reloadData];
            [self scrollToBottom];
            
            [[MessageManager defaultManager]sendPushNotificationTo:[myself objectForKey:@"name"] withMessage:@"You've Got a New Message"];
            
        }
    }
     ];
    
    

}

-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    [self.messages addObject:message];
    SNChatModelFrame *frame = [[SNChatModelFrame alloc]init];
    frame.chat = message;
    [_frameArr addObject:frame];
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)scrollToBottom {
    if (!self.messages.count) return;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow: self.messages.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath: lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}
@end
