//
//  TPDeviceInfoView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPDeviceInfoView : UIControl

@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *deviceName;

@property (nonatomic, assign) BOOL isParentalCtrl;
@property (nonatomic, strong) NSString *parentalCtrlTime;

- (instancetype)initWithFrame:(CGRect)frame withCircleColor:(UIColor *)circleColor andLineWidth:(CGFloat)lineWidth;

@end
