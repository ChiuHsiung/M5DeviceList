//
//  DeviceTypeTableViewCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/1.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "DeviceTypeTableViewCell.h"
#import "TPAttributedStringGenerator.h"

#define deviceTypeImage_left_inset          (10.0f)
#define deviceTypeImage_top_inset           (5.0f)

#define label_left_inset                    (10.0f)
#define label_top_inset                     (5.0f)
#define label_right_inset                   (5.0f)

#define radio_right_inset                   (15.0f)
#define radio_top_inset                     (15.0f)

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
    CGFloat cellWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    self.deviceTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height - deviceTypeImage_top_inset * 2, self.bounds.size.height - deviceTypeImage_top_inset * 2)];
    self.deviceTypeImageView.center = CGPointMake(deviceTypeImage_left_inset + self.deviceTypeImageView.bounds.size.width / 2, self.center.y);
    [self.contentView addSubview:self.deviceTypeImageView];
    
    CGFloat radioImageViewHeight = self.bounds.size.height - radio_top_inset * 2;
    self.radioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth - radio_right_inset - radioImageViewHeight, radio_top_inset, radioImageViewHeight, radioImageViewHeight)];
    self.radioImageView.image = [UIImage imageNamed:@"unchecked"];
    [self addSubview:self.radioImageView];
    
    
    CGFloat maxWidth = cellWidth - (self.deviceTypeImageView.bounds.size.width + deviceTypeImage_left_inset + label_left_inset) - (self.radioImageView.bounds.size.width + radio_right_inset + label_right_inset);
    self.deviceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.deviceTypeImageView.bounds.size.width + deviceTypeImage_left_inset + label_left_inset,
                                                                     label_top_inset,
                                                                     maxWidth,
                                                                     self.bounds.size.height - label_top_inset * 2)];
    
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", @"None"];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentLeft;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    self.deviceTypeLabel.attributedText = attrGen.attributedString;
    self.deviceTypeLabel.numberOfLines = 1;
    [self addSubview:self.deviceTypeLabel];
    
}

#pragma mark - 更新函数
- (void)updateDeviceType:(NSString *)deviceType
{
    if (!deviceType)
    {
        return;
    }
    
    
    CGFloat cellWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    CGFloat maxWidth = cellWidth - (self.deviceTypeImageView.bounds.size.width + deviceTypeImage_left_inset + label_left_inset) - (self.radioImageView.bounds.size.width + radio_right_inset + label_right_inset);
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", deviceType];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentLeft;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    self.deviceTypeLabel.attributedText = attrGen.attributedString;
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
