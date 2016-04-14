//
//  OwnerTableViewCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "OwnerTableViewCell.h"

static CGFloat const userImage_left_inset =         10.0f;
static CGFloat const userImage_top_inset =          5.0f;

static CGFloat const label_left_inset =             10.0f;
static CGFloat const label_top_inset =              5.0f;
static CGFloat const label_right_inset =            5.0f;

static CGFloat const radio_right_inset =            15.0f;
static CGFloat const radio_top_inset =              15.0f;

@interface OwnerTableViewCell()

@property (nonatomic, strong) UIView *userImage;
@property (nonatomic, strong) UILabel *firAlphaLabel;
@property (nonatomic, strong) UIImageView *userHeadImageView;


@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *radioImageView;

@end

@implementation OwnerTableViewCell

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
    self.userImage = [[UIView alloc] init];
    self.userImage.layer.cornerRadius = (self.bounds.size.height - userImage_top_inset * 2) / 2;
    self.userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.userImage];
    
    [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userImage.superview).offset(userImage_left_inset);
        make.top.equalTo(self.userImage.superview).offset(userImage_top_inset);
        make.bottom.equalTo(self.userImage.superview).offset(-userImage_top_inset);
        make.width.equalTo(self.userImage.mas_height);
        
    }];
    
    
    self.firAlphaLabel = [[UILabel alloc] init];
    self.firAlphaLabel.layer.cornerRadius = (self.bounds.size.height - userImage_top_inset * 2) / 2;
    self.firAlphaLabel.layer.masksToBounds = YES;
    self.firAlphaLabel.layer.borderWidth = 1;
    self.firAlphaLabel.layer.borderColor = [UIColor grayColor].CGColor;
    [self.firAlphaLabel setBackgroundColor:[UIColor clearColor]];
    self.firAlphaLabel.textColor = [UIColor grayColor];
    [self.firAlphaLabel setFont:[UIFont systemFontOfSize:20.0]];
    self.firAlphaLabel.textAlignment = NSTextAlignmentCenter;
    [self.userImage addSubview:self.firAlphaLabel];
    
    [self.firAlphaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.firAlphaLabel.superview);
        make.top.equalTo(self.firAlphaLabel.superview);
        make.width.equalTo(self.firAlphaLabel.superview);
        make.height.equalTo(self.firAlphaLabel.superview);
        
    }];
    
    
    self.userHeadImageView = [[UIImageView alloc] init];
    self.userHeadImageView.layer.cornerRadius = (self.bounds.size.height - userImage_top_inset * 2) / 2;
    self.userHeadImageView.layer.masksToBounds = YES;
    self.userHeadImageView.backgroundColor = [UIColor clearColor];
    self.userHeadImageView.image = nil;
    [self.firAlphaLabel addSubview:self.userHeadImageView];
    
    [self.userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userHeadImageView.superview);
        make.top.equalTo(self.userHeadImageView.superview);
        make.width.equalTo(self.userHeadImageView.superview);
        make.height.equalTo(self.userHeadImageView.superview);
        
    }];
    
    
    self.radioImageView = [[UIImageView alloc] init];
    self.radioImageView.image = kUncheck_Image;
    [self.contentView addSubview:self.radioImageView];
    [self.radioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.radioImageView.superview).offset(-radio_right_inset);
        make.top.equalTo(self.radioImageView.superview).offset(radio_top_inset);
        make.bottom.equalTo(self.radioImageView.superview).offset(-radio_top_inset);
        make.width.equalTo(self.radioImageView.mas_height);
        
    }];
    
    self.userNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel setBackgroundColor:[UIColor whiteColor]];
    [self.userNameLabel setText:[NSString stringWithFormat:@"%@", @"None"]];
    [self.userNameLabel setFont:[UIFont systemFontOfSize:10.0]];
    self.userNameLabel.textColor = [UIColor grayColor];
    self.userNameLabel.numberOfLines = 0;
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    self.userNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userImage.mas_right).offset(label_left_inset);
        make.right.equalTo(self.radioImageView.mas_left).offset(-label_right_inset);
        make.top.equalTo(self.userNameLabel.superview).offset(label_top_inset);
        make.bottom.equalTo(self.userNameLabel.superview).offset(-label_top_inset);
        
    }];
    
    
}

#pragma mark - 更新函数
- (void)updateUserName:(NSString *)userName
{
    if (!userName)
    {
        return;
    }
    if ([userName isEqualToString:@"None"])
    {
        self.firAlphaLabel.layer.borderWidth = 0;
        self.userHeadImageView.image = nil;
    }
    else
    {
        self.firAlphaLabel.layer.borderWidth = 1;
        self.firAlphaLabel.text = [[userName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    }
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@", userName];
}


- (void)updateIsSelected:(BOOL)isSelected
{
    if (isSelected)
    {
        self.radioImageView.image = kCheck_Image;
    }
    else
    {
        self.radioImageView.image = kUncheck_Image;
    }
}


- (void)updateUserHeaderImage:(NSString *)imageName
{
    if ([self.userNameLabel.text isEqualToString:@"None"])
    {
        return;
    }
    if (nil == imageName)
    {
        self.userHeadImageView.image = nil;
    }
    else
    {
        UIImage *image = [UIImage imageNamed:imageName];
        self.userHeadImageView.image = image;
    }
    
}


@end
