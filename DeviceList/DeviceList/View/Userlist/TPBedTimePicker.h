//
//  TPBedTimePicker.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/11.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPBaffleView.h"

@protocol TPBedTimePickerDelegate <NSObject>

- (void)refreshTime:(NSString *)timeString withIsBedTime:(BOOL)isBedTime;

@end

@interface TPBedTimePicker : TPBaffleView

@property (nonatomic, weak) id<TPBedTimePickerDelegate> delegate;

- (void)updateTime:(NSString *)timeString withIsBedTime:(BOOL)isBedTime;

@end
