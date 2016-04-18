//
//  DeviceTypeTableViewCell.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/1.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DeviceTypeTableViewCell_Height (44)

@interface DeviceTypeTableViewCell : UITableViewCell

- (void)updateDeviceType:(NSString *)deviceType;
- (void)updateIsSelected:(BOOL)isSelected;
- (void)updateDeviceTypeImage:(NSString *)imageName;

@end
