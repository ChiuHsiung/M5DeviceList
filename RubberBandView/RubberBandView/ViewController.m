//
//  ViewController.m
//  RubberBandView
//
//  Created by JianYe on 14-7-1.
//  Copyright (c) 2014年 XiaoZi. All rights reserved.
//

#import "ViewController.h"
#import "TPDeviceInfoView.h"

@interface ViewController ()
{
    CGPoint _beginPoint;
}

@property (nonatomic,strong) TPLineBandView *rubberBandView;
@property (nonatomic,strong) TPLineBandView *lbViewTest;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat maxOffset = self.view.bounds.size.width / 2 / 4;
    
    LineBandProperty property = MakeLBProperty(self.view.bounds.size.width / 2 / 2, 0, self.view.bounds.size.width / 2 / 2, self.view.bounds.size.width / 2 / 2, maxOffset);
    _rubberBandView = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 3 / 4, self.view.bounds.size.width / 2) layerProperty:property andStrokeColor:[UIColor grayColor] andLineWidth:2.0f andDeviceName:@"KK's IPhone" andDelegate:self];
    _rubberBandView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _rubberBandView.duration = 0.2;
//    _rubberBandView.backgroundColor = [UIColor blueColor];
    
    _lbViewTest = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 3 / 4, self.view.bounds.size.width / 2) layerProperty:property andStrokeColor:[UIColor grayColor] andLineWidth:2.0f andDeviceName:@"Jake's Mac" andDelegate:self];
    _lbViewTest.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.bounds.size.width / 2);
    _lbViewTest.duration = 0.2;
//    _lbViewTest.backgroundColor = [UIColor blueColor];
    
    _rubberBandView.nextLineBandView = _lbViewTest;
    
    [self.view addSubview:_rubberBandView];
    [self.view addSubview:_lbViewTest];
    
}

#pragma mark - Delegate
- (void)addPanGestrueToAllTPLineBandView
{
    [self.rubberBandView addPanGestureRecognizerToDeviceInfoView];
    [self.lbViewTest addPanGestureRecognizerToDeviceInfoView];
}

- (void)removePanGestrueFromAllOtherTPLineBandView:(id)sender
{
    if (sender == self.rubberBandView)
    {
        [self.lbViewTest removePanGestureRecognizerFromDeviceInfoView];
    }
    
    if (sender == self.lbViewTest)
    {
        [self.rubberBandView removePanGestureRecognizerFromDeviceInfoView];
    }
    
}

//- (IBAction)panAction:(UIPanGestureRecognizer *)recoginzer {
//    CGPoint touchPoint = [recoginzer locationInView:self.view];
//    if (recoginzer.state == UIGestureRecognizerStateBegan) {
//        _beginPoint = touchPoint;
//        _rubberBandView.pointMoved = POINTMOVED_TYPE_DOWN;
//    }else if (recoginzer.state == UIGestureRecognizerStateChanged)
//    {
//        CGFloat offSetX = touchPoint.x - _beginPoint.x;
//        CGFloat offSetY = touchPoint.y - _beginPoint.y;
//        
//        [_rubberBandView pullWithOffSetX:offSetX andOffsetY:0];
//        if (_rubberBandView.pointMoved == POINTMOVED_TYPE_DOWN)
//        {
//            _rubberBandView.deviceInfoView.center = CGPointMake(_rubberBandView.bounds.size.width / 2 + offSetX, _rubberBandView.bounds.size.height / 4 * 3);
//        }
//        
//    }else {
//        
//        [_rubberBandView recoverStateAnimation];
//    }
//}


@end
