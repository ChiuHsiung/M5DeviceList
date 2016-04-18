//
//  OwnerTableViewCell.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OwnerTableViewCell_Height (54)

static CGFloat const radio_right_margin =            20.0f;
static CGFloat const radio_top_margin =              15.0f;

static CGFloat const userImage_left_margin =         radio_right_margin + 10.0f;
static CGFloat const userImage_top_margin =          5.0f;

static CGFloat const label_left_margin =             20.0f;
static CGFloat const label_top_margin =              5.0f;
static CGFloat const label_right_margin =            5.0f;

@interface OwnerTableViewCell : UITableViewCell

- (void)updateUserName:(NSString *)userName;
- (void)updateIsSelected:(BOOL)isSelected;
- (void)updateUserHeaderImage:(NSString *)imageName;

@end
