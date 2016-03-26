//
//  TPBlockView.h
//  Devicelist
//
//  Created by zhuangqiuxiong on 16/3/26.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPBlockView : UIView

@property (nonatomic,assign) float curProcess;
@property (nonatomic,assign, readonly) float totalProcess;

@property (nonatomic,strong) UIColor *bgViewColor;
@property (nonatomic,strong) UIColor *progressColor;

- (id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName andTotalProgress:(float)totalProgress;

@end
