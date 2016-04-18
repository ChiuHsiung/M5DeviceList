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

#import "UITableView+LoadAnimation.h"

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     OwnerTableViewCell_Height

static CGFloat const tableview_top_margin =             5.0f;
static CGFloat const tableview_separatorInset =         20.0f;

static CGFloat const addNewOwnerBtn_top_margin =        10.0f;
static CGFloat const addNewOwnerBtn_bottom_margin =     10.0f;

static CGFloat const addLabel_width =                   20.0f;
static CGFloat const cross_line_length =                10.0f;
static CGFloat const addLabel_left_margin =             userImage_left_margin;

static CGFloat const staticAddTipsLabel_left_margin =   10.0f;

@interface OwnerlistViewController ()<AddNewOwnerViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addNewOwnerBtn;

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
                                                                                  @"imageName"  :           @"user_image1",
                                                                                  @"isOwner"    :           @false
                                                                                  
                                                                                  }];
    NSMutableDictionary *user1 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"K K",
                                                                                   @"imageName"  :           @"user_image2",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
    NSMutableDictionary *user2 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"Kairy",
                                                                                   @"imageName"  :           @"user_image3",
                                                                                   @"isOwner"    :           @true
                                                                                   }];
    NSMutableDictionary *user3 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"John",
                                                                                   @"imageName"  :           @"user_image4",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
    
    NSMutableDictionary *user4 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"庄秋雄",
                                                                                   @"imageName"  :           @"user_image5",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
    
    NSMutableDictionary *user5 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"Stefan",
                                                                                   @"imageName"  :           @"user_image6",
                                                                                   @"isOwner"    :           @false
                                                                                   
                                                                                   }];
    NSMutableDictionary *user6 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"K K",
                                                                                   @"imageName"  :           @"user_image7",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
    NSMutableDictionary *user7 = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"userName" :           @"Kairy",
                                                                                   @"imageName"  :           @"user_image8",
                                                                                   @"isOwner"    :           @false
                                                                                   }];
//    NSMutableDictionary *user8 = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                   @"userName" :           @"John",
//                                                                                   @"isOwner"    :           @false
//                                                                                   }];
//    
//    NSMutableDictionary *user9 = [[NSMutableDictionary alloc] initWithDictionary:@{
//                                                                                   @"userName" :           @"庄秋雄",
//                                                                                   @"isOwner"    :           @false
//                                                                                   }];
    
    self.ownerList = [[NSMutableArray alloc] initWithArray:@[userNone, user0, user1, user2, user3, user4, user5, user6, user7]];

    
    [self _initViews];
    
    self.addNewOwnerBtn.hidden = true;
    void (^doAddNewOwnerBtnAimation)(void) = ^{
        
        CGPoint originPoint = self.addNewOwnerBtn.center;
        self.addNewOwnerBtn.center = CGPointMake(originPoint.x, originPoint.y + self.addNewOwnerBtn.frame.size.height);
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.addNewOwnerBtn.center = CGPointMake(originPoint.x ,  originPoint.y);
                             self.addNewOwnerBtn.hidden = false;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             
                         }];
        
    };
    
    [self.tableView reloadDataWithAnimate:LiftUpFromBottum andAnimationTime:0.5 andInterval:0.1 andFinishAnimation:doAddNewOwnerBtnAimation];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)_initViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, tableview_separatorInset, 0, tableview_separatorInset);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    
    self.addNewOwnerBtn = [[UIButton alloc] init];
    [self.addNewOwnerBtn setBackgroundColor:[UIColor whiteColor]];
    self.addNewOwnerBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.addNewOwnerBtn];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(tableview_top_margin);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(self.ownerList.count * CELL_HEIGHT)).priorityMedium();
        
    }];
    
    [self.addNewOwnerBtn addTarget:self action:@selector(addNewOwnerBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addNewOwnerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tableView.mas_bottom).offset(addNewOwnerBtn_top_margin);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.lessThanOrEqualTo(self.view).offset(-addNewOwnerBtn_bottom_margin).priorityHigh();
    }];
    
    UILabel *addLabel = [[UILabel alloc] init];
    [addLabel.layer setCornerRadius:addLabel_width / 2];
    addLabel.layer.masksToBounds = YES;
    addLabel.layer.borderWidth = 1;
    addLabel.layer.borderColor = kDefault_Main_Color.CGColor;
    CAShapeLayer *drawLayer = [CAShapeLayer layer];
    [addLabel.layer addSublayer:drawLayer];
    drawLayer.strokeColor = kDefault_Main_Color.CGColor;
    drawLayer.lineWidth = 1;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat leftX = addLabel_width / 2 - cross_line_length / 2;
    CGFloat leftY = addLabel_width / 2;
    [path moveToPoint:CGPointMake(leftX, leftY)];
    [path addLineToPoint:CGPointMake(leftX + cross_line_length, leftY)];
    CGFloat topX = leftY;
    CGFloat topY = leftX;
    [path moveToPoint:CGPointMake(topX, topY)];
    [path addLineToPoint:CGPointMake(topX, topY + cross_line_length)];
    drawLayer.path = path.CGPath;
    [self.addNewOwnerBtn addSubview:addLabel];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.addNewOwnerBtn).offset(addLabel_left_margin);
        make.centerY.equalTo(self.addNewOwnerBtn);
        make.width.equalTo(@(addLabel_width));
        make.height.equalTo(@(addLabel_width));
        
    }];
    
    UILabel *staticAddTipsLabel = [[UILabel alloc] init];
    [staticAddTipsLabel setTextAlignment:NSTextAlignmentLeft];
    [staticAddTipsLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [staticAddTipsLabel setTextColor:kDefault_Main_Color];
    [staticAddTipsLabel setText:@"Add new owner"];
    staticAddTipsLabel.numberOfLines = 0;
    staticAddTipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.addNewOwnerBtn addSubview:staticAddTipsLabel];
    [staticAddTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(addLabel.mas_right).offset(staticAddTipsLabel_left_margin);
        make.centerY.equalTo(self.addNewOwnerBtn);
        make.right.equalTo(self.addNewOwnerBtn);
        
    }];
    
}

- (void)updateViewConstraints
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(self.ownerList.count * CELL_HEIGHT)).priorityMedium();
        
    }];
    [super updateViewConstraints];
}

#pragma mark - AddNewOwnerViewControllerDelegate
- (void)addNewOwner:(NSMutableDictionary *)newUser
{
    [self.ownerList addObject:newUser];
    
    // update constraints now
    [self updateViewConstraints];
    
    self.addNewOwnerBtn.hidden = true;
    void (^doAddNewOwnerBtnAimation)(void) = ^{
        
        CGPoint originPoint = self.addNewOwnerBtn.center;
        self.addNewOwnerBtn.center = CGPointMake(originPoint.x, originPoint.y + self.addNewOwnerBtn.frame.size.height);
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.addNewOwnerBtn.center = CGPointMake(originPoint.x ,  originPoint.y);
                             self.addNewOwnerBtn.hidden = false;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             
                         }];
        
    };
    
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:self.ownerList.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPath:newPath andAnimationTime:0.5 andFinishAnimation:doAddNewOwnerBtnAimation];
//    [self.tableView reloadDataWithAnimate:LiftUpFromBottum andAnimationTime:0.2 andInterval:0.1 andFinishAnimation:doAddNewOwnerBtnAimation];
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

#pragma mark - 点击按钮事件
- (void)addNewOwnerBtnOnClick
{
    AddNewOwnerViewController *addNewOwnerVC = [[AddNewOwnerViewController alloc] init];
    addNewOwnerVC.delegate = self;
    [self.navigationController pushViewController:addNewOwnerVC animated:YES];
}


@end
