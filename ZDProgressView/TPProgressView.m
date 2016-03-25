//
//  TPProgressView.m
//  PE
//
//  Created by 杨志达 on 14-6-20.
//  Copyright (c) 2014年 PE. All rights reserved.
//

#import "TPProgressView.h"

@interface TPProgressView()

@property (nonatomic,strong) UIView *foregroundView;

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,assign) NSInteger cornerRadius;
@property (nonatomic,assign) NSUInteger borderWidth;

@end

@implementation TPProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.borderWidth = 1;
        [self initViews];
        [self zdFrame:frame];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andBorderWidth:(NSUInteger)borderWidth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.borderWidth = borderWidth;
        [self initViews];
        [self zdFrame:frame];

    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self zdFrame:frame];
}

- (void)zdFrame:(CGRect)frame
{
    self.layer.cornerRadius = frame.size.height/2;

    self.foregroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.foregroundView.layer.cornerRadius = frame.size.height/2;
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    UIBezierPath *bgPath = [[UIBezierPath alloc] init];
    [bgPath moveToPoint:CGPointMake(frame.size.width - frame.size.height/2, frame.size.height/2)];
    [bgPath addLineToPoint:CGPointMake(frame.size.height/2, frame.size.height/2)];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(frame.size.height/2, frame.size.height/2)];
    [path addLineToPoint:CGPointMake(frame.size.width - frame.size.height/2, frame.size.height/2)];
}

- (void)initViews
{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.clipsToBounds = YES;
    [self addSubview:self.backgroundView];
    

    self.foregroundView = [[UIView alloc] init];
    self.foregroundView.clipsToBounds = YES;
    [self addSubview:self.foregroundView];
    
}

#pragma property set or get

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundView.backgroundColor = backgroundColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.foregroundView.backgroundColor = progressColor;
}

- (void)setProgress:(CGFloat)progress
{
    self.foregroundView.frame = CGRectMake(0, 0, self.frame.size.width * progress, self.frame.size.height);
}

- (void)setBorderWidth:(NSUInteger)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
