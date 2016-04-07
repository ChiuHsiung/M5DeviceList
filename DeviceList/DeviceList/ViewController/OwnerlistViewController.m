//
//  OwnerlistViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "OwnerlistViewController.h"
#import "OwnerTableViewCell.h"
#import "AddNewOwnerViewController.h"

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     (44)

static CGFloat const staticLabel_top_inset =            5.0f;
static CGFloat const staticLabel_height =               20.0f;

@interface OwnerlistViewController ()

@property (nonatomic, strong) UILabel *staticLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addNewUserBtn;

@end

@implementation OwnerlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //extendedLayoutIncludesOpaqueBars其中这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO。
    //而edgesForExtendedLayout则是表示视图是否覆盖到四周的区域，默认是UIRectEdgeAll，即上下左右四个方向都会覆盖，那么为让顶部不进行延伸到导航栏覆盖的区域，我们可以把顶部区域延伸去掉。
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
#pragma mark - 测试模拟数据
    
    NSMutableDictionary *userNone = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"None",
                                                                                   @"isOwner"    :           @false
                                                                                   
                                                                                   }];
    
    NSMutableDictionary *user0 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                  @"userName" :           @"Stefan",
                                                                                  @"imageName"  :           @"user_image",
                                                                                  @"isOwner"    :           @false
                                                                                  
                                                                                  }];
    NSMutableDictionary *user1 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"K K",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
    NSMutableDictionary *user2 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"Kairy",
                                                                                   @"isOwner"    :           @true
                                                                                   }];
    NSMutableDictionary *user3 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"John",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
    
    NSMutableDictionary *user4 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"庄秋雄",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
    
    self.userList = [[NSMutableArray alloc] initWithArray:@[userNone, user0, user1, user2, user3, user4]];

    
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
        make.height.equalTo(@(staticLabel_height));
        
    }];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.addNewUserBtn = [[UIButton alloc] init];
    [self.addNewUserBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.addNewUserBtn];
    NSMutableDictionary *attribDict = [[NSMutableDictionary alloc] init];
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attribDict setValue:[UIFont fontWithName:@"HelveticaNeue" size:15.0] forKey:NSFontAttributeName];
    [attribDict setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attribDict setValue:[UIColor colorWithRed:(25.0f / 255.0f) green:(192.0f / 255.0f) blue:(255.0f / 255.0f) alpha:1.0f] forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"＋添加新归属人" attributes:attribDict];
    [self.addNewUserBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    [attribDict setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    attributedString = [[NSAttributedString alloc] initWithString:@"＋添加新归属人" attributes:attribDict];
    [self.addNewUserBtn setAttributedTitle:attributedString forState:UIControlStateHighlighted];
    self.addNewUserBtn.titleLabel.numberOfLines = 1;
    [self.addNewUserBtn sizeToFit];
    [self.addNewUserBtn addTarget:self action:@selector(addNewUserBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)updateSubviewFrame
{
    unsigned long tableViewHeight = [self.userList count] * CELL_HEIGHT;
    unsigned long maxHeight = self.view.bounds.size.height - staticLabel_height - self.addNewUserBtn.bounds.size.height - staticLabel_top_inset;
    tableViewHeight = tableViewHeight < maxHeight ? tableViewHeight : maxHeight;
    self.tableView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, tableViewHeight);
    self.tableView.center = CGPointMake(self.view.center.x, staticLabel_top_inset + staticLabel_height + tableViewHeight / 2);
    
    self.addNewUserBtn.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.addNewUserBtn.bounds.size.height);
    self.addNewUserBtn.center = CGPointMake(self.view.center.x, staticLabel_top_inset + staticLabel_height + tableViewHeight + self.addNewUserBtn.bounds.size.height / 2);
    if (tableViewHeight < maxHeight)
    {
        self.tableView.scrollEnabled = NO;
    }
    else
    {
        self.tableView.scrollEnabled = YES;
    }
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userList count];
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
    
    NSString *userName = self.userList[indexPath.row][@"userName"];
    NSString *imageName = self.userList[indexPath.row][@"imageName"];
    BOOL isOwner = [self.userList[indexPath.row][@"isOwner"] boolValue];
    
    [cell updateUserName:userName];
    [cell updateUserHeaderImage:imageName];
    [cell updateIsSelected:isOwner];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    for (NSMutableDictionary *dictItem in self.userList)
    {
        dictItem[@"isOwner"] = @false;
    }
    self.userList[indexPath.row][@"isOwner"] = @true;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.tableView reloadData];
    
}

#pragma mark - 点击按钮事件
- (void)addNewUserBtnOnClick
{
    AddNewOwnerViewController *addNewOwnerVC = [[AddNewOwnerViewController alloc] init];
    [self.navigationController pushViewController:addNewOwnerVC animated:YES];
}


@end
