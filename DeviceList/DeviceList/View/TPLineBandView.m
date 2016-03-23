//
//  TPLineBandView.m
//  RubberBandView
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPLineBandView.h"

#import <QuartzCore/QuartzCore.h>

static CFTimeInterval defaultDuration = 0.3;

//加速度
static float acceleration(float time,float space) {
    return space*2/(time*time);
}

@interface TPLineBandView()
{
    CFTimeInterval _beginTime;
    CFTimeInterval _animationRegisteredTime;
    CADisplayLink *_link;
    LineBandProperty _currentProperty;
    LineBandProperty _beginProperty;
    
}

@property (nonatomic,strong)CAShapeLayer *drawLayer;

@end

@implementation TPLineBandView

- (void)dealloc {
    if (_link) [_link invalidate];
}

#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _init];
}

- (id)initWithFrame:(CGRect)frame layerProperty:(LineBandProperty)property {
    if (self = [super initWithFrame:frame]) {
        [self _init];
        self.property = property;
    }
    return self;
}

- (void)_init {
    self.drawLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_drawLayer];
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeUpdate:)];
    _link.paused = YES;
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - attributes
- (void)setProperty:(LineBandProperty)property {
    _property = property;
    [self resetDefault];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    if (_drawLayer) _drawLayer.strokeColor = strokeColor.CGColor;
    [self resetDefault];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    if (_drawLayer) _drawLayer.lineWidth = lineWidth;
    [self resetDefault];
}

- (void)resetDefault {
    _beginProperty = CopyLBProperty(_property);
    self.pointMoved = POINTMOVED_TYPE_NONE;
    UIBezierPath *path = [self pullPathWithOffsetX:0 andOffsetY:0 toOut:YES];//当0，0时 andIsUpPointMoved的参数不重要
    [self redrawWithPath:path.CGPath];
}

#pragma mark - action

- (void)pullWithOffSetX:(CGFloat)offSetX andOffsetY:(CGFloat)offsetY{
    UIBezierPath *path = [self pullPathWithOffsetX:offSetX andOffsetY:offsetY toOut:YES];
    [self redrawWithPath:path.CGPath];
}

- (void)recoverStateAnimation {
    _beginProperty = CopyLBProperty(_currentProperty);
    if (_duration == 0) _duration = defaultDuration;
    _beginTime = 0;
    _animationRegisteredTime = [_drawLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    if (_link) _link.paused = NO;
}

#pragma mark - path
- (UIBezierPath *)pullPathWithOffsetX:(CGFloat)currentOffsetX andOffsetY:(CGFloat)currentOffsetY toOut:(BOOL)toOut{
    
    if (fabs(_beginProperty.downPoint.x - _beginProperty.upPoint.x) == 0 && fabs(_beginProperty.downPoint.y - _beginProperty.upPoint.y) == 0) return nil;
    CGFloat upX, upY, downX, downY;
    upX = _beginProperty.upPoint.x;
    upY = _beginProperty.upPoint.y;
    downX = _beginProperty.downPoint.x;
    downY = _beginProperty.downPoint.y;
    if (toOut) {
        
        if (self.pointMoved == POINTMOVED_TYPE_UP)
        {
            upX = upX + currentOffsetX;
            upY = upY + currentOffsetY;
        }
        
        else if(self.pointMoved == POINTMOVED_TYPE_DOWN)
        {
            downX = downX + currentOffsetX;
            downY = downY + currentOffsetY;
        }
        
    }else {
//        width = _property.width + currentOffset;
//        orignX = _beginProperty.x;
        if (self.pointMoved == POINTMOVED_TYPE_UP)
        {
            upX = _property.upPoint.x + currentOffsetX;
            upY = _property.upPoint.y + currentOffsetY;
        }
        
        else if(self.pointMoved == POINTMOVED_TYPE_DOWN)
        {
            downX = _property.downPoint.x + currentOffsetX;
            downY = _property.downPoint.y + currentOffsetY;
        }
    }
    
    _currentProperty = MakeLBProperty(upX, upY, downX, downY, _beginProperty.maxOffSet);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(upX, upY)];
    [path addLineToPoint:CGPointMake(downX, downY)];
    
    return path;
    
}


#pragma mark - animation
- (void)render {
    CFTimeInterval time = [_drawLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    if (time - _animationRegisteredTime < _beginTime)return;
    float runtime = time - _beginTime - _animationRegisteredTime;
    
    if (runtime >= _duration) {
        _link.paused = YES;
        [self animationStop];
        return;
    }
    
    
//    //回弹处理
//    
//    CGPathRef path;
//    
//    float partTime1 = _duration/2;
//    float partTime2 = (_duration - partTime1)/2;
//    float partTime3 = (_duration - partTime1 - partTime2);
//    
//    float partSpace1 = 0 , partSpace2 = 0 , partSpace3 = 0;
//    
//    float offSetX = 0;
//    float offSetY = 0;
//    if (self.pointMoved == POINTMOVED_TYPE_UP)
//    {
//        offSetX = (_beginProperty.upPoint.x - _property.upPoint.x);
//        offSetY = (_beginProperty.upPoint.y - _property.upPoint.y);
//    }
//    
//    else if (self.pointMoved == POINTMOVED_TYPE_DOWN)
//    {
//        offSetX = (_beginProperty.downPoint.x - _property.downPoint.x);
//        offSetY = (_beginProperty.downPoint.y - _property.downPoint.y);
//    }
//    
//    float x = offSetX/[self lineLenth:_property];//内缩倍数
//    if (x>1) x = 1;
//    float inset = x * ([self lineLenth:_property]/2);//对比正常内缩距离,系数 * 正常宽度的一半
//    
//    partSpace1 = [self lineLenth:_beginProperty] - [self lineLenth:_property] + inset;//总回弹距离
//    partSpace2 = inset + x*([self lineLenth:_property]/3);//第二次弹出距离
//    partSpace3 = x*([self lineLenth:_property]/3);//回到正常的距离
//    
//    float partSpacey1 = 0 , partSpacey2 = 0 , partSpacey3 = 0;
//    
//    float y = offSetY/[self lineLenth:_property];//内缩倍数
//    if (y>1) y = 1;
//    float insetY = y * ([self lineLenth:_property]/2);//对比正常内缩距离,系数 * 正常宽度的一半
//    
//    partSpacey1 = [self lineLenth:_beginProperty] - [self lineLenth:_property] + inset;//总回弹距离
//    partSpacey2 = inset + y*([self lineLenth:_property]/3);//第二次弹出距离
//    partSpacey3 = y*([self lineLenth:_property]/3);//回到正常的距离
//    
//    if (fabs(offSetX) >= fabs(offSetY))
//    {
//        
//        if(runtime<=partTime1)//拉倒极限后反弹
//        {
//            float time = runtime;
//            float a = acceleration(partTime1,partSpace1);
//            float space = a*time*time/2;
//            
//            float b = acceleration(partTime1,partSpacey1);
//            float spacey = b*time*time/2;
//            
//            //        path = [self pullPathWithOffsetX:offSetX - space andOffsetY:offSetY - spacey toOut:NO].CGPath;
//            path = [self pullPathWithOffsetX:offSetX - space andOffsetY:0 toOut:NO].CGPath;
//        }
//        else if(runtime <= partTime1+partTime2)
//        {
//            float time = runtime-partTime1;
//            float a = acceleration(partTime2,partSpace2);
//            float space = a*time*time/2;
//            
//            float b = acceleration(partTime2,partSpacey2);
//            float spacey = b*time*time/2;
//            
//            //        path = [self pullPathWithOffsetX:- inset + space andOffsetY:- inset + spacey toOut:NO].CGPath;
//            path = [self pullPathWithOffsetX:- inset + space andOffsetY:0 toOut:NO].CGPath;
//        }else
//        {
//            float time = runtime-partTime1-partTime2;
//            float a = acceleration(partTime3,partSpace3);
//            float space = a*time*time/2;
//            
//            float b = acceleration(partTime3,partSpacey3);
//            float spacey = b*time*time/2;
//            
//            //        path = [self pullPathWithOffsetX:partSpace3 - space andOffsetY:partSpacey3 - spacey toOut:NO].CGPath;
//            path = [self pullPathWithOffsetX:partSpace3 - space andOffsetY:0 toOut:NO].CGPath;
//        }
//        
//    }
//    
//    else
//    {
//        
//        if(runtime<=partTime1)//拉倒极限后反弹
//        {
//            float time = runtime;
//            float a = acceleration(partTime1,partSpace1);
//            float space = a*time*time/2;
//            
//            float b = acceleration(partTime1,partSpacey1);
//            float spacey = b*time*time/2;
//            
//            //        path = [self pullPathWithOffsetX:offSetX - space andOffsetY:offSetY - spacey toOut:NO].CGPath;
//            path = [self pullPathWithOffsetX:0 andOffsetY:offSetY - spacey toOut:NO].CGPath;
//        }
//        else if(runtime <= partTime1+partTime2)
//        {
//            float time = runtime-partTime1;
//            float a = acceleration(partTime2,partSpace2);
//            float space = a*time*time/2;
//            
//            float b = acceleration(partTime2,partSpacey2);
//            float spacey = b*time*time/2;
//            
//            //        path = [self pullPathWithOffsetX:- inset + space andOffsetY:- inset + spacey toOut:NO].CGPath;
//            path = [self pullPathWithOffsetX:0 andOffsetY:- inset + spacey toOut:NO].CGPath;
//        }else
//        {
//            float time = runtime-partTime1-partTime2;
//            float a = acceleration(partTime3,partSpace3);
//            float space = a*time*time/2;
//            
//            float b = acceleration(partTime3,partSpacey3);
//            float spacey = b*time*time/2;
//            
//            //        path = [self pullPathWithOffsetX:partSpace3 - space andOffsetY:partSpacey3 - spacey toOut:NO].CGPath;
//            path = [self pullPathWithOffsetX:0 andOffsetY:partSpacey3 - spacey toOut:NO].CGPath;
//        }
//        
//        
//    }
//    
//    
//    
//    
//    [self redrawWithPath:path];
}

- (void)animationStop {
//    _beginProperty = CopyLBProperty(_property);
//    if (self.pointMoved == POINTMOVED_TYPE_UP)
//    {
//        _property.upPoint.x = _beginProperty.upPoint.x;
//        _property.upPoint.y = _beginProperty.upPoint.y;
//    }
//    else if (self.pointMoved == POINTMOVED_TYPE_DOWN)
//    {
//        _property.downPoint.x = _beginProperty.downPoint.x;
//        _property.downPoint.y = _beginProperty.downPoint.y;
//    }
    
    [self resetDefault];
    
    [self transitionWithType:kCATransitionFade withSubType:kCATransitionFromRight forView:self];
    
}

#pragma mark - redraw
- (void)redrawWithPath:(CGPathRef)path {
    _drawLayer.path = path;
}

#pragma mark  - animation transaction for ftp
- (void)timeUpdate:(CADisplayLink *)link {
    [self updateLayer];
}

- (void)updateLayer {
    [self render];
}

#pragma mark - utlity

- (float)lineLenth:(LineBandProperty)lbProperty
{
    float xDistance = fabs(lbProperty.upPoint.x - lbProperty.downPoint.x);
    float yDistance = fabs(lbProperty.upPoint.y - lbProperty.downPoint.y);
    return sqrtf(xDistance * xDistance + yDistance * yDistance);
}

// MARK: CATransition动画实现
- (void)transitionWithType:(NSString *)type withSubType:(NSString *)subType forView:(UIView *)view
{
    
    //创建CATransition对象
    CATransition *animation = [[CATransition alloc] init];
    
    //设置运动时间
    animation.duration = self.duration;
    
    //设置运动type
    animation.type = type;
    
    if (!subType)
    {
        //设置子类
        animation.subtype = subType;
    }
    
    //设置运动速度
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [view.layer addAnimation:animation forKey: @"animation"];
    
}


@end
