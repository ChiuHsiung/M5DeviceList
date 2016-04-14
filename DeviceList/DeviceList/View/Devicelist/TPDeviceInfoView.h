//
//  TPDeviceInfoView.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/23.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPDeviceInfoViewDelegate <NSObject>

- (void)circleButtonOnClicked;

@end

@interface TPDeviceInfoView : UIView


@property (nonatomic, strong) NSString *deviceType;

@property (strong, nonatomic) UIImageView *deviceTypeImgView;

@property (nonatomic, weak) id<TPDeviceInfoViewDelegate> delegate;

@end
