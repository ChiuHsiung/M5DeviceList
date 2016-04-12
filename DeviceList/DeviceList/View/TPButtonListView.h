//
//  TPButtonListView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/7.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPBaffleView.h"

@protocol TPButtonListViewBtnDelegate <NSObject>

- (void)refreshTime:(NSString *)timeString;

@end

@interface TPButtonListView : TPBaffleView

@property (nonatomic, weak) id<TPButtonListViewBtnDelegate> delegate;

@end
