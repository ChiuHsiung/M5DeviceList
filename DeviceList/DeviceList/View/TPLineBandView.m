//
//  TPLineBandView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPLineBandView.h"

#import "TPDeviceInfoView.h"
#import "TPProgressView.h"
#import "TPAttributedStringGenerator.h"
#import "TPBlockView.h"

#import <QuartzCore/QuartzCore.h>

static CFTimeInterval defaultDuration = 0.2;

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

@property (nonatomic,strong)        CAShapeLayer *drawLayer;

@property (nonatomic,strong)        TPBlockView *blockView;

@end

@implementation TPLineBandView

@synthesize deviceName = _deviceName;
@synthesize parentalCtrlTime = _parentalCtrlTime;

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

- (id)initWithFrame:(CGRect)frame andStrokeColor:(UIColor *)strokeColor andLineWidth:(CGFloat)lineWidth andMaxOffset:(CGFloat)maxOffset andDelegate:(id)someOne
{
    if (self = [super initWithFrame:frame]) {
        [self _initLayer];
        
        LineBandProperty property = MakeLBProperty(self.bounds.size.width / 2 , 0, self.bounds.size.width / 2, self.bounds.size.height / 2, maxOffset);
        
        self.property = property;
        self.strokeColor = strokeColor;
        self.lineWidth = lineWidth;
        
        [self _initDeviceInfoView];
        [self updateDeviceNameLabel];
        [self updateParentCtrlLabel];
        [self updateProgressView];
        [self _initBlockView];
        
        self.delegate = someOne;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame layerProperty:(LineBandProperty)property andStrokeColor:(UIColor *)strokeColor andLineWidth:(CGFloat)lineWidth  andDelegate:(id)someOne
{
    if (self = [super initWithFrame:frame]) {
        [self _initLayer];
        self.property = property;
        self.strokeColor = strokeColor;
        self.lineWidth = lineWidth;
        
        [self _initDeviceInfoView];
        [self updateDeviceNameLabel];
        [self updateParentCtrlLabel];
        [self updateProgressView];
        [self _initBlockView];
        
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
    _deviceInfoView = [[TPDeviceInfoView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         self.bounds.size.height - (_property.downPoint.y -  _property.upPoint.y),
                                                                         self.bounds.size.height - (_property.downPoint.y -  _property.upPoint.y)
                                                                         )
                                              withCircleColor:self.strokeColor
                                                 andLineWidth:self.lineWidth];
    
    _deviceInfoView.center = [self adjustDeviceInfoViewCenterWithOffsetX:0 andOffsetY:0];
//    _deviceInfoView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_deviceInfoView];
    [self addPanGestureRecognizerToDeviceInfoView];
    
}

- (void)updateDeviceNameLabel
{
    if (!self.deviceNameLabel)
    {
        self.deviceNameLabel = [[UILabel alloc] init];
        [self addSubview:self.deviceNameLabel];
    }
    
    CGFloat maxWidth = self.bounds.size.width / 2 - self.deviceInfoView.bounds.size.width / 2;
    
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", self.deviceName];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentLeft;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    self.deviceNameLabel.attributedText = attrGen.attributedString;
    [self.deviceNameLabel sizeToFit];
    self.deviceNameLabel.numberOfLines = 1;
    self.deviceNameLabel.frame = CGRectMake(self.bounds.size.width - maxWidth,
                                            self.deviceInfoView.frame.origin.y + self.deviceInfoView.deviceTypeImgView.frame.origin.y,
                                            (self.deviceNameLabel.bounds.size.width < maxWidth ? self.deviceNameLabel.bounds.size.width : maxWidth),
                                            self.deviceNameLabel.bounds.size.height);
    [self addSubview:self.deviceNameLabel];
    
}

- (void)updateParentCtrlLabel
{
    if (!self.parentCtrlLabel)
    {
        self.parentCtrlLabel = [[UILabel alloc] init];
        [self addSubview:self.parentCtrlLabel];
    }
    
    CGFloat maxWidth = self.bounds.size.width / 2 - self.deviceInfoView.bounds.size.width / 2;
    
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", self.parentalCtrlTime];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentRight;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    self.parentCtrlLabel.attributedText = attrGen.attributedString;
    [self.parentCtrlLabel sizeToFit];
    self.parentCtrlLabel.numberOfLines = 1;
    self.parentCtrlLabel.frame = CGRectMake((self.parentCtrlLabel.bounds.size.width < maxWidth ? maxWidth - self.parentCtrlLabel.bounds.size.width : 0),
                                            self.deviceInfoView.center.y - self.parentCtrlLabel.bounds.size.height / 2,
                                            (self.parentCtrlLabel.bounds.size.width < maxWidth ? self.parentCtrlLabel.bounds.size.width : maxWidth),
                                            self.parentCtrlLabel.bounds.size.height);
    [self addSubview:self.parentCtrlLabel];
}

- (void)updateProgressView
{
    if (self.totalProgress <= 0)
    {
        return;
    }
    if (!self.progressView)
    {
        CGFloat maxWidth = self.bounds.size.width / 2 - self.deviceInfoView.bounds.size.width / 2;
        
        self.progressView = [[TPProgressView alloc] initWithFrame:CGRectMake(self.bounds.size.width - maxWidth,
                                                                             self.deviceNameLabel.frame.origin.y + self.deviceNameLabel.bounds.size.height,
                                                                             maxWidth,
                                                                             self.deviceNameLabel.bounds.size.height / 2)
                                                withTotalProgress:self.totalProgress];
        self.progressView.bgViewColor = [UIColor whiteColor];
        self.progressView.progressColor = [UIColor colorWithRed:(25.0f / 255.0f) green:(192.0f / 255.0f) blue:(255.0f / 255.0f) alpha:1.0f];
        [self addSubview:self.progressView];
    }
    self.progressView.curProcess = self.curProgress;
}

- (void)_initBlockView
{
    CGFloat maxWidth = self.bounds.size.width / 2 - self.deviceInfoView.bounds.size.width / 2;
    CGFloat blockViewWidth = 80 < maxWidth ? 80 : maxWidth;
    CGFloat blockViewHeight = 18;
    self.blockView = [[TPBlockView alloc] initWithFrame:CGRectMake(self.bounds.size.width - blockViewWidth,
                                                                   self.deviceInfoView.center.y - blockViewHeight / 2,
                                                                   blockViewWidth,
                                                                   blockViewHeight)
                                           andImageName:@"block_logo"
                                       andTotalProgress:self.property.maxOffSet];
    self.blockView.curProcess = 0;
    self.blockView.bgViewColor = [UIColor lightGrayColor];
    self.blockView.progressColor = [UIColor blackColor];
    self.blockView.alpha = 0.0f;
    [self addSubview:self.blockView];
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

- (void)setDeviceType:(NSString *)deviceType
{
    _deviceType = deviceType;
    if (self.deviceInfoView)
    {
        self.deviceInfoView.deviceType = deviceType;
    }
}

- (NSString *)deviceName
{
    if (nil == _deviceName)
    {
        _deviceName = @"";
    }
    
    return _deviceName;
}

- (void)setDeviceName:(NSString *)deviceName
{
    _deviceName = deviceName;
    if (deviceName)
    {
        [self updateDeviceNameLabel];
    }
    
}

- (NSString *)parentalCtrlTime
{
    if (nil == _parentalCtrlTime)
    {
        _parentalCtrlTime = @"";
    }
    
    return _parentalCtrlTime;
}

- (void)setParentalCtrlTime:(NSString *)parentalCtrlTime
{
    _parentalCtrlTime = parentalCtrlTime;
    if (parentalCtrlTime)
    {
        [self updateParentCtrlLabel];
    }
}

- (void)setCurProgress:(float)curProgress
{
    if (!self.totalProgress)
    {
        NSLog(@"必须先给totalProgress赋值");
        return;
    }
    
    _curProgress = curProgress;
    [self updateProgressView];
}

- (void)setTotalProgress:(float)totalProgress
{
    if (totalProgress <= 0)
    {
        return;
    }
    _totalProgress = totalProgress;
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

- (void)recoverStateAnimation:(BOOL)isNeedAnimation {
    _beginProperty = CopyLBProperty(_currentProperty);
    if (_duration == 0) _duration = defaultDuration;
    if (!isNeedAnimation)
    {
        _duration = 0;
    }
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
    
    //使其它控件重新出现，且带动画效果
    [self makeOtherViewAppear];
    
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
        
        
    }
    else if (recoginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offSetX = touchPoint.x - _touchBeginPoint.x;
        CGFloat offSetY = touchPoint.y - _touchBeginPoint.y;
        
        if (offSetX > 0)
        {
            return;
        }
        
        //控制其它控件消失
        [self makeOtherViewDisappear];
        self.blockView.alpha = 1.0f;
        
        [self pullWithOffSetX:offSetX andOffsetY:0];
        if (self.nextLineBandView)
        {
            [self.nextLineBandView pullWithOffSetX:offSetX andOffsetY:0];
        }
        
        if (self.pointMoved == POINTMOVED_TYPE_DOWN)
        {
            self.deviceInfoView.center = [self adjustDeviceInfoViewCenterWithOffsetX:offSetX andOffsetY:0];
        }
        
        self.blockView.curProcess = fabs(offSetX);
        
    }
    else
    {
        
        CGFloat offSetX = touchPoint.x - _touchBeginPoint.x;
        
        [self recoverStateAnimation:YES];
        self.blockView.curProcess = 0;
        self.blockView.alpha = 0.0f;
        
        if (offSetX > 0)
        {
            return;
        }
        
        if (self.nextLineBandView)
        {
            if (fabs(offSetX) > self.property.maxOffSet)
            {
                //如删除本视图，则下一视图不需要动画
                [self.nextLineBandView recoverStateAnimation:false];
            }
            else
            {
                [self.nextLineBandView recoverStateAnimation:true];
            }
//            [self.nextLineBandView recoverStateAnimation:true];
            
        }
        
        //删除本视图
        if (fabs(offSetX) > self.property.maxOffSet)
        {
            //这里可以增加弹框确定是否确认block
            if ([self.delegate respondsToSelector:@selector(deleteTPLineBandView:)])
            {
                [self.delegate deleteTPLineBandView:self];
                return;
            }
        }
        
    }
}

#pragma mark - utlity

- (void)makeOtherViewDisappear
{
    self.deviceNameLabel.alpha = 0.0f;
    self.parentCtrlLabel.alpha = 0.0f;
    self.progressView.alpha = 0.0f;
}

- (void)makeOtherViewAppear
{
    self.deviceNameLabel.alpha = 1.0f;
    self.parentCtrlLabel.alpha = 1.0f;
    self.progressView.alpha = 1.0f;
    
    [self transitionWithType:kCATransitionFade withSubType:kCATransitionFromRight forView:self.deviceNameLabel];
    [self transitionWithType:kCATransitionFade withSubType:kCATransitionFromLeft forView:self.parentCtrlLabel];
    [self transitionWithType:kCATransitionFade withSubType:kCATransitionFromRight forView:self.progressView];
}

- (CGPoint)adjustDeviceInfoViewCenterWithOffsetX:(CGFloat)offsetX andOffsetY:(CGFloat)offsetY
{
    return  CGPointMake(self.bounds.size.width / 2 + offsetX,
                        self.deviceInfoView.bounds.size.height / 2 + (self.property.downPoint.y - self.property.upPoint.y) + offsetY);
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
    animation.duration = 1.0f;
    
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
