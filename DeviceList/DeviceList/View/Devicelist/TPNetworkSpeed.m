//
//  TPNetworkSpeed.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/13.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPNetworkSpeed.h"

static CGFloat dowloadSpeedLabel_left_margin =           5.0f;

static CGFloat uploadImageView_left_margin =             5.0f;

static CGFloat uploadSpeedLabel_left_margin =            5.0f;

@interface TPNetworkSpeed()

@property (nonatomic, strong) UIImageView *downloadImageView;
@property (nonatomic, strong) UILabel *dowloadSpeedLabel;

@property (nonatomic, strong) UIImageView *uploadImageView;
@property (nonatomic, strong) UILabel *uploadSpeedLabel;

@end

@implementation TPNetworkSpeed

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initSubViews];
        
    }
    return self;
}

- (void)_initSubViews
{
    self.downloadImageView = [[UIImageView alloc] initWithImage:kDownload_Arrow_Image];
    CGFloat widthHeightScale = self.downloadImageView.bounds.size.width / self.downloadImageView.bounds.size.height;
    [self addSubview:self.downloadImageView];
    [self.downloadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self.downloadImageView.mas_height).multipliedBy(widthHeightScale);
        
    }];
    
    self.dowloadSpeedLabel = [[UILabel alloc] init];
    [self addSubview:self.dowloadSpeedLabel];
    [self.dowloadSpeedLabel setText:[NSString stringWithFormat:@"%@", @"---Mbps"]];
    [self.dowloadSpeedLabel setFont:[UIFont systemFontOfSize:10.0]];
    self.dowloadSpeedLabel.textColor = [UIColor grayColor];
    self.dowloadSpeedLabel.numberOfLines = 1;
    self.dowloadSpeedLabel.textAlignment = NSTextAlignmentLeft;
    self.dowloadSpeedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.dowloadSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self.downloadImageView.mas_right).offset(dowloadSpeedLabel_left_margin);
        make.bottom.equalTo(self);
        
    }];
    
    self.uploadImageView = [[UIImageView alloc] initWithImage:kUpload_Arrow_Image];
    widthHeightScale = self.uploadImageView.bounds.size.width / self.uploadImageView.bounds.size.height;
    [self addSubview:self.uploadImageView];
    [self.uploadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self.dowloadSpeedLabel.mas_right).offset(uploadImageView_left_margin);
        make.bottom.equalTo(self);
        make.width.equalTo(self.uploadImageView.mas_height).multipliedBy(widthHeightScale);
    }];
    
    self.uploadSpeedLabel = [[UILabel alloc] init];
    [self addSubview:self.uploadSpeedLabel];
    [self.uploadSpeedLabel setText:[NSString stringWithFormat:@"%@", @"---Mbps"]];
    [self.uploadSpeedLabel setFont:[UIFont systemFontOfSize:10.0]];
    self.uploadSpeedLabel.textColor = [UIColor grayColor];
    self.uploadSpeedLabel.numberOfLines = 1;
    self.uploadSpeedLabel.textAlignment = NSTextAlignmentLeft;
    self.uploadSpeedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.uploadSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.left.equalTo(self.uploadImageView.mas_right).offset(uploadSpeedLabel_left_margin);
        make.bottom.equalTo(self);
        
    }];
    
    
}

- (void)updateUploadSpeed:(int)uploadSpeed
{
    [self.uploadSpeedLabel setText:[NSString stringWithFormat:@"%d%@", uploadSpeed, @"Mbps"]];
}

- (void)updateDownloadSpeed:(int)downloadSpeed
{
    [self.dowloadSpeedLabel setText:[NSString stringWithFormat:@"%d%@", downloadSpeed, @"Mbps"]];
}

@end
