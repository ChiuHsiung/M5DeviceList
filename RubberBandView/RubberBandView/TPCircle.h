//
//  TPCircle.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/22.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TPCircle : UIView

@property (nonatomic, assign) IBInspectable CGFloat circleRadius;
@property (nonatomic, strong) IBInspectable UIColor *circleColor;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;

- (instancetype)initWithCircleColor:(UIColor *)circleColor;

@end
