//
//  TPLineBandView.h
//  RubberBandView
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

struct  _LineBandProperty{
    
    CGPoint upPoint;
    CGPoint downPoint;
    CGFloat maxOffSet;//最大偏移量
    
};

typedef struct _LineBandProperty LineBandProperty;

static inline LineBandProperty
MakeLBProperty(CGFloat upX,CGFloat upY, CGFloat downX,CGFloat downY,CGFloat maxOffSet) {
    
    LineBandProperty property;
    property.upPoint.x = upX;
    property.upPoint.y = upY;
    property.downPoint.x = downX;
    property.downPoint.y = downY;
    property.maxOffSet = maxOffSet;//最大偏移量
    
    return property;
    
}

static inline LineBandProperty
CopyLBProperty(LineBandProperty property) {
    
    return MakeLBProperty(property.upPoint.x, property.upPoint.y, property.downPoint.x, property.downPoint.y, property.maxOffSet);
    
}

typedef NS_ENUM(int, POINTMOVED_TYPE)
{
    POINTMOVED_TYPE_NONE = -1,
    POINTMOVED_TYPE_UP,
    POINTMOVED_TYPE_DOWN
};

@interface TPLineBandView : UIView

@property (nonatomic,strong)            UIColor *strokeColor;
@property (nonatomic,assign)            CGFloat lineWidth;
@property (nonatomic,readonly)          CAShapeLayer *drawLayer;
@property (nonatomic,assign)            CFTimeInterval duration;
@property (nonatomic,assign)            LineBandProperty property;
@property (nonatomic,assign)            POINTMOVED_TYPE pointMoved;//-1, 0, 1分别表示没动，上点动，以及下点动


- (id)initWithFrame:(CGRect)frame layerProperty:(LineBandProperty)property;
- (void)pullWithOffSetX:(CGFloat)offSetX andOffsetY:(CGFloat)offsetY;
- (void)recoverStateAnimation;
- (void)resetDefault;

@end
