//
//  TPTimeIntervalPickerView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/12.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTimeIntervalPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

//选中时间
@property (nonatomic,copy)NSString *selectedTime;

-(void)initWithPickView:(UIPickerView *)pickView andHourArray:(NSArray *)hourArray andMinArr:(NSArray *)minArray andTime:(NSString *)timeString;

@end
