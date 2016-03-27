//
//  TPBlockView.m
//  Devicelist
//
//  Created by zhuangqiuxiong on 16/3/26.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPBlockView.h"
#import "TPAttributedStringGenerator.h"

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
    
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
    self.foregroundView.frame = CGRectMake(0, 0, frame.size.height, frame.size.height);
    [self.foregroundView setImage:[UIImage imageNamed:imageName]];
    
    
    CGFloat maxWidth = frame.size.width - frame.size.height;
    
    self.rightRectView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.height, 0, maxWidth, frame.size.height)];
    [self.rightRectView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.rightRectView];
    
    self.tipsLabel = [[UILabel alloc] init];
    
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = @"左拉拖黑";
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentLeft;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    self.tipsLabel.attributedText = attrGen.attributedString;
    [self.tipsLabel sizeToFit];
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.frame = CGRectMake(0,
                                      0,
                                      (self.tipsLabel.bounds.size.width < maxWidth ? self.tipsLabel.bounds.size.width : maxWidth),
                                      (self.tipsLabel.bounds.size.height < frame.size.height ? self.tipsLabel.bounds.size.height : frame.size.height)
                                      );
    self.tipsLabel.center = CGPointMake(self.tipsLabel.bounds.size.width / 2, frame.size.height / 2);
    
    [self.rightRectView addSubview:self.tipsLabel];
    
    
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
    if (curProcess > _totalProcess || curProcess < 0)
    {
        return;
    }
    
    _curProcess = curProcess;
    
    self.backgroundView.frame = CGRectMake(0,
                                           self.bounds.size.height - self.bounds.size.height * _curProcess / _totalProcess,
                                           self.bounds.size.height,
                                           self.bounds.size.height * _curProcess / _totalProcess);
}

@end
