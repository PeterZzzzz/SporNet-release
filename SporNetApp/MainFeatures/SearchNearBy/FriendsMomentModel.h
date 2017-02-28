//
//  FriendsMomentModel.h
//  SporNetApp
//
//  Created by Peng on 1/3/17.
//  Copyright © 2017 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FriendsMomentModel : AVObject <AVSubclassing>


@property (nonatomic, copy)   NSString *UserID;
@property (nonatomic, copy) NSString *StatusMessage;
@property (nonatomic, strong) NSArray *MomentsPics;

@end
