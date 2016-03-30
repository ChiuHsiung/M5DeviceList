//
//  ChooseUserTableViewCell.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseUserTableViewCell : UITableViewCell

- (void)updateUserName:(NSString *)userName;
- (void)updateIsSelected:(BOOL)isSelected;
- (void)updateUserHeaderImage:(NSString *)imageName;

@end
