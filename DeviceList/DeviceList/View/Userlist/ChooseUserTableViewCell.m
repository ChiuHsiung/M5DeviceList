//
//  ChooseUserTableViewCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "ChooseUserTableViewCell.h"
#import "TPAttributedStringGenerator.h"

#define userImage_left_inset        (10.0f)
#define userImage_top_inset         (5.0f)

#define label_left_inset            (10.0f)
#define label_top_inset             (5.0f)
#define label_right_inset           (5.0f)

#define radio_right_inset           (15.0f)
#define radio_top_inset             (15.0f)

@interface ChooseUserTableViewCell()

@property (nonatomic, strong) UIView *userImage;
@property (nonatomic, strong) UILabel *firAlphaLabel;
@property (nonatomic, strong) UIImageView *userHeadImageView;


@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *radioImageView;

@end

@implementation ChooseUserTableViewCell

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
    self.userImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height - userImage_top_inset * 2, self.bounds.size.height - userImage_top_inset * 2)];
    self.userImage.center = CGPointMake(userImage_left_inset + self.userImage.bounds.size.width / 2, self.center.y);
    self.userImage.layer.cornerRadius = self.userImage.bounds.size.width / 2;
    self.userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.userImage];
    
    self.firAlphaLabel = [[UILabel alloc]initWithFrame:self.userImage.bounds];
    self.firAlphaLabel.layer.cornerRadius = self.firAlphaLabel.bounds.size.width / 2;
    self.firAlphaLabel.layer.masksToBounds = YES;
    self.firAlphaLabel.layer.borderWidth = 1;
    self.firAlphaLabel.layer.borderColor = [UIColor grayColor].CGColor;
    [self.firAlphaLabel setBackgroundColor:[UIColor clearColor]];
    self.firAlphaLabel.textColor = [UIColor grayColor];
    self.firAlphaLabel.font = [UIFont systemFontOfSize:20];
    self.firAlphaLabel.textAlignment = NSTextAlignmentCenter;
    [self.userImage addSubview:self.firAlphaLabel];
    
    self.userHeadImageView = [[UIImageView alloc]initWithFrame:self.userImage.bounds];
    self.userHeadImageView.layer.cornerRadius = self.userHeadImageView.bounds.size.width / 2;
    self.userHeadImageView.layer.masksToBounds = YES;
    self.userHeadImageView.backgroundColor = [UIColor clearColor];
    self.userHeadImageView.image = nil;
    [self.firAlphaLabel addSubview:self.userHeadImageView];
    
    CGFloat radioImageViewHeight = self.bounds.size.height - radio_top_inset * 2;
    self.radioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellWidth - radio_right_inset - radioImageViewHeight, radio_top_inset, radioImageViewHeight, radioImageViewHeight)];
    self.radioImageView.image = [UIImage imageNamed:@"unchecked"];
    [self addSubview:self.radioImageView];
    
    
    CGFloat maxWidth = cellWidth - (self.userImage.bounds.size.width + userImage_left_inset + label_left_inset) - (self.radioImageView.bounds.size.width + radio_right_inset + label_right_inset);
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userImage.bounds.size.width + userImage_left_inset + label_left_inset,
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
    self.userNameLabel.attributedText = attrGen.attributedString;
    self.userNameLabel.numberOfLines = 1;
    [self addSubview:self.userNameLabel];
    
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
    
    CGFloat cellWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    CGFloat maxWidth = cellWidth - (self.userImage.bounds.size.width + userImage_left_inset + label_left_inset) - (self.radioImageView.bounds.size.width + radio_right_inset + label_right_inset);
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", userName];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentLeft;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    self.userNameLabel.attributedText = attrGen.attributedString;
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
