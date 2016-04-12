//
//  TPDailyTimeLimitPicker.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/12.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPBaffleView.h"

@protocol TPDailyTimeLimitPickerDelegate <NSObject>

- (void)refreshDailyTimeLimit:(NSString *)timeString;

@end

@interface TPDailyTimeLimitPicker : TPBaffleView

@property (nonatomic, weak) id<TPDailyTimeLimitPickerDelegate> delegate;

- (void)updateDailyTimeLimit:(NSString *)timeString;

@end
