//
//  CheckInManager.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/10/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CheckInManager : NSObject
+(instancetype)defaultManager;
-(void)checkinWithGymname:(NSString*)gymName sportType:(NSInteger)sportType viewController:(UIViewController*)vc;
-(NSMutableArray*)refreshAndFetchAllCheckinsWithGymName:(NSString*)gymName;
@end
