//
//  DeviceListViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/22.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "DeviceListViewController.h"

#import "TPCircle.h"
#import "TPAttributedStringGenerator.h"
#import "TPDeviceInfoView.h"

#define WIDTH_SCALE (0.4f)


@interface DeviceListViewController ()

@property (nonatomic, strong) TPCircle *circle;
@property (nonatomic, strong) UILabel *numOfDevicesLabel;
@property (nonatomic, strong) UIImageView * deciveLogoImgView;
@property (nonatomic, strong) UILabel *deviceLabel;

@property (nonatomic, assign) CGFloat numOfDevicesLabelHeight;//记录numOfDevicesLabel的高度


@property (nonatomic,strong) TPLineBandView *rubberBandView;
@property (nonatomic,strong) TPLineBandView *lbViewTest;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self reloadChildViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadChildViews
{
    
    [self.view addSubview:self.circle];
    [self.circle addSubview:self.numOfDevicesLabel];
    [self.circle addSubview:self.deciveLogoImgView];
    [self.circle addSubview:self.deviceLabel];
    
    [self layoutCircle];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.circle.alpha = 1.0f;
        self.numOfDevicesLabel.alpha = 1.0f;
        self.deciveLogoImgView.alpha = 1.0f;
        self.deviceLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
#pragma mark - 测试模拟数据
    CGFloat maxOffset = self.view.bounds.size.width / 2 / 4;
    
    _rubberBandView = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, self.circle.frame.origin.y + self.circle.bounds.size.height, self.view.bounds.size.width, maxOffset * 2)andStrokeColor:[UIColor grayColor] andLineWidth:2.0f andMaxOffset:maxOffset andDelegate:self];
    _rubberBandView.duration = 0.2;
    _rubberBandView.deviceType = @"phone";
    _rubberBandView.deviceName = @"KK's iPhone";
    _rubberBandView.parentalCtrlTime = @"12:00 ~ 13:00";
    //    _rubberBandView.backgroundColor = [UIColor blueColor];
    
    _lbViewTest = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, _rubberBandView.frame.origin.y + _rubberBandView.bounds.size.height, self.view.bounds.size.width, maxOffset * 2)andStrokeColor:[UIColor grayColor] andLineWidth:2.0f andMaxOffset:maxOffset andDelegate:self];
    _lbViewTest.duration = 0.2;
    _lbViewTest.deviceType = @"laptop";
    _lbViewTest.deviceName = @"Jake's Mac";
//    _lbViewTest.parentalCtrlTime = @"12:45 ~ 14:45";
    //    _lbViewTest.backgroundColor = [UIColor blueColor];
    
    _rubberBandView.nextLineBandView = _lbViewTest;
    
    [self.view addSubview:_rubberBandView];
    [self.view addSubview:_lbViewTest];
    
}

- (TPCircle *)circle
{
    if (nil == _circle)
    {
        _circle = [[TPCircle alloc] initWithCircleColor:[UIColor grayColor]];
        
        _circle.bounds = CGRectMake(0, 0, self.view.bounds.size.width * WIDTH_SCALE, self.view.bounds.size.width * WIDTH_SCALE);
        _circle.center = CGPointMake(self.view.center.x, 44 + _circle.bounds.size.height / 2);
        
        _circle.lineWidth = 2.0f;
        _circle.alpha = 0.0f;
    }
    
    return _circle;
}

- (UILabel *)numOfDevicesLabel
{
    if (nil == _numOfDevicesLabel)
    {
        _numOfDevicesLabel = [[UILabel alloc] init];
        
        CGFloat maxWidth = self.circle.bounds.size.width * 0.5;
        
        TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
//        attrGen.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.deviceList count]];
        attrGen.text = [NSString stringWithFormat:@"%d", 17];
        attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:35];
        attrGen.textColor = [UIColor grayColor];
        attrGen.textAlignment = NSTextAlignmentRight;
        attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
        attrGen.lineBreakMode = NSLineBreakByWordWrapping;
        [attrGen generate];
        
        _numOfDevicesLabel.attributedText = attrGen.attributedString;
        _numOfDevicesLabel.numberOfLines = 0;//0代表根据文本动态调整行数
        _numOfDevicesLabel.backgroundColor = [UIColor clearColor];
        [_numOfDevicesLabel sizeToFit];
        _numOfDevicesLabel.frame = CGRectMake(maxWidth - _numOfDevicesLabel.bounds.size.width,
                                              maxWidth - _numOfDevicesLabel.bounds.size.height,
                                              maxWidth,
                                              _numOfDevicesLabel.bounds.size.height);
        [_numOfDevicesLabel sizeToFit];
        
        _numOfDevicesLabel.alpha = 0.0f;
        
        self.numOfDevicesLabelHeight = attrGen.bounds.size.height;
    }
    
    return _numOfDevicesLabel;
}

- (UIImageView *)deciveLogoImgView
{
    if (nil == _deciveLogoImgView)
    {
        _deciveLogoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_logo"]];
        [_deciveLogoImgView sizeToFit];
        CGFloat widthHeightScale = _deciveLogoImgView.bounds.size.width / _deciveLogoImgView.bounds.size.height;
        
        CGFloat maxWidth = self.circle.bounds.size.width * 0.5;
        
        CGFloat imgViewHeight = self.numOfDevicesLabelHeight;
        CGFloat imgViewWidth = imgViewHeight * widthHeightScale;
        
        _deciveLogoImgView.frame = CGRectMake(maxWidth,
                                              maxWidth - imgViewHeight,
                                              imgViewWidth,
                                              imgViewHeight);
        
        _deciveLogoImgView.alpha = 0.0f;
        
    }
    
    return _deciveLogoImgView;
}

-(UILabel *)deviceLabel
{
    if (nil == _deviceLabel)
    {
        _deviceLabel = [[UILabel alloc] init];
        
        CGFloat maxWidth = self.circle.bounds.size.width * 0.5;
        
        TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
        attrGen.text = @"Devices";
        attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        attrGen.textColor = [UIColor grayColor];
        attrGen.textAlignment = NSTextAlignmentCenter;
        attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
        attrGen.lineBreakMode = NSLineBreakByWordWrapping;
        [attrGen generate];
        
        _deviceLabel.attributedText = attrGen.attributedString;
        _deviceLabel.numberOfLines = 0;//0代表根据文本动态调整行数
        _deviceLabel.backgroundColor = [UIColor clearColor];
        [_deviceLabel sizeToFit];
        
        CGFloat edgeDistance = 5.0f;
        
        _deviceLabel.center = CGPointMake(maxWidth, maxWidth + _deviceLabel.bounds.size.height / 2.0 + edgeDistance);
        
        _deviceLabel.alpha = 0.0f;
        
    }
    
    return _deviceLabel;
}



- (void)layoutCircle
{
    [self.circle setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem :self.circle
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:44.0];
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem :self.circle
                                                                          attribute:NSLayoutAttributeCenterX
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeCenterX
                                                                         multiplier:1.0
                                                                           constant:0.0];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem :self.circle
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:WIDTH_SCALE
                                                                         constant:0.0];
    
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem :self.circle
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.circle
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    [self.view addConstraints:@[constraintTop, constraintCenterX, constraintWidth]];
    
    [self.circle addConstraint:constraintHeight];
    
}

// MARK: CATransition动画实现
- (void)transitionWithType:(NSString *)type withSubType:(NSString *)subType forView:(UIView *)view
{
    
    //创建CATransition对象
    CATransition *animation = [[CATransition alloc] init];
    
    //设置运动时间
    animation.duration = 3;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Delegate
- (void)addPanGestrueToAllTPLineBandView
{
    [self.rubberBandView addPanGestureRecognizerToDeviceInfoView];
    [self.lbViewTest addPanGestureRecognizerToDeviceInfoView];
}

- (void)removePanGestrueFromAllOtherTPLineBandView:(id)sender
{
    if (sender == self.rubberBandView)
    {
        [self.lbViewTest removePanGestureRecognizerFromDeviceInfoView];
    }
    
    if (sender == self.lbViewTest)
    {
        [self.rubberBandView removePanGestureRecognizerFromDeviceInfoView];
    }
    
}

@end
