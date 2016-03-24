//
//  ViewController.m
//  RubberBandView
//
//  Created by JianYe on 14-7-1.
//  Copyright (c) 2014年 XiaoZi. All rights reserved.
//

#import "ViewController.h"
#import "RubberBandView.h"
#import "TPLineBandView.h"
#import "UIColor+MLPFlatColors.h"
#import "TPDeviceInfoView.h"

@interface ViewController ()
{
    CGPoint _beginPoint;
}

@property (nonatomic,strong) TPLineBandView *rubberBandView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat maxOffset = self.view.bounds.size.width / 2 / 4;
    
    LineBandProperty property = MakeLBProperty(self.view.bounds.size.width / 2 / 2, 0, self.view.bounds.size.width / 2 / 2, self.view.bounds.size.width / 2 / 2, maxOffset);
    _rubberBandView = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 2, self.view.bounds.size.width / 2) layerProperty:property];
    _rubberBandView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _rubberBandView.strokeColor = [UIColor flatRedColor];
    _rubberBandView.lineWidth = 3;
    _rubberBandView.duration = 0.2;
    _rubberBandView.backgroundColor = [UIColor blueColor];
    
    TPLineBandView *lbViewTest = [[TPLineBandView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 2, self.view.bounds.size.width / 2) layerProperty:property];
    lbViewTest.center = CGPointMake(self.view.center.x, self.view.center.y + self.view.bounds.size.width / 2);
    lbViewTest.strokeColor = [UIColor flatRedColor];
    lbViewTest.lineWidth = 3;
    lbViewTest.duration = 0.2;
    lbViewTest.backgroundColor = [UIColor blueColor];
    
    _rubberBandView.nextLineBandView = lbViewTest;
    
    [self.view addSubview:_rubberBandView];
    [self.view addSubview:lbViewTest];
    
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
