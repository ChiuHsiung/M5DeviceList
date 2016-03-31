//
//  AddNewOwnerViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/30.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "AddNewOwnerViewController.h"
#import "OwnerTimeCtrlTableViewCell.h"
#import "TPAttributedStringGenerator.h"

#define BAR_HEIGHT                      ([[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.                 size.height + 5.0f)

#define ownerHeaderImageBtn_top_inset           (10.0f)
#define ownerHeaderImageBtn_width               (80.0f)
#define cross_line_length                       (20.0f)

#define tipsLabel_top_inset                     (5.0f)

#define staticLabel_top_inset                   (30.0f)

#define ownerNameTextField_top_inset            (20.0f)
#define ownerNameTextField_left_inset           (30.0f)
#define ownerNameTextField_height               (30.0f)

#define tableview_top_inset                     (10.0f)

#define CELL_REUSE_INDENTIFIER_DEILY            @"TIME_CTRL_IDENTIFIER_DAILY"
#define CELL_REUSE_INDENTIFIER_BED              @"TIME_CTRL_IDENTIFIER_BED"
#define CELL_REUSE_INDENTIFIER_TIME             @"TIME_CTRL_IDENTIFIER_TIME"

#define CELL_MAX_NUM                            (5)
#define CELL_HEIGHT                             (44)

#define daily_time_limit_switch_tag             (1001)
#define bed_time_limit_switch_tag               (1002)

@interface AddNewOwnerViewController ()

@property (nonatomic, strong) UIButton *ownerHeaderImageBtn;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UILabel *staticLabel;
@property (nonatomic, strong) UITextField *ownerNameTextField;
@property (nonatomic, strong) UITableView *tableView;

//数据属性
@property (nonatomic, assign) BOOL isDailyTimeLimitOn;
@property (nonatomic, assign) BOOL isBedTimeOn;
@property (nonatomic, strong) NSMutableArray *funcList;

@property (nonatomic, strong) NSString *dailyTimeLimit;
@property (nonatomic, strong) NSString *bedTime;
@property (nonatomic, strong) NSString *awakeTime;

@property (nonatomic, assign) BOOL isTableViewNeedScoll;

@end

@implementation AddNewOwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initViews];
    [self _initData];
}

- (void)_initViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.ownerHeaderImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ownerHeaderImageBtn_width, ownerHeaderImageBtn_width)];
    self.ownerHeaderImageBtn.center = CGPointMake(self.view.center.x, BAR_HEIGHT + ownerHeaderImageBtn_top_inset + ownerHeaderImageBtn_width / 2);
    [self.ownerHeaderImageBtn.layer setCornerRadius:CGRectGetHeight([self.ownerHeaderImageBtn bounds]) / 2];
    self.ownerHeaderImageBtn.layer.masksToBounds = true;
    self.ownerHeaderImageBtn.layer.borderWidth = 1;
    self.ownerHeaderImageBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    CAShapeLayer *drawLayer = [CAShapeLayer layer];
    [self.ownerHeaderImageBtn.layer addSublayer:drawLayer];
    drawLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    drawLayer.lineWidth = 2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat leftX = self.ownerHeaderImageBtn.bounds.size.width / 2 - cross_line_length / 2;
    CGFloat leftY = self.ownerHeaderImageBtn.bounds.size.width / 2;
    [path moveToPoint:CGPointMake(leftX, leftY)];
    [path addLineToPoint:CGPointMake(leftX + cross_line_length, leftY)];
    CGFloat topX = leftY;
    CGFloat topY = leftX;
    [path moveToPoint:CGPointMake(topX, topY)];
    [path addLineToPoint:CGPointMake(topX, topY + cross_line_length)];
    drawLayer.path = path.CGPath;
    [self.ownerHeaderImageBtn addTarget:self action:@selector(ownerHeaderImageBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tipsLabel = [[UILabel alloc] init];
    [self setTipsLabelText:@"上传头像"];
    self.tipsLabel.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.tipsLabel.bounds.size.height);
    self.tipsLabel.center = CGPointMake(self.view.center.x, self.ownerHeaderImageBtn.frame.origin.y + self.ownerHeaderImageBtn.bounds.size.height + tipsLabel_top_inset + self.tipsLabel.bounds.size.height / 2);
    
    self.staticLabel = [[UILabel alloc] init];
    CGFloat maxWidth = self.view.bounds.size.width;
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", @"归属人名称"];
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
    self.staticLabel.center = CGPointMake(self.view.center.x, self.tipsLabel.frame.origin.y + self.tipsLabel.bounds.size.height + staticLabel_top_inset + self.staticLabel.bounds.size.height / 2);

    
    self.ownerNameTextField = [[UITextField alloc] init];
    self.ownerNameTextField.textAlignment = NSTextAlignmentCenter;
    self.ownerNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.ownerNameTextField.placeholder = @"必填";
    self.ownerNameTextField.returnKeyType = UIReturnKeyDone;
    self.ownerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ownerNameTextField.delegate = self;
    self.ownerNameTextField.bounds = CGRectMake(0, 0, self.view.bounds.size.width - ownerNameTextField_left_inset * 2, ownerNameTextField_height);
    self.ownerNameTextField.center = CGPointMake(self.view.center.x, self.staticLabel.frame.origin.y + self.staticLabel.bounds.size.height + ownerNameTextField_top_inset + self.ownerNameTextField.bounds.size.height / 2);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = false;
    CGFloat maxHeight = CELL_MAX_NUM * CELL_HEIGHT;
    CGFloat remainHeight = self.view.bounds.size.height - (self.ownerNameTextField.frame.origin.y + self.ownerNameTextField.bounds.size.height) - tableview_top_inset;
    CGFloat tableViewHeight = 0;
    if (maxHeight < remainHeight)
    {
        self.isTableViewNeedScoll = false;
        tableViewHeight = maxHeight;
    }
    else
    {
        self.isTableViewNeedScoll = true;
        tableViewHeight = remainHeight;
    }
    self.tableView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, tableViewHeight);
    self.tableView.center = CGPointMake(self.view.center.x, self.ownerNameTextField.frame.origin.y + self.ownerNameTextField.bounds.size.height + tableview_top_inset + tableViewHeight / 2);
    
    [self.view addSubview:self.ownerHeaderImageBtn];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.staticLabel];
    [self.view addSubview:self.ownerNameTextField];
    [self.view addSubview:self.tableView];
    

}

- (void)_initData
{
    //默认值
    _isDailyTimeLimitOn = false;
    _isBedTimeOn = false;
    _dailyTimeLimit = @"4 Hours";
    _bedTime = @"8:00 AM";
    _awakeTime = @"8:00 PM";
    
    _funcList = [[NSMutableArray alloc] initWithArray:@[@"Daily time limit", @"Bed time"]];
}

- (void)setTipsLabelText:(NSString *)string
{
    CGFloat maxWidth = self.view.bounds.size.width;
    TPAttributedStringGenerator* attrGen = [[TPAttributedStringGenerator alloc] init];
    attrGen.text = [NSString stringWithFormat:@"%@", string];
    attrGen.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    attrGen.textColor = [UIColor grayColor];
    attrGen.textAlignment = NSTextAlignmentCenter;
    attrGen.constraintSize = CGSizeMake(maxWidth, MAXFLOAT);
    attrGen.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrGen generate];
    self.tipsLabel.attributedText = attrGen.attributedString;
    self.tipsLabel.numberOfLines = 1;
    [self.tipsLabel sizeToFit];
}


#pragma mark - 编辑头像
- (void)ownerHeaderImageBtnOnClick
{
    NSLog(@"On click");
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



#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.funcList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *funcString = self.funcList[indexPath.row];
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_INDENTIFIER_DEILY];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_INDENTIFIER_DEILY];
            //add a switch
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchview.tag = daily_time_limit_switch_tag;
            switchview.on = self.isDailyTimeLimitOn;
            [switchview addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = switchview;
        }
        
        cell.textLabel.text = funcString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    else if ((indexPath.row == 1 && !self.isDailyTimeLimitOn) || (indexPath.row == 2 && self.isDailyTimeLimitOn))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_INDENTIFIER_BED];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_INDENTIFIER_BED];
            //add a switch
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchview.tag = bed_time_limit_switch_tag;
            switchview.on = self.isBedTimeOn;
            [switchview addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = switchview;
        }
        
        cell.textLabel.text = funcString;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    else
    {
        OwnerTimeCtrlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_INDENTIFIER_TIME];
        if (nil == cell)
        {
            cell = [[OwnerTimeCtrlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_INDENTIFIER_TIME];
        }
        
        [cell updateFuncLabel:funcString];
        if (self.isDailyTimeLimitOn)
        {
            if (indexPath.row == 1)
            {
                [cell updateTimeLabel:self.dailyTimeLimit];
            }
            
            else if (indexPath.row == 3)
            {
                [cell updateTimeLabel:self.bedTime];
            }
            
            else if(indexPath.row == 4)
            {
                [cell updateTimeLabel:self.awakeTime];
            }
        }
        
        else
        {
            if (indexPath.row == 2)
            {
                [cell updateTimeLabel:self.bedTime];
            }
            
            else if(indexPath.row == 3)
            {
                [cell updateTimeLabel:self.awakeTime];
            }
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateSwitch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    if (switchView.tag == daily_time_limit_switch_tag)
    {
        if (_isDailyTimeLimitOn == switchView.isOn)
        {
            return;
        }
        
        _isDailyTimeLimitOn = switchView.isOn;
        
        [self.tableView beginUpdates];
        NSMutableArray *indexPaths = [NSMutableArray array];
        if (_isDailyTimeLimitOn)
        {
            [self.funcList insertObject:@"Daily time limit" atIndex:1];
            [indexPaths addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.isTableViewNeedScoll)
            {
                self.tableView.scrollEnabled = true;
            }
        }
        else
        {
            [self.funcList removeObjectAtIndex:1];
            [indexPaths addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            if (self.isTableViewNeedScoll && !_isBedTimeOn)
            {
                self.tableView.scrollEnabled = false;
            }
        }
        [self.tableView endUpdates];
        
    }
    else if (switchView.tag == bed_time_limit_switch_tag)
    {
        if (_isBedTimeOn == switchView.isOn)
        {
            return;
        }
        
        _isBedTimeOn = switchView.isOn;
        [self.tableView beginUpdates];
        NSMutableArray *indexPaths = [NSMutableArray array];
        int insertIndex1 = 0;
        int insertIndex2 = 0;
        int removeIndex = 0;
        if (_isDailyTimeLimitOn)
        {
            insertIndex1 = 3;
            insertIndex2 = 4;
            removeIndex = 3;
        }
        else
        {
            insertIndex1 = 2;
            insertIndex2 = 3;
            removeIndex = 2;
        }
        
        if (_isBedTimeOn)
        {
            [self.funcList insertObject:@"Bed time" atIndex:insertIndex1];
            [self.funcList insertObject:@"Awake" atIndex:insertIndex2];
            [indexPaths addObject:[NSIndexPath indexPathForRow:insertIndex1 inSection:0]];
            [indexPaths addObject:[NSIndexPath indexPathForRow:insertIndex2 inSection:0]];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.isTableViewNeedScoll)
            {
                self.tableView.scrollEnabled = true;
            }
        }
        else
        {
            [self.funcList removeObjectAtIndex:removeIndex];
            [self.funcList removeObjectAtIndex:removeIndex];
            [indexPaths addObject:[NSIndexPath indexPathForRow:insertIndex1 inSection:0]];
            [indexPaths addObject:[NSIndexPath indexPathForRow:insertIndex2 inSection:0]];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            if (self.isTableViewNeedScoll && !_isDailyTimeLimitOn)
            {
                self.tableView.scrollEnabled = false;
            }
        }
        [self.tableView endUpdates];

    }
}


@end
