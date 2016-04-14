//
//  TPLineBandView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPDeviceInfoView;
@class TPNetworkSpeed;
@class TPIntelligentPriorityTimeView;

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

@protocol TPLineBandViewDelegate <NSObject>

- (void)removePanGestrueFromAllOtherTPLineBandView:(id)sender;
- (void)addPanGestrueToAllTPLineBandView;

- (void)deleteTPLineBandView:(id)sender;

- (void)tpLineBandViewOnClicked:(id)sender;

@end

@interface TPLineBandView : UIView

@property (nonatomic,strong)            UIColor *strokeColor;
@property (nonatomic,assign)            CGFloat lineWidth;

//TPDeviceInfoView属性
@property (nonatomic,strong)            NSString *deviceType;

//显示ParentCtrl的View属性
@property (nonatomic,strong)            NSString *intelligentPriorityTime;

//显示设备名的View属性
@property (nonatomic,strong)            NSString *deviceName;

//显示网速的View属性
@property (nonatomic,assign)            int downloadSpeed;
@property (nonatomic,assign)            int uploadSpeed;


@property (nonatomic,readonly)          CAShapeLayer *drawLayer;
@property (nonatomic,assign)            CFTimeInterval duration;
@property (nonatomic,assign)            LineBandProperty property;
@property (nonatomic,assign)            POINTMOVED_TYPE pointMoved;//-1, 0, 1分别表示没动，上点动，以及下点动

//显示设备类型的View
@property (nonatomic,strong)            TPDeviceInfoView *deviceInfoView;
//显示智能优先的View
@property (nonatomic,strong)            TPIntelligentPriorityTimeView *intelligentPriorityTimeView;
//显示设备名的View
@property (nonatomic,strong)            UILabel *deviceNameLabel;
//显示网速的View
@property (nonatomic,strong)            TPNetworkSpeed *networkSpeedView;

@property (nonatomic,strong)            TPLineBandView *nextLineBandView;

@property (nonatomic,weak)              id<TPLineBandViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame
     andStrokeColor:(UIColor *)strokeColor
       andLineWidth:(CGFloat)lineWidth
       andMaxOffset:(CGFloat)maxOffset
        andDelegate:(id)someOne
   andCircleCenterX:(CGFloat)circleCenterX;


- (void)pullWithOffSetX:(CGFloat)offSetX andOffsetY:(CGFloat)offsetY;
- (void)recoverStateAnimation:(BOOL)isNeedAnimation;
- (void)resetDefault;

- (void)addPanGestureRecognizerToDeviceInfoView;
- (void)removePanGestureRecognizerFromDeviceInfoView;

@end
