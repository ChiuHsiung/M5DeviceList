//
//  DeviceTypeTableViewCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/1.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "DeviceTypeTableViewCell.h"

static CGFloat const radio_right_margin =                    20.0f;
static CGFloat const radio_top_margin =                      15.0f;

static CGFloat const deviceTypeImage_left_margin =           radio_right_margin + 10.0f;
static CGFloat const deviceTypeImage_top_margin =            5.0f;

static CGFloat const label_left_margin =                     20.0f;
static CGFloat const label_top_margin =                      5.0f;
static CGFloat const label_right_margin =                    5.0f;


@interface DeviceTypeTableViewCell()

@property (nonatomic, strong) UIImageView *deviceTypeImageView;
@property (nonatomic, strong) UILabel *deviceTypeLabel;
@property (nonatomic, strong) UIView *radioView;

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
    self.deviceTypeImageView.backgroundColor = [UIColor whiteColor];
    self.deviceTypeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.deviceTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.deviceTypeImageView.superview).offset(deviceTypeImage_left_margin);
        make.top.equalTo(self.deviceTypeImageView.superview).offset(deviceTypeImage_top_margin);
        make.bottom.equalTo(self.deviceTypeImageView.superview).offset(-deviceTypeImage_top_margin);
        make.width.equalTo(self.deviceTypeImageView.mas_height);
        
    }];
    
    self.radioView = [[UIView alloc] init];
    [self.contentView addSubview:self.radioView];
    self.radioView.layer.cornerRadius = (DeviceTypeTableViewCell_Height - radio_top_margin * 2) / 2;
    self.radioView.layer.masksToBounds = YES;
    [self.radioView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.radioView.superview).offset(radio_top_margin);
        make.right.equalTo(self.radioView.superview).offset(-radio_right_margin);
        make.bottom.equalTo(self.radioView.superview).offset(-radio_top_margin);
        make.width.equalTo(self.radioView.mas_height);
        
    }];
    
    self.deviceTypeLabel = [[UILabel alloc] init];
    [self.deviceTypeLabel setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.deviceTypeLabel];
    [self.deviceTypeLabel setText:[NSString stringWithFormat:@"%@", @"None"]];
    [self.deviceTypeLabel setFont:[UIFont systemFontOfSize:15.0]];
    self.deviceTypeLabel.textColor = [UIColor blackColor];
    self.deviceTypeLabel.numberOfLines = 1;
    self.deviceTypeLabel.textAlignment = NSTextAlignmentLeft;
    self.deviceTypeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.deviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.deviceTypeLabel.superview).offset(label_top_margin);
        make.left.equalTo(self.deviceTypeImageView.mas_right).offset(label_left_margin);
        make.right.equalTo(self.radioView.mas_left).offset(-label_right_margin);
        make.bottom.equalTo(self.deviceTypeLabel.superview).offset(-label_top_margin);
        
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
        [self.radioView setBackgroundColor:[UIColor yellowColor]];
        self.radioView.layer.borderWidth = 0;
        self.radioView.layer.borderColor = [UIColor clearColor].CGColor;
        
    }
    else
    {
        [self.radioView setBackgroundColor:[UIColor clearColor]];
        self.radioView.layer.borderWidth = 1;
        self.radioView.layer.borderColor = [UIColor grayColor].CGColor;
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
