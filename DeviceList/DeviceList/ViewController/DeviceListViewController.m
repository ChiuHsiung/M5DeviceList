//
//  DeviceListViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/22.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "DeviceListViewController.h"

#import "TPDeviceInfoView.h"

static CGFloat const circle_width =                                 120.0f;
static CGFloat const circle_top_margin =                            64.0f + 20.0f;
static CGFloat const circle_centerX_scale =                         0.8;

static CGFloat const numOfDevicesLabel_height =                     40.0f;
static CGFloat const numOfDevicesLabel_right_margin =               5.0f;

static CGFloat const deciveLogoImgView_left_margin =                5.0f;

static CGFloat const deviceLabel_top_margin =                       5.0f;

static CGFloat const bandView_height =                              90.0f;

static CFTimeInterval const defaultDuration =                       0.2;

@interface DeviceListViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *circle;
@property (nonatomic, strong) UILabel *numOfDevicesLabel;
@property (nonatomic, strong) UIImageView * deciveLogoImgView;
@property (nonatomic, strong) UILabel *deviceLabel;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat numOfDevicesLabelHeight;//记录numOfDevicesLabel的高度


@property (nonatomic,strong) NSMutableArray *bandViewList;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //extendedLayoutIncludesOpaqueBars其中这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO。
    //而edgesForExtendedLayout则是表示视图是否覆盖到四周的区域，默认是UIRectEdgeAll，即上下左右四个方向都会覆盖，那么为让顶部不进行延伸到导航栏覆盖的区域，我们可以把顶部区域延伸去掉。
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
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
                              @"deviceType" :                       @"iPhone",
                              @"deviceName" :                       @"KK's iPhone",
                              @"intelligentPriorityTime":           @"02:30",
                              @"downloadSpeed":                     @252,
                              @"uploadSpeed":                       @100
                              
                              };
    NSDictionary *device1 = @{
                              @"deviceType" :                       @"mac",
                              @"deviceName" :                       @"Jake's Mac",
                              @"intelligentPriorityTime":           @"12:30",
                              @"downloadSpeed":                     @139,
                              @"uploadSpeed":                       @55
                              
                              };
    NSDictionary *device2 = @{
                              @"deviceType" :                       @"iPad",
                              @"deviceName" :                       @"Rick's ipad",
                              @"intelligentPriorityTime":           @"",
                              @"downloadSpeed":                     @214,
                              @"uploadSpeed":                       @91
                              
                              };
    NSDictionary *device3 = @{
                              @"deviceType" :                       @"tv",
                              @"deviceName" :                       @"Stacy's TV",
                              @"intelligentPriorityTime":           @"",
                              @"downloadSpeed":                     @303,
                              @"uploadSpeed":                       @179
                              
                              };
    NSDictionary *device4 = @{
                              @"deviceType" :                       @"tv",
                              @"deviceName" :                       @"Stacy's TV",
                              @"intelligentPriorityTime":           @"",
                              @"downloadSpeed":                     @303,
                              @"uploadSpeed":                       @179
                              
                              };
    NSDictionary *device5 = @{
                              @"deviceType" :                       @"tv",
                              @"deviceName" :                       @"Stacy's TV",
                              @"intelligentPriorityTime":           @"",
                              @"downloadSpeed":                     @303,
                              @"uploadSpeed":                       @179
                              
                              };
    NSDictionary *device6 = @{
                              @"deviceType" :                       @"tv",
                              @"deviceName" :                       @"Stacy's TV",
                              @"intelligentPriorityTime":           @"",
                              @"downloadSpeed":                     @303,
                              @"uploadSpeed":                       @179
                              
                              };
    NSDictionary *device7 = @{
                              @"deviceType" :                       @"tv",
                              @"deviceName" :                       @"Stacy's TV",
                              @"intelligentPriorityTime":           @"",
                              @"downloadSpeed":                     @303,
                              @"uploadSpeed":                       @179
                              
                              };
    
    self.deviceList = [[NSMutableArray alloc] initWithArray:@[device0, device1, device2, device3, device4, device5, device6, device7]];
    
    [self.view addSubview:self.circle];
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(circle_top_margin);
        make.centerX.equalTo(self.view).multipliedBy(circle_centerX_scale);
        make.width.equalTo(@(circle_width));
        make.height.equalTo(@(circle_width));
        
    }];
    [self.circle addSubview:self.numOfDevicesLabel];
    [self.circle addSubview:self.deciveLogoImgView];
    [self.circle addSubview:self.deviceLabel];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, circle_top_margin + circle_width, self.view.bounds.size.width, self.view.bounds.size.height - circle_top_margin - circle_width)];
    self.scrollView.userInteractionEnabled = YES;//关闭scrollView的用户交互性,否则按钮点击事件不会生效
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.bandViewList = [[NSMutableArray alloc] init];
    CGFloat maxOffset = self.view.center.x * circle_centerX_scale / 2;
    
    NSDictionary *deviceItem0 = self.deviceList[0];
    TPLineBandView *bandViewListItem0 = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, bandView_height) andStrokeColor:[UIColor lightGrayColor] andLineWidth:1.0f andMaxOffset:maxOffset andDelegate:self andCircleCenterX:self.view.center.x * circle_centerX_scale];
    bandViewListItem0.duration = defaultDuration;
    bandViewListItem0.deviceType = deviceItem0[@"deviceType"];
    bandViewListItem0.deviceName = deviceItem0[@"deviceName"];
    bandViewListItem0.intelligentPriorityTime = deviceItem0[@"intelligentPriorityTime"];
    bandViewListItem0.downloadSpeed = [deviceItem0[@"downloadSpeed"] intValue];
    bandViewListItem0.uploadSpeed = [deviceItem0[@"uploadSpeed"] intValue];
    [self.scrollView addSubview:bandViewListItem0];
    [self.bandViewList addObject:bandViewListItem0];
    
    TPLineBandView *preBandView = bandViewListItem0;
    for (int i = 1; i < [self.deviceList count]; i++)
    {
        NSDictionary *dictItem = self.deviceList[i];
        TPLineBandView *bandViewItem = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, preBandView.frame.origin.y + preBandView.bounds.size.height, self.view.bounds.size.width, bandView_height) andStrokeColor:[UIColor lightGrayColor] andLineWidth:1.0f andMaxOffset:maxOffset andDelegate:self andCircleCenterX:self.view.center.x * circle_centerX_scale];
        bandViewItem.duration = defaultDuration;
        bandViewItem.deviceType = dictItem[@"deviceType"];
        bandViewItem.deviceName = dictItem[@"deviceName"];
        bandViewItem.intelligentPriorityTime = dictItem[@"intelligentPriorityTime"];
        bandViewItem.downloadSpeed = [dictItem[@"downloadSpeed"] intValue];
        bandViewItem.uploadSpeed = [dictItem[@"uploadSpeed"] intValue];
        [self.scrollView addSubview:bandViewItem];
        [self.bandViewList addObject:bandViewItem];
        
        preBandView.nextLineBandView = bandViewItem;
        preBandView = bandViewItem;
    }
    
    [self updateScollViewContentSize];
    
}

- (void)updateScollViewContentSize
{
    CGFloat sum = 0;
    while (sum + bandView_height <= self.scrollView.bounds.size.height)
    {
        sum += bandView_height;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.bandViewList.count * bandView_height + (self.scrollView.bounds.size.height - sum));
    if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height)
    {
        self.scrollView.scrollEnabled = true;
    }
    else
    {
        self.scrollView.scrollEnabled = false;
    }
}

- (UIButton *)circle
{
    if (nil == _circle)
    {
//        _circle = [[UIImageView alloc] initWithImage:kCircle_Background_Image];
        _circle = [[UIButton alloc] init];
        _circle.backgroundColor = [UIColor whiteColor];
        _circle.layer.cornerRadius = circle_width / 2;
        _circle.layer.masksToBounds = NO;
        _circle.layer.shadowOffset =  CGSizeMake(1, 1);
        _circle.layer.shadowOpacity = 0.5;
        _circle.layer.shadowColor =  kShadow_Color.CGColor;
    }
    
    return _circle;
}

- (void)updateNumOfDevicesLabel
{
    CGFloat maxWidth = circle_width * 0.5;
    
    _numOfDevicesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.deviceList count]];
    
    CGSize labelSize = [_numOfDevicesLabel sizeThatFits:CGSizeZero];
    _numOfDevicesLabel.frame = CGRectMake(maxWidth - labelSize.width - numOfDevicesLabel_right_margin,
                                          maxWidth - numOfDevicesLabel_height,
                                          labelSize.width,
                                          numOfDevicesLabel_height);
//    [_numOfDevicesLabel sizeToFit];
    
    self.numOfDevicesLabelHeight = _numOfDevicesLabel.bounds.size.height;
}

- (UILabel *)numOfDevicesLabel
{
    if (nil == _numOfDevicesLabel)
    {
        _numOfDevicesLabel = [[UILabel alloc] init];
        _numOfDevicesLabel.backgroundColor = [UIColor clearColor];
        [_numOfDevicesLabel setFont:[UIFont systemFontOfSize:33.0]];
        _numOfDevicesLabel.textColor = kDefault_Main_Color;
        _numOfDevicesLabel.numberOfLines = 0;
        _numOfDevicesLabel.textAlignment = NSTextAlignmentCenter;
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
        
        CGFloat imgViewHeight = self.numOfDevicesLabelHeight;
        CGFloat imgViewWidth = imgViewHeight * widthHeightScale;
        
        _deciveLogoImgView.frame = CGRectMake(circle_width * 0.5 + deciveLogoImgView_left_margin,
                                              circle_width * 0.5 - imgViewHeight,
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
        
        CGFloat maxWidth = circle_width * 0.5;
        
        _deviceLabel.backgroundColor = [UIColor clearColor];
        _deviceLabel.text = @"Devices";
        [_deviceLabel setFont:[UIFont systemFontOfSize:20.0]];
        _deviceLabel.textColor = kDefault_Main_Color;
        _deviceLabel.numberOfLines = 0;
        _deviceLabel.textAlignment = NSTextAlignmentCenter;
        _deviceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [_deviceLabel sizeToFit];
        
        _deviceLabel.center = CGPointMake(maxWidth, maxWidth + _deviceLabel.bounds.size.height / 2.0 + deviceLabel_top_margin);
        
        
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

#pragma mark - ScrollDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        
        int order = (int)(scrollView.contentOffset.y / bandView_height);
        
        [UIView animateWithDuration:1
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             scrollView.contentOffset = CGPointMake(0, order * bandView_height);
                             
                         }completion:nil];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //自动调整位置操作
//    NSLog(@"offset y = %f", scrollView.contentOffset.y);
    if (!decelerate && scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        
        int order = (int)(scrollView.contentOffset.y / bandView_height);
        float duration = (scrollView.contentOffset.y - bandView_height * order) / bandView_height;
        
        [UIView animateWithDuration:duration
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             scrollView.contentOffset = CGPointMake(0, order * bandView_height);
                             
                         }completion:nil];
        
    }
    

}


#pragma mark - TPLineBandViewDelegate
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
    [self updateScollViewContentSize];
    
}

- (void)tpLineBandViewOnClicked:(id)sender
{
    TPLineBandView *onClickedView = (TPLineBandView *)sender;
    NSLog(@"device name = %@", onClickedView.deviceName);
}

@end
