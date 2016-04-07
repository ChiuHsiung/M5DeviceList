//
//  AddNewOwnerViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/30.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "AddNewOwnerViewController.h"
#import "OwnerTimeCtrlTableViewCell.h"

#define CELL_REUSE_INDENTIFIER_DEILY            @"TIME_CTRL_IDENTIFIER_DAILY"
#define CELL_REUSE_INDENTIFIER_BED              @"TIME_CTRL_IDENTIFIER_BED"
#define CELL_REUSE_INDENTIFIER_TIME             @"TIME_CTRL_IDENTIFIER_TIME"

#define CELL_HEIGHT                             (44)

#define daily_time_limit_switch_tag             (1001)
#define bed_time_limit_switch_tag               (1002)


static CGFloat const ownerHeaderImageBtn_top_inset =            15.0f;
static CGFloat const ownerHeaderImageBtn_width =                80.0f;
static CGFloat const cross_line_length =                        20.0f;

static CGFloat const tipsLabel_top_inset =                      5.0f;

static CGFloat const staticLabel_top_inset =                    30.0f;

static CGFloat const ownerNameTextField_top_inset =             20.0f;
static CGFloat const ownerNameTextField_left_inset =            30.0f;
static CGFloat const ownerNameTextField_height =                30.0f;

static CGFloat const tableview_top_inset =                      10.0f;

@interface AddNewOwnerViewController ()<UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) UIButton *ownerHeaderImageBtn;
@property (nonatomic, strong) CAShapeLayer *drawLayer;
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
    
    //extendedLayoutIncludesOpaqueBars其中这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO。
    //而edgesForExtendedLayout则是表示视图是否覆盖到四周的区域，默认是UIRectEdgeAll，即上下左右四个方向都会覆盖，那么为让顶部不进行延伸到导航栏覆盖的区域，我们可以把顶部区域延伸去掉。
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    
    [self _initViews];
    [self _initData];
}

- (void)_initViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.ownerHeaderImageBtn = [[UIButton alloc] init];
    [self.ownerHeaderImageBtn.layer setCornerRadius:ownerHeaderImageBtn_width / 2];
    self.ownerHeaderImageBtn.layer.masksToBounds = true;
    self.ownerHeaderImageBtn.layer.borderWidth = 1;
    self.ownerHeaderImageBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.drawLayer = [CAShapeLayer layer];
    [self.ownerHeaderImageBtn.layer addSublayer:self.drawLayer];
    self.drawLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    self.drawLayer.lineWidth = 2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat leftX = ownerHeaderImageBtn_width / 2 - cross_line_length / 2;
    CGFloat leftY = ownerHeaderImageBtn_width / 2;
    [path moveToPoint:CGPointMake(leftX, leftY)];
    [path addLineToPoint:CGPointMake(leftX + cross_line_length, leftY)];
    CGFloat topX = leftY;
    CGFloat topY = leftX;
    [path moveToPoint:CGPointMake(topX, topY)];
    [path addLineToPoint:CGPointMake(topX, topY + cross_line_length)];
    self.drawLayer.path = path.CGPath;
    [self.ownerHeaderImageBtn addTarget:self action:@selector(ownerHeaderImageBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ownerHeaderImageBtn];
    [self.ownerHeaderImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.ownerHeaderImageBtn.superview).offset(ownerHeaderImageBtn_top_inset);
        make.centerX.equalTo(self.ownerHeaderImageBtn.superview);
        make.width.equalTo(@(ownerHeaderImageBtn_width));
        make.height.equalTo(self.ownerHeaderImageBtn.mas_width);
        
    }];
    
    
    
    self.tipsLabel = [[UILabel alloc] init];
    [self.view addSubview:self.tipsLabel];
    [self.tipsLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
    self.tipsLabel.textColor = [UIColor grayColor];
    self.tipsLabel.numberOfLines = 1;
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self setTipsLabelText:@"上传头像"];
    [self.tipsLabel sizeToFit];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.ownerHeaderImageBtn.mas_bottom).offset(tipsLabel_top_inset);
        make.left.equalTo(self.tipsLabel.superview);
        make.right.equalTo(self.tipsLabel.superview);
        make.height.equalTo(@(self.tipsLabel.bounds.size.height));
        
    }];
    
    
    
    self.staticLabel = [[UILabel alloc] init];
    [self.view addSubview:self.staticLabel];
    [self.staticLabel setText:[NSString stringWithFormat:@"%@", @"归属人名称"]];
    [self.staticLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
    self.staticLabel.textColor = [UIColor blackColor];
    self.staticLabel.numberOfLines = 1;
    self.staticLabel.textAlignment = NSTextAlignmentCenter;
    self.staticLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.staticLabel sizeToFit];
    [self.staticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(staticLabel_top_inset);
        make.left.equalTo(self.staticLabel.superview);
        make.right.equalTo(self.staticLabel.superview);
        make.height.equalTo(@(self.staticLabel.bounds.size.height));
        
    }];
    
    
    
    self.ownerNameTextField = [[UITextField alloc] init];
    [self.view addSubview:self.ownerNameTextField];
    self.ownerNameTextField.textAlignment = NSTextAlignmentCenter;
    self.ownerNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.ownerNameTextField.placeholder = @"必填";
    self.ownerNameTextField.returnKeyType = UIReturnKeyDone;
    self.ownerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ownerNameTextField.delegate = self;
    [self.ownerNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.staticLabel.mas_bottom).offset(ownerNameTextField_top_inset);
        make.left.equalTo(self.ownerNameTextField.superview).offset(ownerNameTextField_left_inset);
        make.right.equalTo(self.ownerNameTextField.superview).offset(-ownerNameTextField_left_inset);
        make.height.equalTo(@(ownerNameTextField_height));
        
    }];
    

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.ownerNameTextField.mas_bottom).offset(tableview_top_inset);
        make.left.equalTo(self.tableView.superview);
        make.right.equalTo(self.tableView.superview);
        make.bottom.equalTo(self.tableView.superview);
        
    }];
    
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
    [self updateTableViewContentSize];
    self.tableView.scrollEnabled = false;//初始化默认为不能划动
}

- (void)setTipsLabelText:(NSString *)string
{
    self.tipsLabel.text = string;
}

- (void)updateTableViewContentSize
{
    self.tableView.contentSize = CGSizeMake(self.view.bounds.size.width, [_funcList count] * CELL_HEIGHT);
    if (self.tableView.bounds.size.height > self.tableView.contentSize.height)
    {
        self.tableView.scrollEnabled = false;
    }
    else
    {
        self.tableView.scrollEnabled = true;
    }
}


#pragma mark - 编辑头像
- (void)ownerHeaderImageBtnOnClick
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    /*
     如果这里allowsEditing设置为false，则下面的UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
     应该改为： UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
     也就是改为原图像，而不是编辑后的图像。
     */
    //允许编辑图片
    imagePicker.allowsEditing = YES;
    //如果设备支持相机，就使用拍照技术
    //否则让用户从照片库中选择照片
    //  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    //  {
    //    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //  }
    //  else{
    //    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //  }
    
    /*
     这里以弹出选择框的形式让用户选择是打开照相机还是图库
     */
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //创建UIPopoverController对象前先检查当前设备是不是ipad
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //创建UIPopoverController对象前先检查当前设备是不是ipad
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //取消；
    }]];
    //弹出提示框；
    UIPopoverPresentationController *ppc = alert.popoverPresentationController;
    ppc.delegate = self;
    ppc.sourceView = self.view;
    // 仔细看苹果文档，sourceRect是要与sourceView结合起来使用的。
    ppc.sourceRect = CGRectMake((CGRectGetWidth(ppc.sourceView.bounds)-2)*0.5f, (CGRectGetHeight(ppc.sourceView.bounds)-2), 2, 2);// 显示在中心位置
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    //  [self presentViewController:alert animated:true completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //通过info字典获取选择的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    //以itemKey为键，将照片存入ImageStore对象中
//    [[MyImageStore sharedStore] setImage:image forKey:@"CYFStore"];
    //将照片放入UIImageView对象
    [self.ownerHeaderImageBtn setImage:image forState:UIControlStateNormal];
    [self setTipsLabelText:@"更改头像"];
    [self.drawLayer removeFromSuperlayer];
    //把一张照片保存到图库中，此时无论是这张照片是照相机拍的还是本身从图库中取出的，都会保存到图库中；
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    //压缩图片,如果图片要上传到服务器或者网络，则需要执行该步骤（压缩），第二个参数是压缩比例，转化为NSData类型；
//    NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
    //判断UIPopoverController对象是否存在
    //关闭以模态形式显示的UIImagePickerController
    [self dismissViewControllerAnimated:YES completion:nil];
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
            
        }
        else
        {
            [self.funcList removeObjectAtIndex:1];
            [indexPaths addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
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
            
        }
        else
        {
            [self.funcList removeObjectAtIndex:removeIndex];
            [self.funcList removeObjectAtIndex:removeIndex];
            [indexPaths addObject:[NSIndexPath indexPathForRow:insertIndex1 inSection:0]];
            [indexPaths addObject:[NSIndexPath indexPathForRow:insertIndex2 inSection:0]];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
        }
        [self.tableView endUpdates];

    }
    [self updateTableViewContentSize];
}


@end
