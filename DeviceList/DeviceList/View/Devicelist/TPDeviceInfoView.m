//
//  TPDeviceInfoView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "TPDeviceInfoView.h"

static CGFloat const device_type_imgae_margin = 4.0f;

@interface TPDeviceInfoView()

@property (strong, nonatomic) UIButton *circle;


@end

@implementation TPDeviceInfoView

@synthesize deviceType = _deviceType;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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
//    NSArray *deviceTypeArray = [[NSArray alloc] initWithObjects:@"phone", @"pad", @"mac", @"tv", @"unknown", nil];
//    
//    BOOL isValid = false;
//    for (NSString *item in deviceTypeArray)
//    {
//        if ([deviceType isEqualToString:item])
//        {
//            isValid = true;
//            break;
//        }
//    }
//    if (!isValid)
//    {
//        return;
//    }
    
    _deviceType = deviceType;
    if (self.deviceTypeImgView)
    {
        //根据deviceType设置图片
        [self.deviceTypeImgView setImage:[UIImage imageNamed:_deviceType]];
        
        [self.deviceTypeImgView sizeToFit];
        CGFloat widthHeightScale = self.deviceTypeImgView.bounds.size.width / self.deviceTypeImgView.bounds.size.height;
        CGFloat height = [self qiuGenWithA:1 andB:widthHeightScale andC:-(0.5 * (self.bounds.size.height - device_type_imgae_margin) * (self.bounds.size.height - device_type_imgae_margin) - 0.5 * widthHeightScale * widthHeightScale)];
        self.deviceTypeImgView.bounds = CGRectMake(0, 0, height * widthHeightScale, height);
        self.deviceTypeImgView.center = CGPointMake(self.circle.center.x, self.circle.center.y);
    }
}

- (void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.circle = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    
    //这里可以修改成只设置BackgroundColor
    [self.circle setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:self.circle.bounds.size] forState:UIControlStateNormal];
    [self.circle setBackgroundImage:[self imageWithColor:[UIColor grayColor] size:self.circle.bounds.size] forState:UIControlStateHighlighted];
    
    self.circle.layer.cornerRadius = self.bounds.size.height / 2;
    self.circle.layer.masksToBounds = NO;
    self.circle.layer.shadowOffset =  CGSizeMake(1, 1);
    self.circle.layer.shadowOpacity = 0.5;
    self.circle.layer.shadowColor =  kShadow_Color.CGColor;
    [self.circle addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.circle];
    
    //根据设备类型加载图片
    self.deviceTypeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.deviceType]];
    [self.deviceTypeImgView sizeToFit];
    CGFloat widthHeightScale = self.deviceTypeImgView.bounds.size.width / self.deviceTypeImgView.bounds.size.height;
    CGFloat height = [self qiuGenWithA:1 andB:widthHeightScale andC:-(0.5 * (self.bounds.size.height - device_type_imgae_margin) * (self.bounds.size.height - device_type_imgae_margin) - 0.5 * widthHeightScale * widthHeightScale)];
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

//生成纯色Image
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{

    double PI = 3.14159265358979323846;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextAddArc(context, size.width / 2, size.width / 2, size.width / 2, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill); //绘制路径
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;

}

#pragma mark - 按钮点击事件
- (void)btnOnClicked:(UIButton *)sender
{
//    NSLog(@"button on clicked.");
    if ([self.delegate respondsToSelector:@selector(circleButtonOnClicked)])
    {
        [self.delegate circleButtonOnClicked];
    }
}

@end
