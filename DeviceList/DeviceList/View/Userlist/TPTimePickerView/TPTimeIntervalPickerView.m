//
//  TPTimeIntervalPickerView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/12.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPTimeIntervalPickerView.h"

#import "TPTimePickerCell.h"

static CGFloat const component_width =      50.0f;
static CGFloat const row_height      =      50.0f;

@interface TPTimeIntervalPickerView()

@property(nonatomic,strong)     UIPickerView *pickerView;

@property (nonatomic,strong)    NSArray *hourArr;
@property (nonatomic,strong)    NSArray *minArr;


//当前小时
@property (nonatomic,copy)      NSString *curHourStr;

//当前分钟
@property (nonatomic,copy)      NSString *curMinStr;

@end

@implementation TPTimeIntervalPickerView

@synthesize selectedTime = _selectedTime;

- (void)initWithPickView:(UIPickerView *)pickView andHourArray:(NSArray *)hourArray andMinArr:(NSArray *)minArray andTime:(NSString *)timeString
{
    self.pickerView = pickView;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.hourArr = hourArray;
    self.minArr = minArray;
    
    self.selectedTime = timeString;
    [self initPickerViewSelectedItem];
}

- (NSString *)selectedTime
{
    int min = [_curMinStr intValue];
    if (min == 30)
    {
        _selectedTime = [NSString stringWithFormat:@"%@.5 %@", _curHourStr, @"Hours"];
    }
    else
    {
        _selectedTime = [NSString stringWithFormat:@"%@ %@", _curHourStr, @"Hours"];
    }
    
    return _selectedTime;
}

- (void)setSelectedTime:(NSString *)selectedTime
{
    _selectedTime = selectedTime;
    //格式是   4 Hours 或 4.5 Hours，后续再改
    NSString *timeIntervalStr = [selectedTime componentsSeparatedByString:@" "][0];
    if ([timeIntervalStr hasSuffix:@".5"])
    {
        _curHourStr = [timeIntervalStr componentsSeparatedByString:@"."][0];
        _curMinStr  = @"30";
    }
    else
    {
        _curHourStr = timeIntervalStr;
        _curMinStr  = @"00";
    }
    
}

- (void)initPickerViewSelectedItem
{
    int i = 0;
    
    for (i = 0; i < self.hourArr.count; i++)
    {
        NSString *item = self.hourArr[i];
        if ([self.curHourStr isEqualToString:item])
        {
            break;
        }
    }
    [self.pickerView selectRow:i inComponent:0 animated:YES];
    
    for (i = 0; i < self.minArr.count; i++)
    {
        NSString *item = self.minArr[i];
        if ([self.curMinStr isEqualToString:item])
        {
            break;
        }
    }
    [self.pickerView selectRow:i inComponent:2 animated:YES];
}

#pragma mark UIPickerViewDataSource,UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.hourArr.count;
    }
    else if (component == 2)
    {
        return self.minArr.count ;
    }
    
    else
    {
        return 1;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return component_width;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return row_height;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //加白色分割条，但不推荐这么做。
    if (pickerView.subviews.count >= 3)
    {
        [pickerView.subviews[1] setBackgroundColor:[UIColor whiteColor]];
        [pickerView.subviews[2] setBackgroundColor:[UIColor whiteColor]];
    }
    
    TPTimePickerCell *cell = [[TPTimePickerCell alloc]initWithFrame:CGRectMake(0, 0, component_width, row_height)];
    
    if (component == 0)
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",self.hourArr[row]];
    }
    
    else if (component == 2)
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.minArr[row]];
        
    }
    
    else if (component == 1)
    {
        cell.titleLabel.text = @"h";
    }
    else if (component == 3)
    {
        cell.titleLabel.text = @"min";
    }
    
    
    return cell;
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.curHourStr = self.hourArr[row];
    }

    else if (component == 2)
    {
        self.curMinStr = self.minArr[row];
    }
    
}


@end
