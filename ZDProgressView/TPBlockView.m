//
//  TPBlockView.m
//  Devicelist
//
//  Created by zhuangqiuxiong on 16/3/26.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPBlockView.h"

@interface TPBlockView()

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) UIImageView *foregroundView;

@end

@implementation TPBlockView

- (id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName andTotalProgress:(float)totalProgress
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _totalProcess = totalProgress;
        [self _initViews:frame andImageName:imageName];
        
    }
    return self;
}

- (void)_initViews:(CGRect)frame andImageName:(NSString *)imageName
{
    self.backgroundView = [[UIView alloc] init];
    [self addSubview:self.backgroundView];
    
    self.foregroundView = [[UIImageView alloc] init];
    [self addSubview:self.foregroundView];
    
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.foregroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.foregroundView setImage:[UIImage imageNamed:imageName]];

    
    
}


#pragma property set or get

- (void)setBgViewColor:(UIColor *)bgViewColor
{
    self.backgroundColor = bgViewColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    self.backgroundView.backgroundColor = progressColor;
}

- (void)setCurProcess:(float)curProcess
{
    if (curProcess > _totalProcess)
    {
        return;
    }
    
    _curProcess = curProcess;
    
    self.backgroundView.frame = CGRectMake(0,
                                           self.bounds.size.height - self.bounds.size.height * _curProcess / _totalProcess,
                                           self.bounds.size.width,
                                           self.bounds.size.height * _curProcess / _totalProcess);
}

@end
