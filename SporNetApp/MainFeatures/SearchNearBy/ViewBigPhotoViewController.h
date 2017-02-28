//
//  ViewBigPhotoViewController.h
//  SporNetApp
//
//  Created by 浦明晖 on 8/5/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBigPhotoViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, assign) NSInteger currentImageIndex;
@end
