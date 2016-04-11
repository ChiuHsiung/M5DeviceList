//
//  TPTimePickerView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/11.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTimePickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

//选中时间
@property (nonatomic,copy)NSString *selectedTime;

-(void)initWithPickView:(UIPickerView *)pickView andAmPmArray:(NSArray *)ampmArray  andHourArray:(NSArray *)hourArray andMinArr:(NSArray *)minArray andTime:(NSString *)timeString;



@end
