//
//  TPTimePickerCell.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/11.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPTimePickerCell.h"

@implementation TPTimePickerCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(UILabel *)titleLabel
{
    if (_titleLabel)
    {
        return _titleLabel;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont systemFontOfSize:20];
    
    _titleLabel = label;
    
    return _titleLabel;
}

@end
