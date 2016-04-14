//
//  ParentControlOwnerListViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/13.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "ParentControlOwnerListViewController.h"

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     (44)

static CGFloat const staticLabel_top_inset =            5.0f;

static CGFloat const tableview_top_inset =              10.0f;

@interface ParentControlOwnerListViewController ()

@property (nonatomic, strong) UILabel *staticLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *addOwnerTipLabel;

@end

@implementation ParentControlOwnerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //extendedLayoutIncludesOpaqueBars其中这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO。
    //而edgesForExtendedLayout则是表示视图是否覆盖到四周的区域，默认是UIRectEdgeAll，即上下左右四个方向都会覆盖，那么为让顶部不进行延伸到导航栏覆盖的区域，我们可以把顶部区域延伸去掉。
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
#pragma mark - 测试模拟数据
    
    NSMutableDictionary *user0 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"Stefan",
                                                                                   @"imageName"  :         @"user_image",
                                                                                   @"deviceNum"    :       @3
                                                                                   
                                                                                   }];
    NSMutableDictionary *user1 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"K K",
                                                                                   @"deviceNum"    :       @2
                                                                                   }];
    NSMutableDictionary *user2 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"Kairy",
                                                                                   @"deviceNum"    :       @5
                                                                                   }];
    NSMutableDictionary *user3 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"John",
                                                                                   @"deviceNum"    :       @1
                                                                                   }];
    
    NSMutableDictionary *user4 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"庄秋雄",
                                                                                   @"deviceNum"    :       @1
                                                                                   }];
    
    self.ownerList = [[NSMutableArray alloc] initWithArray:@[user0, user1, user2, user3, user4]];
    
    
    [self _initViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSubviewFrame];
    [self.tableView reloadData];
}



- (void)_initViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.staticLabel = [[UILabel alloc] init];
    [self.staticLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.staticLabel];
    [self.staticLabel setText:[NSString stringWithFormat:@"%@", @"归属人列表"]];
    [self.staticLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    self.staticLabel.textColor = [UIColor blackColor];
    self.staticLabel.numberOfLines = 1;
    self.staticLabel.textAlignment = NSTextAlignmentCenter;
    self.staticLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.staticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticLabel.superview).offset(staticLabel_top_inset);
        make.left.equalTo(self.staticLabel.superview);
        make.right.equalTo(self.staticLabel.superview);
        
    }];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
}



#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ownerList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OwnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_INDENTIFIER];
    if (nil == cell)
    {
        cell = [[OwnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_INDENTIFIER];
    }
    
    NSString *userName = self.ownerList[indexPath.row][@"userName"];
    NSString *imageName = self.ownerList[indexPath.row][@"imageName"];
    BOOL isOwner = [self.ownerList[indexPath.row][@"isOwner"] boolValue];
    
    [cell updateUserName:userName];
    [cell updateUserHeaderImage:imageName];
    [cell updateIsSelected:isOwner];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    for (NSMutableDictionary *dictItem in self.ownerList)
    {
        dictItem[@"isOwner"] = @false;
    }
    self.ownerList[indexPath.row][@"isOwner"] = @true;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.tableView reloadData];
    
}


@end
