//
//  TPLine.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/22.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPLine.h"

@implementation TPLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithLineColor:(UIColor *)lineColor andLineWidth:(CGFloat)lineWidth
{
    self = [super init];
    if (self)
    {
        [self setupViews];
        _lineColor = lineColor;
        _lineWidth = lineWidth;
    }
    return self;
}

- (UIColor *)lineColor
{
    return _lineColor ?: self.tintColor;
}

- (CGFloat)lineWidth
{
    if (_lineWidth) {
        return _lineWidth;
    }
    
    return 1.0f;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.lineColor set];
    
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = self.lineWidth;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:self.begin];
    [bp addLineToPoint:self.end];
    [bp stroke];
    
}


- (void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.begin = CGPointMake(0.0f, 0.0f);
    self.end = CGPointMake(0.0f, 0.0f);
}


@end
