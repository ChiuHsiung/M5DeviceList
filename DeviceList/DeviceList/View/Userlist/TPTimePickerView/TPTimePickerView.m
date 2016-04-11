//
//  TPTimePickerView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/11.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPTimePickerView.h"

#import "TPTimePickerCell.h"


static CGFloat const component_width =      100.0f;
static CGFloat const row_height      =      50.0f;

@interface TPTimePickerView()

@property(nonatomic,strong)     UIPickerView *pickerView;

@property (nonatomic,strong)    NSArray *ampmArr;
@property (nonatomic,strong)    NSArray *hourArr;
@property (nonatomic,strong)    NSArray *minArr;

//当前上下午
@property (nonatomic,copy)      NSString *curAmPmStr;

//当前小时
@property (nonatomic,copy)      NSString *curHourStr;

//当前分钟
@property (nonatomic,copy)      NSString *curMinStr;


@end

@implementation TPTimePickerView

@synthesize selectedTime = _selectedTime;

- (void)initWithPickView:(UIPickerView *)pickView andAmPmArray:(NSArray *)ampmArray andHourArray:(NSArray *)hourArray andMinArr:(NSArray *)minArray andTime:(NSString *)timeString
{
    self.pickerView = pickView;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.ampmArr = ampmArray;
    self.hourArr = hourArray;
    self.minArr = minArray;
    
    self.selectedTime = timeString;
    [self initPickerViewSelectedItem];
}

- (NSString *)selectedTime
{
    _selectedTime = [NSString stringWithFormat:@"%@:%@ %@", _curHourStr, _curMinStr, _curAmPmStr];
    return _selectedTime;
}

- (void)setSelectedTime:(NSString *)selectedTime
{
    _selectedTime = selectedTime;
    //格式是   8:00 AM
    _curAmPmStr = [selectedTime substringWithRange:NSMakeRange(selectedTime.length - 2, 2)];
    _curHourStr = [selectedTime componentsSeparatedByString:@":"][0];
    _curMinStr  = [[selectedTime componentsSeparatedByString:@":"][1] substringWithRange:NSMakeRange(0, 2)];
}

- (void)initPickerViewSelectedItem
{
    int i = 0;
    for (i = 0; i < self.ampmArr.count; i++)
    {
        NSString *item = self.ampmArr[i];
        if ([self.curAmPmStr isEqualToString:item])
        {
            break;
        }
    }
    [self.pickerView selectRow:i inComponent:0 animated:YES];
    
    for (i = 0; i < self.hourArr.count; i++)
    {
        NSString *item = self.hourArr[i];
        if ([self.curHourStr isEqualToString:item])
        {
            break;
        }
    }
    [self.pickerView selectRow:i inComponent:1 animated:YES];
    
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
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.ampmArr.count;
    }
    else if(component == 1)
    {
        return self.hourArr.count ;
    }
    else
    {
        return self.minArr.count ;
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
    
    TPTimePickerCell *cell = [[TPTimePickerCell alloc]initWithFrame:CGRectMake(0, 0, component_width, row_height)];
    
    if (component == 0)
    {
        cell.titleLabel.text =[NSString stringWithFormat:@"%@",self.ampmArr[row]];
    }
    
    else if (component == 1)
    {
        cell.titleLabel.text= [NSString stringWithFormat:@"%@", self.hourArr[row]];
    }
    
    else
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.minArr[row]];
        
    }
    
    
    return cell;
    
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.curAmPmStr = self.ampmArr[row];
    }
    
    else if(component==1)
    {
        self.curHourStr = self.hourArr[row];
    }
    
    else
    {
        self.curMinStr = self.minArr[row];
    }

}


@end
