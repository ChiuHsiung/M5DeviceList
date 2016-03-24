//
//  TPLineBandView.m
//  RubberBandView
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPLineBandView.h"

#import "TPDeviceInfoView.h"

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
    
    
    CGPoint _touchBeginPoint;
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
    [self _initLayer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _initLayer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame layerProperty:(LineBandProperty)property andStrokeColor:(UIColor *)strokeColor andLineWidth:(CGFloat)lineWidth andDeviceName:(NSString *)deviceName andDelegate:(id)someOne{
    if (self = [super initWithFrame:frame]) {
        [self _initLayer];
        self.property = property;
        self.strokeColor = strokeColor;
        self.lineWidth = lineWidth;
        self.deviceName = deviceName;
        [self _initDeviceInfoView];
        
        self.delegate = someOne;
    }
    return self;
}


- (void)_initLayer
{
    self.drawLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_drawLayer];
    
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeUpdate:)];
    _link.paused = YES;
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)_initDeviceInfoView {
    _deviceInfoView = [[TPDeviceInfoView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 2 * _property.maxOffSet, self.bounds.size.height - (_property.downPoint.y -  _property.upPoint.y)) withCircleColor:self.strokeColor andLineWidth:self.lineWidth andDeviceName:self.deviceName];
    _deviceInfoView.center = [self adjustDeviceInfoViewCenterWithOffsetX:0 andOffsetY:0];
//    _deviceInfoView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_deviceInfoView];
    [self addPanGestureRecognizerToDeviceInfoView];
    
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
    self.deviceInfoView.lineWidth = lineWidth;
    if (_drawLayer) _drawLayer.lineWidth = lineWidth;
    [self resetDefault];
}

- (void)setDeviceName:(NSString *)deviceName
{
    _deviceName = deviceName;
    if (self.deviceInfoView)
    {
        self.deviceInfoView.deviceName = deviceName;
    }
}

- (void)resetDefault {
    _beginProperty = CopyLBProperty(_property);
    self.pointMoved = POINTMOVED_TYPE_NONE;
    UIBezierPath *path = [self pullPathWithOffsetX:0 andOffsetY:0 toOut:YES];//当0，0时 andIsUpPointMoved的参数不重要
    [self redrawWithPath:path.CGPath];
    
    self.deviceInfoView.center = [self adjustDeviceInfoViewCenterWithOffsetX:0 andOffsetY:0];
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

//- (UIBezierPath *)bounceInPathWithOffset:(CGFloat)currentOffset {
//    if (_beginProperty.width<=0||_beginProperty.height<=0||
//        _property.width<=0||_property.height<=0) return nil;
//    CGFloat width = _beginProperty.width - currentOffset;
//    CGFloat x = fabs(_property.width/width);
//    if (x>1.5) x = 1.2;
//    CGFloat height = _property.height * x;
//    CGFloat orignX = _beginProperty.x + currentOffset;
//    CGFloat orignY = _property.y + (_property.height - height);
//    CGFloat radius = height/2;
//    _currentProperty = MakeRBProperty(orignX, orignY, width, height, _property.maxOffSet);
//    CGRect rect = CGRectMake(orignX, orignY, width, height);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
//    return path;
//}

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
    
    
    //回弹处理
    
    CGPathRef path;
    
    float partTime1 = _duration/2;
    float partTime2 = (_duration - partTime1)/2;
    float partTime3 = (_duration - partTime1 - partTime2);
    
    float partSpace1 = 0 , partSpace2 = 0 , partSpace3 = 0;
    
    float offSetX = 0;
    float offSetY = 0;
    if (self.pointMoved == POINTMOVED_TYPE_UP)
    {
        offSetX = (_beginProperty.upPoint.x - _property.upPoint.x);
        offSetY = (_beginProperty.upPoint.y - _property.upPoint.y);
    }
    
    else if (self.pointMoved == POINTMOVED_TYPE_DOWN)
    {
        offSetX = (_beginProperty.downPoint.x - _property.downPoint.x);
        offSetY = (_beginProperty.downPoint.y - _property.downPoint.y);
    }
    
    float x = offSetX/[self lineLenth:_property];//内缩倍数
    if (x>1) x = 1;
    float inset = x * ([self lineLenth:_property]/2);//对比正常内缩距离,系数 * 正常宽度的一半
    
    partSpace1 = [self lineLenth:_beginProperty] - [self lineLenth:_property] + inset;//总回弹距离
    partSpace2 = inset + x*([self lineLenth:_property]/3);//第二次弹出距离
    partSpace3 = x*([self lineLenth:_property]/3);//回到正常的距离
    
    float partSpacey1 = 0 , partSpacey2 = 0 , partSpacey3 = 0;
    
    float y = offSetY/[self lineLenth:_property];//内缩倍数
    if (y>1) y = 1;
    float insetY = y * ([self lineLenth:_property]/2);//对比正常内缩距离,系数 * 正常宽度的一半
    
    partSpacey1 = [self lineLenth:_beginProperty] - [self lineLenth:_property] + inset;//总回弹距离
    partSpacey2 = inset + y*([self lineLenth:_property]/3);//第二次弹出距离
    partSpacey3 = y*([self lineLenth:_property]/3);//回到正常的距离
    
    
    CGFloat deviceInfoViewCenterOffsetX = 0, deviceInfoViewCenterOffsetY = 0;
    if (fabs(offSetX) >= fabs(offSetY))
    {
        
        if(runtime<=partTime1)//拉倒极限后反弹
        {
            float time = runtime;
            float a = acceleration(partTime1,partSpace1);
            float space = a*time*time/2;
            
            float b = acceleration(partTime1,partSpacey1);
            float spacey = b*time*time/2;
            
            //        path = [self pullPathWithOffsetX:offSetX - space andOffsetY:offSetY - spacey toOut:NO].CGPath;
            path = [self pullPathWithOffsetX:offSetX - space andOffsetY:0 toOut:NO].CGPath;
            if (self.pointMoved == POINTMOVED_TYPE_DOWN)
            {
                deviceInfoViewCenterOffsetX = offSetX - space;
            }
        }
        else if(runtime <= partTime1+partTime2)
        {
            float time = runtime-partTime1;
            float a = acceleration(partTime2,partSpace2);
            float space = a*time*time/2;
            
            float b = acceleration(partTime2,partSpacey2);
            float spacey = b*time*time/2;
            
            //        path = [self pullPathWithOffsetX:- inset + space andOffsetY:- insetY + spacey toOut:NO].CGPath;
            path = [self pullPathWithOffsetX:- inset + space andOffsetY:0 toOut:NO].CGPath;
            if (self.pointMoved == POINTMOVED_TYPE_DOWN)
            {
                deviceInfoViewCenterOffsetX = - inset + space;
            }
        }else
        {
            float time = runtime-partTime1-partTime2;
            float a = acceleration(partTime3,partSpace3);
            float space = a*time*time/2;
            
            float b = acceleration(partTime3,partSpacey3);
            float spacey = b*time*time/2;
            
            //        path = [self pullPathWithOffsetX:partSpace3 - space andOffsetY:partSpacey3 - spacey toOut:NO].CGPath;
            path = [self pullPathWithOffsetX:partSpace3 - space andOffsetY:0 toOut:NO].CGPath;
            if (self.pointMoved == POINTMOVED_TYPE_DOWN)
            {
                deviceInfoViewCenterOffsetX = partSpace3 - space;
            }
        }
        
    }
    
    else
    {
        
        if(runtime<=partTime1)//拉倒极限后反弹
        {
            float time = runtime;
            float a = acceleration(partTime1,partSpace1);
            float space = a*time*time/2;
            
            float b = acceleration(partTime1,partSpacey1);
            float spacey = b*time*time/2;
            
            //        path = [self pullPathWithOffsetX:offSetX - space andOffsetY:offSetY - spacey toOut:NO].CGPath;
            path = [self pullPathWithOffsetX:0 andOffsetY:offSetY - spacey toOut:NO].CGPath;
            if (self.pointMoved == POINTMOVED_TYPE_DOWN)
            {
                deviceInfoViewCenterOffsetY = offSetY - spacey;
            }
        }
        else if(runtime <= partTime1+partTime2)
        {
            float time = runtime-partTime1;
            float a = acceleration(partTime2,partSpace2);
            float space = a*time*time/2;
            
            float b = acceleration(partTime2,partSpacey2);
            float spacey = b*time*time/2;
            
            //        path = [self pullPathWithOffsetX:- inset + space andOffsetY:- insetY + spacey toOut:NO].CGPath;
            path = [self pullPathWithOffsetX:0 andOffsetY:- inset + spacey toOut:NO].CGPath;
            if (self.pointMoved == POINTMOVED_TYPE_DOWN)
            {
                deviceInfoViewCenterOffsetY = - insetY + spacey;
            }
        }else
        {
            float time = runtime-partTime1-partTime2;
            float a = acceleration(partTime3,partSpace3);
            float space = a*time*time/2;
            
            float b = acceleration(partTime3,partSpacey3);
            float spacey = b*time*time/2;
            
            //        path = [self pullPathWithOffsetX:partSpace3 - space andOffsetY:partSpacey3 - spacey toOut:NO].CGPath;
            path = [self pullPathWithOffsetX:0 andOffsetY:partSpacey3 - spacey toOut:NO].CGPath;
            if (self.pointMoved == POINTMOVED_TYPE_DOWN)
            {
                deviceInfoViewCenterOffsetY = partSpacey3 - spacey;
            }
        }
        
        
    }
    
    
    
    
    [self redrawWithPath:path];
    
    self.deviceInfoView.center = [self adjustDeviceInfoViewCenterWithOffsetX:deviceInfoViewCenterOffsetX andOffsetY:deviceInfoViewCenterOffsetY];
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
    
    if ([self.delegate respondsToSelector:@selector(addPanGestrueToAllTPLineBandView)])
    {
        [self.delegate addPanGestrueToAllTPLineBandView];
    }
    
//    [self transitionWithType:kCATransitionFade withSubType:kCATransitionFromRight forView:self];
    
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

#pragma mark - Gesture Recognizers

- (void)addPanGestureRecognizerToDeviceInfoView
{
    [self removePanGestureRecognizerFromDeviceInfoView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_deviceInfoView addGestureRecognizer:panGesture];
}

- (void)removePanGestureRecognizerFromDeviceInfoView
{
    for (UIPanGestureRecognizer *recognizer in [_deviceInfoView gestureRecognizers]) {
        [_deviceInfoView removeGestureRecognizer:recognizer];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recoginzer
{
    CGPoint touchPoint = [recoginzer locationInView:self];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _touchBeginPoint = touchPoint;
        self.pointMoved = POINTMOVED_TYPE_DOWN;
        if (self.nextLineBandView)
        {
            self.nextLineBandView.pointMoved = POINTMOVED_TYPE_UP;
//            [self.nextLineBandView removePanGestureRecognizerFromDeviceInfoView];
        }
        if ([self.delegate respondsToSelector:@selector(removePanGestrueFromAllOtherTPLineBandView:)])
        {
            [self.delegate removePanGestrueFromAllOtherTPLineBandView:self];
        }
        
    }else if (recoginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offSetX = touchPoint.x - _touchBeginPoint.x;
        CGFloat offSetY = touchPoint.y - _touchBeginPoint.y;
        
        [self pullWithOffSetX:offSetX andOffsetY:0];
        if (self.nextLineBandView)
        {
            [self.nextLineBandView pullWithOffSetX:offSetX andOffsetY:0];
        }
        
        if (self.pointMoved == POINTMOVED_TYPE_DOWN)
        {
            self.deviceInfoView.center = [self adjustDeviceInfoViewCenterWithOffsetX:offSetX andOffsetY:0];
        }
        
    }else {
        
        [self recoverStateAnimation];
        if (self.nextLineBandView)
        {
            [self.nextLineBandView recoverStateAnimation];
//            [self.nextLineBandView addPanGestureRecognizerToDeviceInfoView];
        }
        
    }
}

#pragma mark - utlity

- (CGPoint)adjustDeviceInfoViewCenterWithOffsetX:(CGFloat)offsetX andOffsetY:(CGFloat)offsetY
{
    return  CGPointMake(self.deviceInfoView.bounds.size.width / 2 + self.property.maxOffSet + offsetX, self.deviceInfoView.bounds.size.height / 2 + (self.property.downPoint.y - self.property.upPoint.y) + offsetY);
}

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
