//
//  ParentControlOwnerListViewController.h
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/13.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentControlOwnerListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *ownerList;

@end
