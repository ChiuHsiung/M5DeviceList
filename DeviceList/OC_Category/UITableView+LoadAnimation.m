//
//  UITableView+LoadAnimation.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/18.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "UITableView+LoadAnimation.h"


@implementation UITableView (UITableView_LoadAnimation)

- (void)reloadDataWithAnimate:(AnimationDirect)direct andAnimationTime:(NSTimeInterval)animationTime andInterval:(NSTimeInterval)interval andFinishAnimation:(void (^)(void))finishAnimate
{
    [self setContentOffset:self.contentOffset animated:false];
    [UIView animateWithDuration:0.2 animations:^{
        
        self.hidden = true;
        [self reloadData];
        
    } completion:^(BOOL finished) {
        
        self.hidden = false;
        
        [self visibleRowsBeginAnimation:direct andAnimationTime:animationTime andInterval:interval andFinishAnimation:finishAnimate];
    }];
}

- (void)insertRowsAtIndexPath:(NSIndexPath *)indexPath andAnimationTime:(NSTimeInterval)animationTime andFinishAnimation:(void (^)(void))finishAnimate
{
    [self reloadData];
    [self setContentOffset:CGPointMake(0, self.contentSize.height - self.bounds.size.height) animated:NO];
    UITableViewCell *cell = (UITableViewCell *)[self cellForRowAtIndexPath:indexPath];
    cell.alpha = 0;
    CGPoint originPoint = cell.center;
    cell.center = CGPointMake(originPoint.x, originPoint.y + cell.frame.size.height * 2);
    [UIView animateWithDuration:animationTime
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         cell.center = CGPointMake(originPoint.x ,  originPoint.y);
                         cell.alpha = 1;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         finishAnimate();
                         
                     }];
    
    
}

- (void)visibleRowsBeginAnimation:(AnimationDirect)direct andAnimationTime:(NSTimeInterval)animationTime andInterval:(NSTimeInterval)interval andFinishAnimation:(void (^)(void))finishAnimate
{
    NSArray *visibleArray = self.indexPathsForVisibleRows;
    int count = (int)visibleArray.count;
    switch (direct)
    {
        case DropDownFromTop:
        {
            
            break;
        }
            
        case LiftUpFromBottum:
        {
//            NSTimeInterval delay = 0;
            for (int i = 0; i < count; i++)
            {
                NSIndexPath *path = (NSIndexPath *)visibleArray[i];
                UITableViewCell *cell = (UITableViewCell *)[self cellForRowAtIndexPath:path];
                cell.alpha = 0;
                CGPoint originPoint = cell.center;
                cell.center = CGPointMake(originPoint.x, originPoint.y + cell.frame.size.height * 2);
                [UIView animateWithDuration:animationTime + interval * i delay:0 options:UIViewAnimationOptionCurveEaseIn
                                 animations:^{
                                     
                                     cell.center = CGPointMake(originPoint.x ,  originPoint.y + 2.0f);
                                     cell.alpha = 0.3;
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     
                                     [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                                      animations:^{
                                                          
                                                          cell.center = CGPointMake(originPoint.x ,  originPoint.y);
                                                          cell.alpha = 1;
                                                          
                                                      }
                                                      completion:^(BOOL finished) {
                                                          
                                                          if (i == count - 1)
                                                          {
                                                              finishAnimate();
                                                          }
                                                          
                                                      }
                                      ];
                                     
                                 }
                 ];
//                delay += interval;
            }
            break;
        }
            
        case FromLeftToRight:
        {
            
            break;
        }
            
        case FromRightToLeft:
        {
            
            break;
        }
            
            
        default:
            break;
    }
}

@end
