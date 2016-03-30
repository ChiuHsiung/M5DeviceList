//
//  AddNewOwnerViewController.m
//  DeviceList
//
//  Created by zhuangqiuxiong on 16/3/30.
//  Copyright © 2016年 tplink. All rights reserved.
//

#import "AddNewOwnerViewController.h"

#import "TPAttributedStringGenerator.h"

#define BAR_HEIGHT                      ([[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.                 size.height + 5.0f)

#define ownerHeaderImageBtn_top_inset          (10.0f)
#define ownerHeaderImageBtn_width              (80.0f)
#define cross_line_length                      (20.0f)
#define tipsLabel_top_inset                    (5.0f)
#define staticLabel_top_inset                  (30.0f)
#define ownerNameTextField_top_inset           (20.0f)
#define ownerNameTextField_left_inset          (30.0f)
#define ownerNameTextField_height              (30.0f)

#define CELL_REUSE_INDENTIFIER          @"USER_ITEM_IDENTIFIER"
#define CELL_HEIGHT                     (44)

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


@end

@implementation AddNewOwnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initViews];
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
    self.ownerNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ownerNameTextField.bounds = CGRectMake(0, 0, self.view.bounds.size.width - ownerNameTextField_left_inset * 2, ownerNameTextField_height);
    self.ownerNameTextField.center = CGPointMake(self.view.center.x, self.staticLabel.frame.origin.y + self.staticLabel.bounds.size.height + ownerNameTextField_top_inset + self.ownerNameTextField.bounds.size.height / 2);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.ownerHeaderImageBtn];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.staticLabel];
    [self.view addSubview:self.ownerNameTextField];
    

}

- (void)_initData
{
    _isDailyTimeLimitOn = false;
    _isBedTimeOn = false;
    _dailyTimeLimit = @"4 Hours";
    _bedTime = @"8:00 AM";
    _awakeTime = @"8:00 PM";
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

- (void)ownerHeaderImageBtnOnClick
{
    NSLog(@"On click");
}


@end
