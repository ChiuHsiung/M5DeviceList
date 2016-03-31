//
//  OwnerTimeCtrlTableViewCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/31.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "OwnerTimeCtrlTableViewCell.h"
#import "TPAttributedStringGenerator.h"

#define funcLabel_left_inset        (15.0f)
#define funcLabel_top_inset         (5.0f)
#define funcLabel_right_inset       (5.0f)

#define timeLabel_right_inset       (5.0f)
#define timeLabel_top_inset         (5.0f)
#define timeLabel_width             (40.0f)

@interface OwnerTimeCtrlTableViewCell()

@property (nonatomic, strong) UILabel *funcLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation OwnerTimeCtrlTableViewCell

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

- (void)creatUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.funcLabel = [[UILabel alloc] init];
    self.funcLabel.numberOfLines = 1;
    [self.contentView addSubview:self.funcLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.numberOfLines = 1;
    [self.contentView addSubview:self.timeLabel];
    
    [self addConstraint];
    
}

- (void)updateFuncLabel:(NSString *)funcString
{
    CGFloat maxWidth = [[UIScreen mainScreen] applicationFrame].size.width - timeLabel_width - timeLabel_right_inset - funcLabel_left_inset;
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", funcString];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentLeft;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    self.funcLabel.attributedText = attrGen.attributedString;
}

- (void)updateTimeLabel:(NSString *)timeString
{
    CGFloat maxWidth = timeLabel_width;
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", timeString];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentRight;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    self.timeLabel.attributedText = attrGen.attributedString;
}

- (void)addConstraint
{
    [self addConstraintToTimeLabel];
    [self addConstraintToFuncLabel];
}

- (void)addConstraintToTimeLabel
{
    [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem :self.timeLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:timeLabel_top_inset];
    
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem :self.timeLabel
                                                                         attribute:NSLayoutAttributeBottom
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeBottom
                                                                        multiplier:1.0
                                                                          constant:-timeLabel_top_inset];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem :self.timeLabel
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:0
                                                                          toItem:nil
                                                                       attribute:0
                                                                      multiplier:1
                                                                        constant:timeLabel_width];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem :self.timeLabel
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1.0
                                                                         constant:-timeLabel_right_inset];
    
    [self.contentView addConstraints:@[constraintTop, constraintBottom, constraintRight]];
    [self.timeLabel addConstraint:constraintWidth];
    
}

- (void)addConstraintToFuncLabel
{
//    CGFloat maxWidth = [[UIScreen mainScreen] applicationFrame].size.width - timeLabel_width - timeLabel_right_inset - funcLabel_left_inset;
    [self.funcLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem :self.funcLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:funcLabel_top_inset];
    
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem :self.funcLabel
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:-funcLabel_top_inset];
    
    NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem :self.funcLabel
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1.0
                                                                         constant:funcLabel_left_inset];
    
    NSLayoutConstraint *constraintRight = [NSLayoutConstraint constraintWithItem :self.funcLabel
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.timeLabel
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0
                                                                          constant:-funcLabel_right_inset];
    
    [self.contentView addConstraints:@[constraintTop, constraintBottom, constraintLeft, constraintRight]];
    
}

@end
