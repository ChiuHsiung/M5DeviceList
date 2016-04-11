//
//  TPDailyTimeLimitView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/7.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPBaffleView.h"

@protocol TPDailyTimeLimitViewBtnDelegate <NSObject>

- (void)refreshDailyTimeLimit:(NSString *)timeString;

@end

@interface TPDailyTimeLimitView : TPBaffleView

@property (nonatomic, weak) id<TPDailyTimeLimitViewBtnDelegate> delegate;

@end
