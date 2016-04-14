//
//  TPNetworkSpeed.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/13.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPNetworkSpeed : UIView

- (void)updateDownloadSpeed:(int)downloadSpeed;
- (void)updateUploadSpeed:(int)uploadSpeed;

@end
