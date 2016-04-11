//
//  TPBaffleView.m
//  tpM5
//
//  Created by CaiXin on 16/4/6.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPBaffleView.h"

@interface TPBaffleView ()
@property(strong, nonatomic)UIView* hostView;
@end

@implementation TPBaffleView

-(id) initWithHostView:(UIView*)hostView
{
    self = [super initWithFrame:CGRectZero];
    if (self != nil)
    {
        self.hostView = hostView;
        self.frame = self.hostView.bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    }
    return self;
}

-(id) init
{
    return [self initWithHostView:[UIApplication sharedApplication].delegate.window];
}

-(id) initWithFrame:(CGRect)frame
{
    return [self initWithHostView:[[UIApplication sharedApplication].delegate window]];
}

-(void) show
{
    [self.hostView addSubview:self];
    
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat length = 20;
    UIBezierPath* beginPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x - length / 2, center.y - length / 2, length, length) cornerRadius:length / 2];
    CGFloat viewLength = sqrtf(self.bounds.size.width*self.bounds.size.width + self.bounds.size.height*self.bounds.size.height);
    UIBezierPath* endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x - viewLength / 2, center.y - viewLength / 2, viewLength, viewLength) cornerRadius:viewLength / 2];
    
    CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = endPath.CGPath;
    self.layer.mask = shapeLayer;
    
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath = @"path";
    animation.fromValue = (__bridge id)beginPath.CGPath;
    animation.toValue = (__bridge id)endPath.CGPath;
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    
    [shapeLayer addAnimation:animation forKey:nil];
}

-(void) dismiss
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat length = 20;
    UIBezierPath* endPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x - length / 2, center.y - length / 2, length, length) cornerRadius:length / 2];
    CGFloat viewLength = sqrtf(self.bounds.size.width*self.bounds.size.width + self.bounds.size.height*self.bounds.size.height);
    UIBezierPath* beginPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center.x - viewLength / 2, center.y - viewLength / 2, viewLength, viewLength) cornerRadius:viewLength / 2];
    
    CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = endPath.CGPath;
    self.layer.mask = shapeLayer;
    
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath = @"path";
    animation.fromValue = (__bridge id)beginPath.CGPath;
    animation.toValue = (__bridge id)endPath.CGPath;
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    
    [shapeLayer addAnimation:animation forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
    });
}

@end
