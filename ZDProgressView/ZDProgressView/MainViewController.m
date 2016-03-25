//
//  MainViewController.m
//  TPProgressView
//
//  Created by Yangzhida on 14-6-20.
//  Copyright (c) 2014年 PV. All rights reserved.
//

#import "MainViewController.h"
#import "TPProgressView.h"


@interface MainViewController ()

@property (nonatomic,strong) TPProgressView *TPProgressView;
@property (nonatomic,strong) UISlider *slider;

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
    
    self.TPProgressView = [[TPProgressView alloc] initWithFrame:CGRectMake(60, 200, 200, 25)];
    self.TPProgressView.progress = 0;
    self.TPProgressView.bgViewColor = [UIColor redColor];
    self.TPProgressView.progressColor = self.view.tintColor;
    [self.view addSubview:self.TPProgressView];
    
    

}

#pragma mark - slider
- (void)slider:(UISlider *)slider
{
    self.TPProgressView.progress = slider.value;
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
