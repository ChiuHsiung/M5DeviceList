//
//  UserlistViewController.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserlistViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *userList;

@end
