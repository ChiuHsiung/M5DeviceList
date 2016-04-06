//
//  TPBlockView.m
//  Devicelist
//
//  Created by zhuangqiuxiong on 16/3/26.
//  Copyright © 2016年 tplink. All rights reserved.
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
        [self setBackgroundColor:[UIColor whiteColor]];
        [self _initViewsWithImageName:imageName];
        
    }
    return self;
}

- (void)_initViewsWithImageName:(NSString *)imageName
{
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backgroundView];
    
    self.foregroundView = [[UIImageView alloc] init];
    [self.foregroundView setImage:[UIImage imageNamed:imageName]];
    [self addSubview:self.foregroundView];
    
    self.tipsLabel = [[UILabel alloc] init];
    [self.tipsLabel setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.tipsLabel];
    [self.tipsLabel setText:@"左拉拖黑"];
    [self.tipsLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
    self.tipsLabel.textColor = [UIColor grayColor];
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.textAlignment = NSTextAlignmentLeft;
    self.tipsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundView.superview);
        make.top.equalTo(self.backgroundView.superview);
        make.width.equalTo(@(self.bounds.size.height));
        make.height.equalTo(@(self.bounds.size.height));
        
    }];
    
    [self.foregroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.foregroundView.superview);
        make.top.equalTo(self.foregroundView.superview);
        make.width.equalTo(@(self.bounds.size.height));
        make.height.equalTo(@(self.bounds.size.height));
        
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.foregroundView.mas_right);
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
