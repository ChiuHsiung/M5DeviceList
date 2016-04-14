//
//  TPBedTimePicker.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/11.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPBedTimePicker.h"

#import "TPTimePickerView.h"

static CGFloat const closeButton_top_inset =            20.0f;
static CGFloat const closeButton_left_inset =           10.0f;

static CGFloat const pickerView_width =                 300.0f;
static CGFloat const pickerView_row_height =            50.0f;
static int     const pickerView_display_row =           3;

static CGFloat const button_top_inset =                 20.0f;
static CGFloat const button_width =                     100.0f;


@interface TPBedTimePicker()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, assign) BOOL isBedTime;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) TPTimePickerView *timePickerView;//主要为了实现pickerView的Delegate

@end

@implementation TPBedTimePicker

- (id)initWithHostView:(UIView *)hostView
{
    self = [super initWithHostView:hostView];
    if (self != nil)
    {
        UIButton *closeButton = [[UIButton alloc] init];
        [self addSubview:closeButton];
        [closeButton setTitle:@"×" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:40];
        [closeButton sizeToFit];
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).offset(closeButton_top_inset);
            make.left.equalTo(self).offset(closeButton_left_inset);
            
        }];
        
        UIView *container = [[UIView alloc] init];
        [self addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(self).multipliedBy(0.85);
            
        }];
        
        self.textLabel = [[UILabel alloc] init];
        [container addSubview:self.textLabel];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:20.0];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(container);
            make.centerX.equalTo(container);
            make.width.equalTo(container);
            
        }];
        
        self.pickerView = [[UIPickerView alloc] init];
        [container addSubview:self.pickerView];
        self.pickerView.showsSelectionIndicator = YES;
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(container);
            make.width.equalTo(@(pickerView_width));
            make.centerY.equalTo(container);
            make.height.equalTo(@(pickerView_row_height * pickerView_display_row));
            
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [container addSubview:btn];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 10.0f;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.pickerView.mas_bottom).offset(button_top_inset);
            make.centerX.equalTo(container);
            make.width.equalTo(@(button_width));
            make.bottom.equalTo(container);
            
        }];
        
        
    }
    return self;
}

- (void)updateTime:(NSString *)timeString withIsBedTime:(BOOL)isBedTime
{
    self.timeString = timeString;
    self.isBedTime = isBedTime;
    
    if (isBedTime)
    {
        self.textLabel.text = @"睡觉时间";
    }
    
    else
    {
        self.textLabel.text = @"起床时间";
    }
    
    if (nil == self.timePickerView)
    {
        NSArray *ampmArr = @[@"AM", @"PM"];
        NSArray *hourArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        NSMutableArray *minArr = [[NSMutableArray alloc] initWithArray:@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09"]];
        for (int i = 10; i <= 59; i++)
        {
            [minArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
        self.timePickerView = [[TPTimePickerView alloc] init];
        [self.timePickerView initWithPickView:self.pickerView andAmPmArray:ampmArr andHourArray:hourArr andMinArr:minArr andTime:timeString];
    }
    
}

- (void)btnOnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(refreshTime:withIsBedTime:)])
    {
        [self.delegate refreshTime:self.timePickerView.selectedTime withIsBedTime:self.isBedTime];
    }
    
    [self dismiss];
}

@end
