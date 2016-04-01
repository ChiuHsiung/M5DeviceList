//
//  EditDeviceNameAndTypeViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/4/1.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "EditDeviceNameAndTypeViewController.h"

#import "DeviceTypeTableViewCell.h"
#import "TPAttributedStringGenerator.h"

#define BAR_HEIGHT                      ([[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.                 size.height + 5.0f)

#define deviceNameTextField_top_inset               (10.0f)
#define deviceNameTextField_left_inset              (30.0f)
#define deviceNameTextField_height                  (30.0f)

#define staticDeviceTypeLabel_top_inset             (20.0f)
#define tableview_top_inset                         (10.0f)

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     (44)

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
    CGFloat maxWidth = self.view.bounds.size.width;
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", @"Device name"];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    attrGen.textColor = [UIColor blackColor];
    attrGen.textAlignment = NSTextAlignmentCenter;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    self.staticDeviceNameLabel.attributedText = attrGen.attributedString;
    self.staticDeviceNameLabel.numberOfLines = 1;
    [self.staticDeviceNameLabel sizeToFit];
    self.staticDeviceNameLabel.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.staticDeviceNameLabel.bounds.size.height);
    self.staticDeviceNameLabel.center = CGPointMake(self.view.center.x, BAR_HEIGHT + self.staticDeviceNameLabel.bounds.size.height / 2);
    
    self.deviceNameTextField = [[UITextField alloc] init];
    self.deviceNameTextField.textAlignment = NSTextAlignmentCenter;
    self.deviceNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.deviceNameTextField.text = self.deviceName;
    self.deviceNameTextField.returnKeyType = UIReturnKeyDone;
    self.deviceNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.deviceNameTextField.delegate = self;
    self.deviceNameTextField.bounds = CGRectMake(0, 0, self.view.bounds.size.width - deviceNameTextField_left_inset * 2, deviceNameTextField_height);
    self.deviceNameTextField.center = CGPointMake(self.view.center.x, self.staticDeviceNameLabel.frame.origin.y + self.staticDeviceNameLabel.bounds.size.height + deviceNameTextField_top_inset + self.deviceNameTextField.bounds.size.height / 2);
    
    self.staticDeviceTypeLabel = [[UILabel alloc] init];
    [attrGen setText:@"Device Type"];
    self.staticDeviceTypeLabel.attributedText = attrGen.attributedString;
    self.staticDeviceTypeLabel.numberOfLines = 1;
    [self.staticDeviceTypeLabel sizeToFit];
    self.staticDeviceTypeLabel.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.staticDeviceTypeLabel.bounds.size.height);
    self.staticDeviceTypeLabel.center = CGPointMake(self.view.center.x, self.deviceNameTextField.frame.origin.y + self.deviceNameTextField.bounds.size.height + staticDeviceTypeLabel_top_inset + self.staticDeviceTypeLabel.bounds.size.height / 2);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    CGFloat maxHeight = [self.deviceTypeList count] * CELL_HEIGHT;
    CGFloat remainHeight = self.view.bounds.size.height - (self.staticDeviceTypeLabel.frame.origin.y + self.staticDeviceTypeLabel.bounds.size.height) - tableview_top_inset;
    CGFloat tableViewHeight = 0;
    if (maxHeight < remainHeight)
    {
        self.tableView.scrollEnabled = false;
        tableViewHeight = maxHeight;
    }
    else
    {
        self.tableView.scrollEnabled = true;
        tableViewHeight = remainHeight;
    }
    self.tableView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, tableViewHeight);
    self.tableView.center = CGPointMake(self.view.center.x, self.staticDeviceTypeLabel.frame.origin.y + self.staticDeviceTypeLabel.bounds.size.height + tableview_top_inset + tableViewHeight / 2);
    
    [self.view addSubview:self.staticDeviceNameLabel];
    [self.view addSubview:self.deviceNameTextField];
    [self.view addSubview:self.staticDeviceTypeLabel];
    [self.view addSubview:self.tableView];
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
