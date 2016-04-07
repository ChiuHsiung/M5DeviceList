//
//  DeviceListViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/22.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "DeviceListViewController.h"

#import "TPCircle.h"
#import "TPDeviceInfoView.h"

static CGFloat const circle_width_scale =       0.4f;
static CGFloat const circle_top_inset =         20.0f;
static CGFloat const deviceLabel_top_inset =    5.0f;

@interface DeviceListViewController ()

@property (nonatomic, strong) TPCircle *circle;
@property (nonatomic, strong) UILabel *numOfDevicesLabel;
@property (nonatomic, strong) UIImageView * deciveLogoImgView;
@property (nonatomic, strong) UILabel *deviceLabel;

@property (nonatomic, assign) CGFloat numOfDevicesLabelHeight;//记录numOfDevicesLabel的高度


@property (nonatomic,strong) NSMutableArray *bandViewList;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //extendedLayoutIncludesOpaqueBars其中这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO。
    //而edgesForExtendedLayout则是表示视图是否覆盖到四周的区域，默认是UIRectEdgeAll，即上下左右四个方向都会覆盖，那么为让顶部不进行延伸到导航栏覆盖的区域，我们可以把顶部区域延伸去掉。
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self reloadChildViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadChildViews
{
    
#pragma mark - 测试模拟数据
    NSDictionary *device0 = @{
                              @"deviceType" :           @"phone",
                              @"deviceName" :           @"KK's iPhone",
                              @"parentalCtrlTime":      @"12:00 ~ 13:00",
                              @"curProgress":           @800
                              
                              };
    NSDictionary *device1 = @{
                              @"deviceType" :           @"laptop",
                              @"deviceName" :           @"Jake's Mac",
                              @"parentalCtrlTime":      @"12:45 ~ 14:45",
                              @"curProgress":           @600
                              
                              };
    NSDictionary *device2 = @{
                              @"deviceType" :           @"phone",
                              @"deviceName" :           @"None",
                              @"parentalCtrlTime":      @"",
                              @"curProgress":           @500
                              
                              };
    
    self.deviceList = [[NSMutableArray alloc] initWithArray:@[device0, device1, device2]];
    
    [self.view addSubview:self.circle];
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.circle.superview).offset(circle_top_inset);
        make.centerX.equalTo(self.circle.superview);
        make.width.equalTo(self.circle.superview).multipliedBy(circle_width_scale);
        make.height.equalTo(self.circle.superview.mas_width).multipliedBy(circle_width_scale);
        
    }];
    [self.circle addSubview:self.numOfDevicesLabel];
    [self.circle addSubview:self.deciveLogoImgView];
    [self.circle addSubview:self.deviceLabel];
    
    self.bandViewList = [[NSMutableArray alloc] init];
    CGFloat maxOffset = self.view.bounds.size.width / 2 / 4;
    
    NSDictionary *deviceItem0 = self.deviceList[0];
    TPLineBandView *bandViewListItem0 = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, circle_top_inset + self.view.bounds.size.width * circle_width_scale, self.view.bounds.size.width, maxOffset * 2) andStrokeColor:[UIColor grayColor] andLineWidth:2.0f andMaxOffset:maxOffset andDelegate:self];
    bandViewListItem0.duration = 0.2;
    bandViewListItem0.deviceType = deviceItem0[@"deviceType"];
    bandViewListItem0.deviceName = deviceItem0[@"deviceName"];
    bandViewListItem0.parentalCtrlTime = deviceItem0[@"parentalCtrlTime"];
    bandViewListItem0.totalProgress = 1000;//必须先设置totalProgress，否则设置curProgress会无效
    bandViewListItem0.curProgress = [deviceItem0[@"curProgress"] floatValue];
    [self.view addSubview:bandViewListItem0];
    [self.bandViewList addObject:bandViewListItem0];
    
    TPLineBandView *preBandView = bandViewListItem0;
    for (int i = 1; i < [self.deviceList count]; i++)
    {
        NSDictionary *dictItem = self.deviceList[i];
        TPLineBandView *bandViewItem = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, preBandView.frame.origin.y + preBandView.bounds.size.height, self.view.bounds.size.width, maxOffset * 2) andStrokeColor:[UIColor grayColor] andLineWidth:2.0f andMaxOffset:maxOffset andDelegate:self];
        bandViewItem.duration = 0.2;
        bandViewItem.deviceType = dictItem[@"deviceType"];
        bandViewItem.deviceName = dictItem[@"deviceName"];
        bandViewItem.parentalCtrlTime = dictItem[@"parentalCtrlTime"];
        bandViewItem.totalProgress = 1000;//必须先设置totalProgress，否则设置curProgress会无效
        bandViewItem.curProgress = [dictItem[@"curProgress"] floatValue];
        [self.view addSubview:bandViewItem];
        [self.bandViewList addObject:bandViewItem];
        
        preBandView.nextLineBandView = bandViewItem;
        preBandView = bandViewItem;
    }
    
    
}

- (TPCircle *)circle
{
    if (nil == _circle)
    {
        _circle = [[TPCircle alloc] initWithCircleColor:[UIColor grayColor]];
        _circle.lineWidth = 2.0f;
    }
    
    return _circle;
}

- (void)updateNumOfDevicesLabel
{
    CGFloat maxWidth = self.view.bounds.size.width * circle_width_scale * 0.5;
    
    _numOfDevicesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.deviceList count]];
    [_numOfDevicesLabel sizeToFit];
    _numOfDevicesLabel.frame = CGRectMake(maxWidth - _numOfDevicesLabel.bounds.size.width,
                                          maxWidth - _numOfDevicesLabel.bounds.size.height,
                                          maxWidth,
                                          _numOfDevicesLabel.bounds.size.height);
    [_numOfDevicesLabel sizeToFit];
    
    
    self.numOfDevicesLabelHeight = _numOfDevicesLabel.bounds.size.height;
}

- (UILabel *)numOfDevicesLabel
{
    if (nil == _numOfDevicesLabel)
    {
        _numOfDevicesLabel = [[UILabel alloc] init];
        _numOfDevicesLabel.backgroundColor = [UIColor clearColor];
        [_numOfDevicesLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:35.0]];
        _numOfDevicesLabel.textColor = [UIColor grayColor];
        _numOfDevicesLabel.numberOfLines = 0;
        _numOfDevicesLabel.textAlignment = NSTextAlignmentRight;
        _numOfDevicesLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    }
    [self updateNumOfDevicesLabel];
    
    return _numOfDevicesLabel;
}

- (UIImageView *)deciveLogoImgView
{
    if (nil == _deciveLogoImgView)
    {
        _deciveLogoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_logo"]];
        [_deciveLogoImgView sizeToFit];
        CGFloat widthHeightScale = _deciveLogoImgView.bounds.size.width / _deciveLogoImgView.bounds.size.height;
        
        CGFloat maxWidth = self.view.bounds.size.width * circle_width_scale * 0.5;
        
        CGFloat imgViewHeight = self.numOfDevicesLabelHeight;
        CGFloat imgViewWidth = imgViewHeight * widthHeightScale;
        
        _deciveLogoImgView.frame = CGRectMake(maxWidth,
                                              maxWidth - imgViewHeight,
                                              imgViewWidth,
                                              imgViewHeight);
        
        
    }
    
    return _deciveLogoImgView;
}

-(UILabel *)deviceLabel
{
    if (nil == _deviceLabel)
    {
        _deviceLabel = [[UILabel alloc] init];
        
        CGFloat maxWidth = self.view.bounds.size.width * circle_width_scale * 0.5;
        
        _deviceLabel.backgroundColor = [UIColor clearColor];
        _deviceLabel.text = @"Devices";
        [_deviceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
        _deviceLabel.textColor = [UIColor grayColor];
        _deviceLabel.numberOfLines = 0;
        _deviceLabel.textAlignment = NSTextAlignmentCenter;
        _deviceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [_deviceLabel sizeToFit];
        
        _deviceLabel.center = CGPointMake(maxWidth, maxWidth + _deviceLabel.bounds.size.height / 2.0 + deviceLabel_top_inset);
        
        
    }
    
    return _deviceLabel;
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

    for (TPLineBandView *bandLineItem in self.bandViewList)
    {
        [bandLineItem addPanGestureRecognizerToDeviceInfoView];
    }
}

- (void)removePanGestrueFromAllOtherTPLineBandView:(id)sender
{

    for (TPLineBandView *bandLineItem in self.bandViewList)
    {
        if (sender != bandLineItem)
        {
            [bandLineItem removePanGestureRecognizerFromDeviceInfoView];
        }
        
    }
    
}

- (void)deleteTPLineBandView:(id)sender
{
    int deleteIndex = 0;
    for (int i = 0; i < [self.bandViewList count]; i++)
    {
        if (self.bandViewList[i] == sender)
        {
            deleteIndex = i;
            break;
        }
    }
    TPLineBandView *deleteBandView = self.bandViewList[deleteIndex];
    TPLineBandView *firBandView = deleteBandView.nextLineBandView;
    if (firBandView != nil)
    {
        firBandView.frame = deleteBandView.frame;
        if (deleteIndex != 0)
        {
            TPLineBandView *lastBandView = self.bandViewList[deleteIndex - 1];
            lastBandView.nextLineBandView = firBandView;
        }
        
        TPLineBandView *preBandView = firBandView;
        for (int i = deleteIndex + 2; i < [self.bandViewList count]; i++)
        {
            TPLineBandView *bandViewItem = self.bandViewList[i];
            bandViewItem.frame = CGRectMake(0, preBandView.frame.origin.y + preBandView.bounds.size.height, bandViewItem.bounds.size.width, bandViewItem.bounds.size.height);
            
            preBandView = bandViewItem;
        }
        
    }
    
    //说明delete的BandView是最后一个
    else
    {
        if (deleteIndex - 1 >= 0)
        {
            TPLineBandView *lastBandView = self.bandViewList[deleteIndex - 1];
            lastBandView.nextLineBandView = nil;
        }
    }
    
    
    
    [sender removeFromSuperview];
    [self.bandViewList removeObjectAtIndex:deleteIndex];
    [self.deviceList removeObjectAtIndex:deleteIndex];
    [self updateNumOfDevicesLabel];
    
}

@end
