//
//  TPProgressView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/25.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPProgressView.h"

@interface TPProgressView()

@property (nonatomic,strong) UIView *foregroundView;

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,assign) NSInteger cornerRadius;
@property (nonatomic,assign) NSUInteger borderWidth;

@end

@implementation TPProgressView

- (id)initWithFrame:(CGRect)frame withTotalProgress:(float)totalProgress
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _totalProcess = totalProgress;
        self.borderWidth = 1;
        [self _initViews:frame];
        
    }
    return self;
}

- (void)_initViews:(CGRect)frame
{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.clipsToBounds = YES;
    [self addSubview:self.backgroundView];
    
    
    self.foregroundView = [[UIView alloc] init];
    self.foregroundView.clipsToBounds = YES;
    [self addSubview:self.foregroundView];
    
    self.cornerRadius = frame.size.height/2;
    self.layer.cornerRadius = self.cornerRadius;
    self.foregroundView.layer.cornerRadius = self.cornerRadius;
    
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.foregroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    
}

#pragma property set or get

- (void)setBgViewColor:(UIColor *)bgViewColor
{
    self.backgroundView.backgroundColor = bgViewColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    //    self.layer.borderColor = progressColor.CGColor;//进度条边界
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.foregroundView.backgroundColor = progressColor;
}

- (void)setCurProcess:(float)curProcess
{
    if (curProcess > _totalProcess)
    {
        return;
    }
    
    _curProcess = curProcess;
    //为了显示好看的处理
    if (curProcess != 0)
    {
        CGFloat atLeastProgress = self.cornerRadius * 2 / self.bounds.size.width * _totalProcess;
        _curProcess = curProcess < atLeastProgress ? atLeastProgress:curProcess;
    }
    
    self.foregroundView.frame = CGRectMake(0, 0, self.bounds.size.width * _curProcess / _totalProcess, self.bounds.size.height);
}

- (void)setBorderWidth:(NSUInteger)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}


@end