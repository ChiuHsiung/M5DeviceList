//
//  TPProgressView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/25.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPProgressView : UIView

@property (nonatomic,assign) float curProcess;
@property (nonatomic,assign, readonly) float totalProcess;

@property (nonatomic,strong) UIColor *bgViewColor;
@property (nonatomic,strong) UIColor *progressColor;

- (id)initWithFrame:(CGRect)frame withTotalProgress:(float)totalProgress;

@end
