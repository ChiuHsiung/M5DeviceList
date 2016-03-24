//
//  TPDeviceInfoView.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 zhuangqiuxiong. All rights reserved.
//

#import "TPDeviceInfoView.h"

#import "TPAttributedStringGenerator.h"

#import "TPCircle.h"

@interface TPDeviceInfoView()

@property (strong, nonatomic) TPCircle *circle;
@property (strong, nonatomic) UIImageView *deviceTypeImgView;
@property (strong, nonatomic) UILabel *deviceNameLabel;

@end

@implementation TPDeviceInfoView

@synthesize deviceName = _deviceName;

- (instancetype)initWithFrame:(CGRect)frame withCircleColor:(UIColor *)circleColor andLineWidth:(CGFloat)lineWidth andDeviceName:(NSString *)deviceName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.circleColor = circleColor;
        self.lineWidth = lineWidth;
        self.deviceName = deviceName;
        [self setupViews];
    }
    return self;
}

- (NSString *)deviceType
{
    if (nil == _deviceType) {
        _deviceType = @"N/A";
    }
    
    return _deviceType;
}

- (NSString *)deviceName
{
    if (nil == _deviceName) {
        _deviceName = @"N/A";
    }
    
    return _deviceName;
}

- (void)setDeviceName:(NSString *)deviceName
{
    _deviceName = deviceName;
    
    if (_deviceNameLabel)
    {
        _deviceNameLabel.attributedText = [self setDeviceNameLabelText];
    }
}

- (NSAttributedString *)setDeviceNameLabelText
{
    CGFloat maxWidth = self.deviceNameLabel.bounds.size.width;
    
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", self.deviceName];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentLeft;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    
    return attrGen.attributedString;
}

- (void)setupViews
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.circle = [[TPCircle alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    self.circle.circleColor = self.circleColor;
    self.circle.lineWidth = self.lineWidth;
    [self addSubview:self.circle];
    
    //根据设备类型加载图片
    self.deviceTypeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_logo"]];
    [self.deviceTypeImgView sizeToFit];
    CGFloat widthHeightScale = self.deviceTypeImgView.bounds.size.width / self.deviceTypeImgView.bounds.size.height;
    CGFloat height = [self qiuGenWithA:1 andB:widthHeightScale andC:-(0.5 * self.circle.circleRadius *2 * self.circle.circleRadius * 2- 0.5 * widthHeightScale * widthHeightScale)];
    self.deviceTypeImgView.bounds = CGRectMake(0, 0, height * widthHeightScale, height);
    self.deviceTypeImgView.center = CGPointMake(self.circle.center.x, self.circle.center.y);
    [self addSubview:self.deviceTypeImgView];
    
    //设备名Label
    self.deviceNameLabel = [[UILabel alloc] init];
    self.deviceNameLabel.attributedText = [self setDeviceNameLabelText];
    [self.deviceNameLabel sizeToFit];
    self.deviceNameLabel.numberOfLines = 1;
    NSLog(@"%f", self.bounds.size.width);
    self.deviceNameLabel.frame = CGRectMake(self.circle.bounds.size.width,
                                            self.deviceTypeImgView.frame.origin.y,
                                            ((self.deviceNameLabel.bounds.size.width + self.circle.bounds.size.width) > self.bounds.size.width ? (self.bounds.size.width - self.circle.bounds.size.width):self.deviceNameLabel.bounds.size.width),
                                            self.deviceNameLabel.bounds.size.height);
    [self addSubview:self.deviceNameLabel];
    
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
