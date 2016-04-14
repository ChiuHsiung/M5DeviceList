//
//  TPIntelligentPriorityTimeView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/14.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPIntelligentPriorityTimeView.h"

static CGFloat const tagLogoImageView_right_inset =             5.0f;

@interface TPIntelligentPriorityTimeView()

@property (nonatomic, strong) UIImageView *tagLogoImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TPIntelligentPriorityTimeView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews
{
    self.timeLabel = [[UILabel alloc] init];
    [self addSubview:self.timeLabel];
    [self.timeLabel setFont:[UIFont systemFontOfSize:15.0f]];
    self.timeLabel.textColor = kYellow_Color;
    self.timeLabel.numberOfLines = 1;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        
    }];
    
    self.tagLogoImageView = [[UIImageView alloc] initWithImage:kClock_Image];
    [self addSubview:self.tagLogoImageView];
    CGFloat widthHeightScale = self.tagLogoImageView.bounds.size.width / self.tagLogoImageView.bounds.size.height;
    [self.tagLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.right.equalTo(self.timeLabel.mas_left).offset(-tagLogoImageView_right_inset);
        make.bottom.equalTo(self);
        make.width.equalTo(self.tagLogoImageView.mas_height).multipliedBy(widthHeightScale);
        
    }];
    
}

- (void)updateInIntelligentPriorityTime:(NSString *)timeString
{
    self.timeLabel.text = timeString;
    if (!timeString || [timeString isEqualToString:@""])
    {
        self.tagLogoImageView.alpha = 0.0f;
    }
    else
    {
        self.tagLogoImageView.alpha = 1.0f;
    }
}

@end
