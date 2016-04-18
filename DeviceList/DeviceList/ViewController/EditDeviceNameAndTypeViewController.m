//
//  EditDeviceNameAndTypeViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/1.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "EditDeviceNameAndTypeViewController.h"

#import "DeviceTypeTableViewCell.h"

#import "TPUnderlineTextField.h"

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     DeviceTypeTableViewCell_Height

static CGFloat const deviceNameContainerView_top_margin =               64.0f + 0.0f;
static CGFloat const deviceNameContainerView_height =                   100.0f;

static CGFloat const staticDeviceNameLabel_top_margin =                 15.0f;

static CGFloat const deviceNameTextField_top_margin =                   10.0f;
static CGFloat const deviceNameTextField_left_margin =                  30.0f;
static CGFloat const deviceNameTextField_right_margin =                 deviceNameTextField_left_margin;

static CGFloat const deviceTypeContainerView_top_margin =               10.0f;

static CGFloat const staticDeviceTypeLabel_top_margin =                 20.0f;

static CGFloat const tableview_top_margin =                             staticDeviceTypeLabel_top_margin;
static CGFloat const tableview_separatorInset =                         20.0f;

@interface EditDeviceNameAndTypeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *staticDeviceNameLabel;
@property (nonatomic, strong) TPUnderlineTextField *deviceNameTextField;
@property (nonatomic, strong) UILabel *staticDeviceTypeLabel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *deviceTypeList;

@end

@implementation EditDeviceNameAndTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //extendedLayoutIncludesOpaqueBars其中这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO。
    //而edgesForExtendedLayout则是表示视图是否覆盖到四周的区域，默认是UIRectEdgeAll，即上下左右四个方向都会覆盖，那么为让顶部不进行延伸到导航栏覆盖的区域，我们可以把顶部区域延伸去掉。
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    
    #pragma mark - 测试模拟数据
    self.deviceName = @"KK's iPhone";
    self.deviceType = @"Phone";
    self.deviceTypeList = @[@"Phone", @"Laptop", @"Tablet", @"Media Device", @"Printer", @"IOT Device", @"unknown"];
    
    [self _initViews];
    
}

- (void)_initViews
{
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIView *deviceNameContainerView = [[UIView alloc] init];
    [self.view addSubview:deviceNameContainerView];
    [deviceNameContainerView setBackgroundColor:[UIColor whiteColor]];
    deviceNameContainerView.layer.shadowOffset =  CGSizeMake(1, 1);
    deviceNameContainerView.layer.shadowOpacity = 0.5;
    deviceNameContainerView.layer.shadowColor =  kShadow_Color.CGColor;
    [deviceNameContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(deviceNameContainerView_top_margin);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(deviceNameContainerView_height));
        
    }];
    
    self.staticDeviceNameLabel = [[UILabel alloc] init];
    [deviceNameContainerView addSubview:self.staticDeviceNameLabel];
    self.staticDeviceNameLabel.text = [NSString stringWithFormat:@"%@", @"Device name"];
    [self.staticDeviceNameLabel setFont:[UIFont systemFontOfSize:12.0]];
    self.staticDeviceNameLabel.textColor = [UIColor grayColor];
    self.staticDeviceNameLabel.numberOfLines = 1;
    self.staticDeviceNameLabel.textAlignment = NSTextAlignmentCenter;
    self.staticDeviceNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.staticDeviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticDeviceNameLabel.superview).offset(staticDeviceNameLabel_top_margin);
        make.left.equalTo(self.staticDeviceNameLabel.superview);
        make.right.equalTo(self.staticDeviceNameLabel.superview);
        
    }];
    
    
    self.deviceNameTextField = [[TPUnderlineTextField alloc] init];
    [deviceNameContainerView addSubview:self.deviceNameTextField];
    self.deviceNameTextField.textAlignment = NSTextAlignmentCenter;
    self.deviceNameTextField.font = [UIFont systemFontOfSize:15.0];
    self.deviceNameTextField.textColor = [UIColor blackColor];
    self.deviceNameTextField.placeholder = @"Device name";
    self.deviceNameTextField.text = self.deviceName;
    self.deviceNameTextField.returnKeyType = UIReturnKeyDone;
    
    self.deviceNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.deviceNameTextField.delegate = self;
    [self.deviceNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticDeviceNameLabel.mas_bottom).offset(deviceNameTextField_top_margin);
        make.left.equalTo(self.deviceNameTextField.superview).offset(deviceNameTextField_left_margin);
        make.right.equalTo(self.deviceNameTextField.superview).offset(-deviceNameTextField_right_margin);
        
    }];
    
    UIView *deviceTypeContainerView = [[UIView alloc] init];
    [self.view addSubview:deviceTypeContainerView];
    [deviceTypeContainerView setBackgroundColor:[UIColor whiteColor]];
    deviceTypeContainerView.layer.shadowOffset =  CGSizeMake(1, 1);
    deviceTypeContainerView.layer.shadowOpacity = 0.5;
    deviceTypeContainerView.layer.shadowColor =  kShadow_Color.CGColor;
    [deviceTypeContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(deviceNameContainerView.mas_bottom).offset(deviceTypeContainerView_top_margin);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        
    }];
    
    self.staticDeviceTypeLabel = [[UILabel alloc] init];
    [deviceTypeContainerView addSubview:self.staticDeviceTypeLabel];
    self.staticDeviceTypeLabel.text = [NSString stringWithFormat:@"%@", @"Device type"];
    [self.staticDeviceTypeLabel setFont:[UIFont systemFontOfSize:12.0]];
    self.staticDeviceTypeLabel.textColor = [UIColor grayColor];
    self.staticDeviceTypeLabel.numberOfLines = 1;
    self.staticDeviceTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.staticDeviceTypeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize labelSize = [self.staticDeviceTypeLabel sizeThatFits:CGSizeZero];
    [self.staticDeviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(deviceTypeContainerView);
        make.right.equalTo(deviceTypeContainerView);
        make.top.equalTo(deviceTypeContainerView).offset(deviceTypeContainerView_top_margin);
        
    }];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [deviceTypeContainerView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, tableview_separatorInset, 0, tableview_separatorInset);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticDeviceTypeLabel.mas_bottom).offset(tableview_top_margin);
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tableView.superview);
        
    }];
    
    CGFloat remainHeight = self.view.bounds.size.height - deviceNameTextField_top_margin - deviceNameContainerView_height - deviceTypeContainerView_top_margin - staticDeviceTypeLabel_top_margin - tableview_top_margin - labelSize.height;
    if (remainHeight >= CELL_HEIGHT * self.deviceTypeList.count)
    {
        self.tableView.scrollEnabled = false;
    }
    else
    {
        self.tableView.scrollEnabled = true;
    }
    
}



#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
    return YES;
}


#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceTypeList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_INDENTIFIER];
    if (nil == cell)
    {
        cell = [[DeviceTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_INDENTIFIER];
    }
    
    NSString *userName = self.deviceTypeList[indexPath.row];
    NSString *deviceType = self.deviceTypeList[indexPath.row];
    
    [cell updateDeviceType:userName];
    [cell updateDeviceTypeImage:deviceType];
    if ([deviceType isEqualToString:self.deviceType]) {
        [cell updateIsSelected:true];
    }
    else
    {
        [cell updateIsSelected:false];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.deviceType = self.deviceTypeList[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.tableView reloadData];
    
}

@end
