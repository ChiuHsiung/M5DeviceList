//
//  TPLine.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/22.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TPLine : UIView

@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;

@property (nonatomic, assign) IBInspectable CGPoint begin;
@property (nonatomic, assign) IBInspectable CGPoint end;

- (instancetype)initWithLineColor:(UIColor *)lineColor andLineWidth:(CGFloat)lineWidth;

@end
