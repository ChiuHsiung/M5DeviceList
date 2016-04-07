//
//  TPDeviceInfoView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPDeviceInfoView.h"

#import "TPCircle.h"


@interface TPDeviceInfoView()

@property (strong, nonatomic) TPCircle *circle;


@end

@implementation TPDeviceInfoView

@synthesize deviceType = _deviceType;

- (instancetype)initWithFrame:(CGRect)frame withCircleColor:(UIColor *)circleColor andLineWidth:(CGFloat)lineWidth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.circleColor = circleColor;
        self.lineWidth = lineWidth;
        [self setupViews];
    }
    return self;
}

- (NSString *)deviceType
{
    if (nil == _deviceType) {
        _deviceType = @"unknown";
    }
    
    return _deviceType;
}

- (void)setDeviceType:(NSString *)deviceType
{
    NSArray *deviceTypeArray = [[NSArray alloc] initWithObjects:@"phone", @"pad", @"laptop", @"ipod", @"unknown", nil];
    
    BOOL isValid = false;
    for (NSString *item in deviceTypeArray)
    {
        if ([deviceType isEqualToString:item])
        {
            isValid = true;
            break;
        }
    }
    if (!isValid)
    {
        return;
    }
    
    _deviceType = deviceType;
    if (self.deviceTypeImgView)
    {
        //根据deviceType设置图片
        [self.deviceTypeImgView setImage:[UIImage imageNamed:_deviceType]];
    }
}

- (void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.circle = [[TPCircle alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    self.circle.circleColor = self.circleColor;
    self.circle.lineWidth = self.lineWidth;
    [self addSubview:self.circle];
    
    //根据设备类型加载图片
    self.deviceTypeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.deviceType]];
    [self.deviceTypeImgView sizeToFit];
    CGFloat widthHeightScale = self.deviceTypeImgView.bounds.size.width / self.deviceTypeImgView.bounds.size.height;
    CGFloat height = [self qiuGenWithA:1 andB:widthHeightScale andC:-(0.5 * self.circle.circleRadius *2 * self.circle.circleRadius * 2- 0.5 * widthHeightScale * widthHeightScale)];
    self.deviceTypeImgView.bounds = CGRectMake(0, 0, height * widthHeightScale, height);
    self.deviceTypeImgView.center = CGPointMake(self.circle.center.x, self.circle.center.y);
    [self addSubview:self.deviceTypeImgView];
    
}



#pragma mark - utlity

- (float)qiuGenWithA:(float)a andB:(float)b andC:(float)c
{
    float delta,x1,x2;
    x1 = 0;
    x2 = 0;
    delta=b*b-4*a*c;
    if  (delta>0){
        x1=(-b+sqrt(delta))/(2*a);
        x2=(-b-sqrt(delta))/(2*a);
//        NSLog(@"x1=%f,x2=%f",x1,x2);
    }
    if  (delta==0){
        x1=(-b+sqrt(delta))/(2*a);
//        NSLog(@"x1=%f,x2=%f",x1,x1);
    }
    if  (delta<0){
//        NSLog(@"无实根！");
    }
    return (x1 > 0? x1 : x2);
}

@end
