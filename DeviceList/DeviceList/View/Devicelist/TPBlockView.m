//
//  TPBlockView.m
//  Devicelist
//
//  Created by zhuangqiuxiong on 16/3/26.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPBlockView.h"

static CGFloat const tipsLabel_left_margin =             5.0f;

@interface TPBlockView()

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) UIImageView *foregroundView;

@property (nonatomic,strong) UIView *rightRectView;

@end

@implementation TPBlockView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andTotalProgress:(float)totalProgress
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _totalProcess = totalProgress;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self _initViewsWithImage:image];
        
    }
    return self;
}

- (void)_initViewsWithImage:(UIImage *)image
{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backgroundView];
    
    self.foregroundView = [[UIImageView alloc] init];
    [self.foregroundView setImage:image];
    [self addSubview:self.foregroundView];
    
    self.rightRectView = [[UIView alloc] init];
    self.rightRectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.rightRectView];
    
    self.tipsLabel = [[UILabel alloc] init];
    [self.tipsLabel setBackgroundColor:[UIColor whiteColor]];
    [self.rightRectView addSubview:self.tipsLabel];
    [self.tipsLabel setText:@"左拉拖黑"];
    [self.tipsLabel setFont:[UIFont systemFontOfSize:10.0]];
    self.tipsLabel.textColor = [UIColor grayColor];
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.textAlignment = NSTextAlignmentLeft;
    self.tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundView.superview);
        make.top.equalTo(self.backgroundView.superview);
        make.width.equalTo(self.backgroundView.superview);
        make.height.equalTo(@(self.bounds.size.height));
        
    }];
    
    [self.foregroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.foregroundView.superview);
        make.top.equalTo(self.foregroundView.superview);
        make.width.equalTo(@(self.bounds.size.height));
        make.height.equalTo(self.foregroundView.superview);
        
    }];
    
    [self.rightRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.foregroundView.mas_right);
        make.top.equalTo(self.rightRectView.superview);
        make.right.equalTo(self.rightRectView.superview);
        make.height.equalTo(self.rightRectView.superview);
        
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tipsLabel.superview).offset(tipsLabel_left_margin);
        make.top.equalTo(self.tipsLabel.superview);
        make.right.equalTo(self.tipsLabel.superview);
        make.height.equalTo(self.tipsLabel.superview);
        
    }];
    
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
        _curProcess = _totalProcess;
    }
    
    else if (curProcess < 0)
    {
        _curProcess = 0;
    }
    
    else
    {
        _curProcess = curProcess;

    }
    
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backgroundView.superview).offset(self.backgroundView.superview.bounds.size.height - self.backgroundView.superview.bounds.size.height * _curProcess / _totalProcess);
        make.height.equalTo(@(self.backgroundView.superview.bounds.size.height * _curProcess / _totalProcess));
        
    }];
    [super updateConstraints];

}

@end
