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
@property (nonatomic,strong)IBOutlet TPLineBandView *rubberBandView;
@property (nonatomic,strong)IBOutlet UIButton *actionBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat maxOffset = _rubberBandView.bounds.size.width / 4;
    _rubberBandView.property = MakeLBProperty(_rubberBandView.bounds.size.width / 2, 0, _rubberBandView.bounds.size.width / 2, _rubberBandView.bounds.size.height / 2, maxOffset);
    _rubberBandView.strokeColor = [UIColor flatRedColor];
    _rubberBandView.lineWidth = 3;
    _rubberBandView.duration = 0.2;
    
}

- (IBAction)beginAnimation:(UIButton *)sender {

}

- (IBAction)resetState:(id)sender {
    [_rubberBandView resetDefault];
}

- (IBAction)panAction:(UIPanGestureRecognizer *)recoginzer {
    CGPoint touchPoint = [recoginzer locationInView:self.view];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _beginPoint = touchPoint;
        _rubberBandView.pointMoved = POINTMOVED_TYPE_DOWN;
    }else if (recoginzer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offSetX = touchPoint.x - _beginPoint.x;
        CGFloat offSetY = touchPoint.y - _beginPoint.y;
        
        [_rubberBandView pullWithOffSetX:offSetX andOffsetY:0];
        if (_rubberBandView.pointMoved == POINTMOVED_TYPE_DOWN)
        {
            _rubberBandView.deviceInfoView.center = CGPointMake(_rubberBandView.bounds.size.width / 2 + offSetX, _rubberBandView.bounds.size.height / 4 * 3);
        }
        
    }else {
        
        [_rubberBandView recoverStateAnimation];
    }
}


@end
