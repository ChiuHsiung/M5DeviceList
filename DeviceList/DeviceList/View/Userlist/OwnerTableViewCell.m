//
//  OwnerTableViewCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "OwnerTableViewCell.h"





@interface OwnerTableViewCell()

@property (nonatomic, strong) UIView *userImage;
@property (nonatomic, strong) UILabel *firAlphaLabel;
@property (nonatomic, strong) UIImageView *userHeadImageView;


@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIView *radioView;

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
    self.userImage.layer.cornerRadius = (OwnerTableViewCell_Height - userImage_top_margin * 2) / 2;
    self.userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.userImage];
    
    [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userImage.superview).offset(userImage_left_margin);
        make.top.equalTo(self.userImage.superview).offset(userImage_top_margin);
        make.bottom.equalTo(self.userImage.superview).offset(-userImage_top_margin);
        make.width.equalTo(self.userImage.mas_height);
        
    }];
    
    
    self.firAlphaLabel = [[UILabel alloc] init];
    self.firAlphaLabel.layer.cornerRadius = (OwnerTableViewCell_Height - userImage_top_margin * 2) / 2;
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
    self.userHeadImageView.layer.cornerRadius = (OwnerTableViewCell_Height - userImage_top_margin * 2) / 2;
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
    
    
    self.radioView = [[UIView alloc] init];
    [self.contentView addSubview:self.radioView];
    self.radioView.layer.cornerRadius = (OwnerTableViewCell_Height - radio_top_margin * 2) / 2;
    self.radioView.layer.masksToBounds = YES;
    [self.radioView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.radioView.superview).offset(radio_top_margin);
        make.right.equalTo(self.radioView.superview).offset(-radio_right_margin);
        make.bottom.equalTo(self.radioView.superview).offset(-radio_top_margin);
        make.width.equalTo(self.radioView.mas_height);
        
    }];
    
    self.userNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel setBackgroundColor:[UIColor whiteColor]];
    [self.userNameLabel setText:[NSString stringWithFormat:@"%@", @"None"]];
    [self.userNameLabel setFont:[UIFont systemFontOfSize:15.0]];
    self.userNameLabel.textColor = [UIColor blackColor];
    self.userNameLabel.numberOfLines = 0;
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    self.userNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userImage.mas_right).offset(label_left_margin);
        make.right.equalTo(self.radioView.mas_left).offset(-label_right_margin);
        make.top.equalTo(self.userNameLabel.superview).offset(label_top_margin);
        make.bottom.equalTo(self.userNameLabel.superview).offset(-label_top_margin);
        
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
        self.firAlphaLabel.text = @"";
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


- (void)updateUserHeaderImage:(NSString *)imageName
{
    if ([self.userNameLabel.text isEqualToString:@"None"])
    {
        return;
    }
    if (nil == imageName)
    {
        self.userHeadImageView.image = nil;
        self.firAlphaLabel.layer.borderWidth = 1;
    }
    else
    {
        UIImage *image = [UIImage imageNamed:imageName];
        self.userHeadImageView.image = image;
        self.firAlphaLabel.layer.borderWidth = 0;
    }
    
}


@end
