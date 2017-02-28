//
//  WaterView.m
//  SearchNearBy_Demo
//
//  Created by ZhengYang on 16/7/29.
//  Copyright © 2016年 ZhengYang. All rights reserved.
//

#import "WaterView.h"

@implementation WaterView

- (void)drawRect:(CGRect)rect {
    
    // 半径
    CGFloat rabius = 30;
    // 开始角
    CGFloat startAngle = 0;
    // 结束角
    CGFloat endAngle = 2*M_PI;
    // 中心点
    CGPoint point = CGPointMake(20 , 20);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;       // 添加路径 下面三个同理
    
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    
    [self.layer addSublayer:layer];
    
}



@end
