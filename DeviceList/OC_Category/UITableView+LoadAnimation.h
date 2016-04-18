//
//  UITableView+LoadAnimation.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/18.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnimationDirect){
    
    DropDownFromTop = 0,
    LiftUpFromBottum,
    FromRightToLeft,
    FromLeftToRight
    
};

@interface UITableView (UITableView_LoadAnimation)

/**
 *  UITableView重新加载动画
 *
 *  @param   direct    cell运动方向
 *  @param   time      动画持续时间，设置成1.0
 *  @param   interval  每个cell间隔，设置成0.1
 */
- (void)reloadDataWithAnimate:(AnimationDirect)direct andAnimationTime:(NSTimeInterval)animationTime andInterval:(NSTimeInterval)interval andFinishAnimation:(void (^)(void))finishAnimate;

/**
 *  UITableView插入行动画
 */
- (void)insertRowsAtIndexPath:(NSIndexPath *)indexPath andAnimationTime:(NSTimeInterval)animationTime andFinishAnimation:(void (^)(void))finishAnimate;

@end
