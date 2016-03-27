//
//  MainViewController.m
//  TPProgressView
//
//  Created by Yangzhida on 14-6-20.
//  Copyright (c) 2014年 PV. All rights reserved.
//

#import "MainViewController.h"
#import "TPProgressView.h"
#import "TPBlockView.h"


@interface MainViewController ()

@property (nonatomic,strong) TPProgressView *TPProgressView;
@property (nonatomic,strong) UISlider *slider;
@property (nonnull, strong) TPBlockView *blockView;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - zdInit
- (void)zdInit
{
    self.title = @"TPProgressView";
}

#pragma mark - tpProgressViewInit
- (void)tpProgressViewInit
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(60, 150, 200, 20)];
    [self.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.TPProgressView = [[TPProgressView alloc] initWithFrame:CGRectMake(60, 200, 200, 15) withTotalProgress:1.0f];
    self.TPProgressView.curProcess = 0;
    self.TPProgressView.bgViewColor = [UIColor whiteColor];
    self.TPProgressView.progressColor = self.view.tintColor;
    [self.view addSubview:self.TPProgressView];
    
    self.blockView = [[TPBlockView alloc] initWithFrame:CGRectMake(60, 250, 100, 20) andImageName:@"block_logo" andTotalProgress:1.0f];
    self.blockView.curProcess = 0;
    self.blockView.bgViewColor = [UIColor lightGrayColor];
    self.blockView.progressColor = [UIColor blackColor];
    [self.view addSubview:self.blockView];

}

#pragma mark - slider
- (void)slider:(UISlider *)slider
{
    self.TPProgressView.curProcess = slider.value;
    self.blockView.curProcess = slider.value;
}

#pragma mark - view load
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self zdInit];
    [self tpProgressViewInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
