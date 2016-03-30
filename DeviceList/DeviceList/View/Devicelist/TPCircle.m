//
//  TPCircle.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/22.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPCircle.h"

@implementation TPCircle


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithCircleColor:(UIColor *)circleColor
{
    self = [super init];
    if (self)
    {
        [self setupViews];
        _circleColor = circleColor;
    }
    return self;
}

- (CGFloat)circleRadius
{
    if (_circleRadius)
        return _circleRadius;
    
    CGFloat horizontalSize = CGRectGetWidth(self.bounds);
    CGFloat verticalSize = CGRectGetHeight(self.bounds);
    
    return MIN(horizontalSize, verticalSize) / 2.0f - self.lineWidth * 2;
}

- (UIColor *)circleColor
{
    return _circleColor ?: self.tintColor;
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
    [self drawCircleWithRadius:self.circleRadius color:self.circleColor];
}


- (void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)drawCircleWithRadius:(CGFloat)radius color:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGRect circle = CGRectMake(p_fixedCenter(self.frame).x - radius,
                               p_fixedCenter(self.frame).y - radius,
                               2 * radius,
                               2 * radius);
    
    CGContextAddEllipseInRect(context, circle);
    CGContextStrokePath(context);
}

CGPoint p_fixedCenter(CGRect frame) {
    CGFloat _fixedX = (CGRectGetMaxX(frame) - CGRectGetMinX(frame)) / 2.0;
    CGFloat _fixedY = (CGRectGetMaxY(frame) - CGRectGetMinY(frame)) / 2.0;
    return CGPointMake(_fixedX, _fixedY);
}

@end
