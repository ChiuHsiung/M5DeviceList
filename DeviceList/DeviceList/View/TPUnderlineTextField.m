//
//  TPUnderlineTextField.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/15.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPUnderlineTextField.h"

#define kTextFielfClearButton_Color         [UIColor colorWithHexString:@"084044"]

static CGFloat const customClearBtn_height =            20.0f;

static CGFloat const text_margin_x = customClearBtn_height + 5.0f;

static CGFloat const text_margin_y = 10.0f;

@implementation TPUnderlineTextField

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _initStyle];
    }
    return self;
}

- (void)_initStyle
{
    self.borderStyle = UITextBorderStyleNone;
    
    UIView *line=[[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(1));
        
    }];
    
    UIButton *customClearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, customClearBtn_height, customClearBtn_height)];
    customClearBtn.layer.borderColor = kTextFielfClearButton_Color.CGColor;
    customClearBtn.layer.borderWidth = 1.0f;
    customClearBtn.layer.cornerRadius = customClearBtn_height / 2;
    customClearBtn.layer.masksToBounds = NO;
    [customClearBtn setTitle:@"✕" forState:UIControlStateNormal];
    customClearBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    customClearBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [customClearBtn setTitleColor:kTextFielfClearButton_Color forState:UIControlStateNormal];
    [customClearBtn addTarget:self action:@selector(clearBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = customClearBtn;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    
    
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    borderStyle = UITextBorderStyleNone;
}

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode
{
    clearButtonMode = UITextFieldViewModeNever;
}

//控制显示文本位置
-(CGRect)textRectForBounds:(CGRect)bounds {

    CGRect inset =CGRectMake(bounds.origin.x, bounds.origin.y + text_margin_y, bounds.size.width, bounds.size.height - text_margin_y * 2);
    return inset;
    
}

//控制编辑文本位置
-(CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect inset =CGRectMake(bounds.origin.x, bounds.origin.y + text_margin_y, bounds.size.width - text_margin_x, bounds.size.height - text_margin_y * 2);
    return inset;
    
}

#pragma mark - 点击事件
- (void)clearBtnOnClicked:(id)sender
{
    BOOL clearAllowed = true;
    if ([self.delegate respondsToSelector:@selector(textFieldShouldClear:)])
    {
        if (![self.delegate textFieldShouldClear:self])
        {
            clearAllowed = false;
        }
    }
    if (clearAllowed)
    {
        self.text = @"";
    }
    
    
}


@end
