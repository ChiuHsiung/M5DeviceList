//
//  DeviceTypeTableViewCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/1.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "DeviceTypeTableViewCell.h"

static CGFloat const deviceTypeImage_left_inset =           10.0f;
static CGFloat const deviceTypeImage_top_inset =            5.0f;

static CGFloat const label_left_inset =                     10.0f;
static CGFloat const label_top_inset =                      5.0f;
static CGFloat const label_right_inset =                    5.0f;

static CGFloat const radio_right_inset =                    15.0f;
static CGFloat const radio_top_inset =                      15.0f;

@interface DeviceTypeTableViewCell()

@property (nonatomic, strong) UIImageView *deviceTypeImageView;
@property (nonatomic, strong) UILabel *deviceTypeLabel;
@property (nonatomic, strong) UIImageView *radioImageView;

@end

@implementation DeviceTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.deviceTypeImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.deviceTypeImageView];
    [self.deviceTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.deviceTypeImageView.superview).offset(deviceTypeImage_left_inset);
        make.top.equalTo(self.deviceTypeImageView.superview).offset(deviceTypeImage_top_inset);
        make.bottom.equalTo(self.deviceTypeImageView.superview).offset(-deviceTypeImage_top_inset);
        make.width.equalTo(self.deviceTypeImageView.mas_height);
        
    }];
    
    self.radioImageView = [[UIImageView alloc] init];
    self.radioImageView.image = [UIImage imageNamed:@"unchecked"];
    [self addSubview:self.radioImageView];
    [self.radioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.radioImageView.superview).offset(radio_top_inset);
        make.right.equalTo(self.radioImageView.superview).offset(-radio_right_inset);
        make.bottom.equalTo(self.radioImageView.superview).offset(-radio_top_inset);
        make.width.equalTo(self.radioImageView.mas_height);
        
    }];
    
    self.deviceTypeLabel = [[UILabel alloc] init];
    [self.deviceTypeLabel setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.deviceTypeLabel];
    [self.deviceTypeLabel setText:[NSString stringWithFormat:@"%@", @"None"]];
    [self.deviceTypeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
    self.deviceTypeLabel.textColor = [UIColor grayColor];
    self.deviceTypeLabel.numberOfLines = 1;
    self.deviceTypeLabel.textAlignment = NSTextAlignmentLeft;
    self.deviceTypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.deviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.deviceTypeLabel.superview).offset(label_top_inset);
        make.left.equalTo(self.deviceTypeImageView.mas_right).offset(label_left_inset);
        make.right.equalTo(self.radioImageView.mas_left).offset(-label_right_inset);
        make.bottom.equalTo(self.deviceTypeLabel.superview).offset(-label_top_inset);
        
    }];
    
}

#pragma mark - 更新函数
- (void)updateDeviceType:(NSString *)deviceType
{
    if (!deviceType)
    {
        return;
    }
    
    self.deviceTypeLabel.text = [NSString stringWithFormat:@"%@", deviceType];
}


- (void)updateIsSelected:(BOOL)isSelected
{
    if (isSelected)
    {
        self.radioImageView.image = [UIImage imageNamed:@"checked"];
    }
    else
    {
        self.radioImageView.image = [UIImage imageNamed:@"unchecked"];
    }
}


- (void)updateDeviceTypeImage:(NSString *)imageName{
    if (nil == imageName)
    {
        self.deviceTypeImageView.image = nil;
    }
    else
    {
        UIImage *image = [UIImage imageNamed:imageName];
        self.deviceTypeImageView.image = image;
    }
    
}

@end
