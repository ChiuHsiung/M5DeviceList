//
//  TPBlockView.h
//  Devicelist
//
//  Created by zhuangqiuxiong on 16/3/26.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPBlockView : UIView

@property (nonatomic,assign) float curProcess;
@property (nonatomic,assign, readonly) float totalProcess;

@property (nonatomic,strong) UIColor *bgViewColor;
@property (nonatomic,strong) UIColor *progressColor;

//为了以后多语言适配时的宽度调整，把这个属性公开
@property (nonatomic,strong) UILabel *tipsLabel;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andTotalProgress:(float)totalProgress;

@end
