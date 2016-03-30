//
//  UserlistViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/29.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "UserlistViewController.h"
#import "ChooseUserTableViewCell.h"
#import "AddNewOwnerViewController.h"

#import "TPAttributedStringGenerator.h"

#define BAR_HEIGHT                      ([[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.                 size.height + 5.0f)

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     (44)

@interface UserlistViewController ()

@property (nonatomic, strong) UILabel *staticLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addNewUserBtn;


@end

@implementation UserlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    CGFloat maxWidth = self.view.bounds.size.width;
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", @"归属人列表"];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    attrGen.textColor = [UIColor blackColor];
    attrGen.textAlignment = NSTextAlignmentCenter;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    self.staticLabel.attributedText = attrGen.attributedString;
    self.staticLabel.numberOfLines = 1;
    [self.staticLabel sizeToFit];
    self.staticLabel.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.staticLabel.bounds.size.height);
    self.staticLabel.center = CGPointMake(self.view.center.x, BAR_HEIGHT + self.staticLabel.bounds.size.height / 2);
    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.addNewUserBtn = [[UIButton alloc] init];
    TPAttributedStringGenerator* attrGenNormal = [[TPAttributedStringGenerator alloc] init];
    attrGenNormal.text = [NSString stringWithFormat:@"%@", @"＋添加新归属人"];
    attrGenNormal.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    attrGenNormal.textColor = [UIColor colorWithRed:(25.0f / 255.0f) green:(192.0f / 255.0f) blue:(255.0f / 255.0f) alpha:1.0f];
    attrGenNormal.textAlignment = NSTextAlignmentCenter;
    attrGenNormal.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGenNormal.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGenNormal generate];
    
    TPAttributedStringGenerator* attrGenHighlight = [[TPAttributedStringGenerator alloc] init];
    attrGenHighlight.text = [NSString stringWithFormat:@"%@", @"＋添加新归属人"];
    attrGenHighlight.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    attrGenHighlight.textColor = [UIColor grayColor];
    attrGenHighlight.textAlignment = NSTextAlignmentCenter;
    attrGenHighlight.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGenHighlight.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGenHighlight generate];
    
    [self.addNewUserBtn setAttributedTitle:attrGenNormal.attributedString forState:UIControlStateNormal];
    [self.addNewUserBtn setAttributedTitle:attrGenHighlight.attributedString forState:UIControlStateHighlighted];
    self.addNewUserBtn.titleLabel.numberOfLines = 1;
    [self.addNewUserBtn sizeToFit];
    [self.addNewUserBtn addTarget:self action:@selector(addNewUserBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.staticLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addNewUserBtn];
}

- (void)updateSubviewFrame
{
    unsigned long tableViewHeight = [self.userList count] * CELL_HEIGHT;
    unsigned long maxHeight = self.view.bounds.size.height - self.staticLabel.bounds.size.height - self.addNewUserBtn.bounds.size.height - BAR_HEIGHT;
    tableViewHeight = tableViewHeight < maxHeight ? tableViewHeight : maxHeight;
    self.tableView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, tableViewHeight);
    self.tableView.center = CGPointMake(self.view.center.x, BAR_HEIGHT + self.staticLabel.bounds.size.height + tableViewHeight / 2);
    
    self.addNewUserBtn.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.addNewUserBtn.bounds.size.height);
    self.addNewUserBtn.center = CGPointMake(self.view.center.x, BAR_HEIGHT + self.staticLabel.bounds.size.height + tableViewHeight + self.addNewUserBtn.bounds.size.height / 2);
    if (tableViewHeight < maxHeight)
    {
        self.tableView.scrollEnabled = NO;
    }
    else
    {
        self.tableView.scrollEnabled = YES;
    }
}

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
    ChooseUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_INDENTIFIER];
    if (nil == cell)
    {
        cell = [[ChooseUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_INDENTIFIER];
    }
    
    NSString *userName = self.userList[indexPath.row][@"userName"];
    NSString *imageName = self.userList[indexPath.row][@"imageName"];
    BOOL isOwner = [self.userList[indexPath.row][@"isOwner"] boolValue];
    
    [cell updateUserName:userName];
    [cell updateUserHeaderImage:imageName];
    [cell updateIsSelected:isOwner];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
