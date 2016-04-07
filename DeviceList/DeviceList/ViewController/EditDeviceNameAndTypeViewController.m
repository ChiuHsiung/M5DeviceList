//
//  EditDeviceNameAndTypeViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/1.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "EditDeviceNameAndTypeViewController.h"

#import "DeviceTypeTableViewCell.h"

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     (44)

static CGFloat const staticDeviceNameLabel_top_inset =              15.0f;

static CGFloat const deviceNameTextField_top_inset =                15.0f;
static CGFloat const deviceNameTextField_left_inset =               30.0f;

static CGFloat const staticDeviceTypeLabel_top_inset =              20.0f;

static CGFloat const tableview_top_inset =                          10.0f;

@interface EditDeviceNameAndTypeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *staticDeviceNameLabel;
@property (nonatomic, strong) UITextField *deviceNameTextField;
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
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    
    #pragma mark - 测试模拟数据
    self.deviceName = @"KK's iPhone";
    self.deviceType = @"phone";
    self.deviceTypeList = @[@"phone", @"laptop", @"pad", @"ipod", @"unknown"];
    
    [self _initViews];
    
}

- (void)_initViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.staticDeviceNameLabel = [[UILabel alloc] init];
    [self.view addSubview:self.staticDeviceNameLabel];
    self.staticDeviceNameLabel.text = [NSString stringWithFormat:@"%@", @"Device name"];
    [self.staticDeviceNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    self.staticDeviceNameLabel.textColor = [UIColor blackColor];
    self.staticDeviceNameLabel.numberOfLines = 1;
    self.staticDeviceNameLabel.textAlignment = NSTextAlignmentCenter;
    self.staticDeviceNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.staticDeviceNameLabel sizeToFit];
    [self.staticDeviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticDeviceNameLabel.superview).offset(staticDeviceNameLabel_top_inset);
        make.left.equalTo(self.staticDeviceNameLabel.superview);
        make.right.equalTo(self.staticDeviceNameLabel.superview);
        make.height.equalTo(@(self.staticDeviceNameLabel.bounds.size.height));
        
    }];
    
    
    self.deviceNameTextField = [[UITextField alloc] init];
    [self.view addSubview:self.deviceNameTextField];
    self.deviceNameTextField.textAlignment = NSTextAlignmentCenter;
    self.deviceNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.deviceNameTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    self.deviceNameTextField.textColor = [UIColor blackColor];
    self.deviceNameTextField.placeholder = @"Device name";
    self.deviceNameTextField.text = self.deviceName;
    self.deviceNameTextField.returnKeyType = UIReturnKeyDone;
    self.deviceNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.deviceNameTextField.delegate = self;
    [self.deviceNameTextField sizeToFit];
    [self.deviceNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticDeviceNameLabel.mas_bottom).offset(deviceNameTextField_top_inset);
        make.left.equalTo(self.deviceNameTextField.superview).offset(deviceNameTextField_left_inset);
        make.right.equalTo(self.deviceNameTextField.superview).offset(-deviceNameTextField_left_inset);
        make.height.equalTo(@(self.deviceNameTextField.bounds.size.height));
        
    }];
    
    
    self.staticDeviceTypeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.staticDeviceTypeLabel];
    self.staticDeviceTypeLabel.text = [NSString stringWithFormat:@"%@", @"Device type"];
    [self.staticDeviceTypeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    self.staticDeviceTypeLabel.textColor = [UIColor blackColor];
    self.staticDeviceTypeLabel.numberOfLines = 1;
    self.staticDeviceTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.staticDeviceTypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.staticDeviceTypeLabel sizeToFit];
    [self.staticDeviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.deviceNameTextField.mas_bottom).offset(staticDeviceTypeLabel_top_inset);
        make.left.equalTo(self.staticDeviceTypeLabel.superview);
        make.right.equalTo(self.staticDeviceTypeLabel.superview);
        make.height.equalTo(@(self.staticDeviceTypeLabel.bounds.size.height));
        
    }];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticDeviceTypeLabel.mas_bottom).offset(tableview_top_inset);
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tableView.superview);
        
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.tableView.bounds.size.height > [self.deviceTypeList count] * CELL_HEIGHT)
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
    return true;
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
