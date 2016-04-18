//
//  AddNewOwnerViewController.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/30.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNewOwnerViewControllerDelegate <NSObject>

- (void)addNewOwner:(NSMutableDictionary *)newUser;

@end

@interface AddNewOwnerViewController : UIViewController

@property(nonatomic, weak) id<AddNewOwnerViewControllerDelegate> delegate;

@end
