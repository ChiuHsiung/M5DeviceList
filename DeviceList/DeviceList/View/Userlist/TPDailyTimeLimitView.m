//
//  TPDailyTimeLimitView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/7.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPDailyTimeLimitView.h"

static CGFloat const closeButton_top_inset =            20.0f;
static CGFloat const closeButton_left_inset =           10.0f;

static CGFloat const buttonlist_top_inset =             20.0f;
static CGFloat const buttonlist_width =                 100.0f;
static CGFloat const button_between_inset =             10.0f;

@implementation TPDailyTimeLimitView

-(id) initWithHostView:(UIView *)hostView
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
        
        UILabel *textLabel = [[UILabel alloc] init];
        [container addSubview:textLabel];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.text = @"选择Daily time limit";
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(container);
            make.centerX.equalTo(container);
            make.width.equalTo(container);
            
        }];
        
        UIView *buttonListContainer = [[UIView alloc] init];
        [container addSubview:buttonListContainer];
        [buttonListContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(textLabel.mas_bottom).offset(buttonlist_top_inset);
            make.bottom.equalTo(container);
            make.centerX.equalTo(container);
            make.width.equalTo(@(buttonlist_width));
            
        }];
        
        NSString *hourString = @"Hours";
        NSMutableArray *timeArray = [[NSMutableArray alloc] init];
        [timeArray addObject:[NSString stringWithFormat:@"%d %@", 1, hourString]];
        [timeArray addObject:[NSString stringWithFormat:@"%d %@", 2, hourString]];
        [timeArray addObject:[NSString stringWithFormat:@"%d %@", 4, hourString]];
        [timeArray addObject:[NSString stringWithFormat:@"%d %@", 8, hourString]];
        [timeArray addObject:[NSString stringWithFormat:@"%d %@", 12, hourString]];
        
        //规划按钮
        UIButton *btn0 = [[UIButton alloc] init];
        [buttonListContainer addSubview:btn0];
        btn0.layer.borderColor = [UIColor whiteColor].CGColor;
        btn0.layer.borderWidth = 1.0f;
        btn0.layer.cornerRadius = 10.0f;
        [btn0 setTitle:timeArray[0] forState:UIControlStateNormal];
        btn0.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        btn0.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn0 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn0 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(buttonListContainer);
            make.left.equalTo(buttonListContainer);
            make.right.equalTo(buttonListContainer);
            
        }];
        
        UIButton *btn1 = [[UIButton alloc] init];
        [buttonListContainer addSubview:btn1];
        btn1.layer.borderColor = [UIColor whiteColor].CGColor;
        btn1.layer.borderWidth = 1.0f;
        btn1.layer.cornerRadius = 10.0f;
        [btn1 setTitle:timeArray[1] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn1 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(btn0.mas_bottom).offset(button_between_inset);
            make.left.equalTo(buttonListContainer);
            make.right.equalTo(buttonListContainer);
            
        }];
        
        UIButton *btn2 = [[UIButton alloc] init];
        [buttonListContainer addSubview:btn2];
        btn2.layer.borderColor = [UIColor whiteColor].CGColor;
        btn2.layer.borderWidth = 1.0f;
        btn2.layer.cornerRadius = 10.0f;
        [btn2 setTitle:timeArray[2] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn2 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(btn1.mas_bottom).offset(button_between_inset);
            make.left.equalTo(buttonListContainer);
            make.right.equalTo(buttonListContainer);
            
        }];
        
        UIButton *btn3 = [[UIButton alloc] init];
        [buttonListContainer addSubview:btn3];
        btn3.layer.borderColor = [UIColor whiteColor].CGColor;
        btn3.layer.borderWidth = 1.0f;
        btn3.layer.cornerRadius = 10.0f;
        [btn3 setTitle:timeArray[3] forState:UIControlStateNormal];
        btn3.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn3 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(btn2.mas_bottom).offset(button_between_inset);
            make.left.equalTo(buttonListContainer);
            make.right.equalTo(buttonListContainer);
            
        }];
        
        UIButton *btn4 = [[UIButton alloc] init];
        [buttonListContainer addSubview:btn4];
        btn4.layer.borderColor = [UIColor whiteColor].CGColor;
        btn4.layer.borderWidth = 1.0f;
        btn4.layer.cornerRadius = 10.0f;
        [btn4 setTitle:timeArray[4] forState:UIControlStateNormal];
        btn4.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
        btn4.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn4 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(btn3.mas_bottom).offset(button_between_inset);
            make.left.equalTo(buttonListContainer);
            make.right.equalTo(buttonListContainer);
            make.bottom.equalTo(buttonListContainer);
            
        }];
        
    }
    
    return self;
}

- (void)btnOnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(refreshDailyTimeLimit:)])
    {
        [self.delegate refreshDailyTimeLimit:sender.titleLabel.text];
    }
    
    [self dismiss];
}

@end
