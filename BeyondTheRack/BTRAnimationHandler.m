//
//  BTRAnimationHandler.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAnimationHandler.h"
#define SLIDEMENU_SIZE 250

@implementation BTRAnimationHandler

+ (void)moveAndshrinkView:(UIView *)view toPoint:(CGPoint)endPoint withDuration:(float)duration{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration=duration;
    pathAnimation.delegate=self;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, view.frame.origin.x, view.frame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, view.frame.origin.y, endPoint.x, view.frame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform"];
    [basic setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 0.01)]];
    [basic setAutoreverses:NO];
    [basic setDuration:duration];
    [view.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
    [view.layer addAnimation:basic forKey:@"transform"];
    [view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration - 0.1];
}

+ (void)showViewController:(UIViewController *)viewController atLeftOfViewController:(UIViewController *)mainViewController inDuration:(CGFloat)duration {
    [viewController.view setFrame:CGRectMake(-SLIDEMENU_SIZE, 0, SLIDEMENU_SIZE, mainViewController.view.frame.size.height)];
    [mainViewController.view.superview addSubview:viewController.view];
    [UIView animateWithDuration:duration animations:^{
        [mainViewController.view setFrame:CGRectMake(SLIDEMENU_SIZE, 0, mainViewController.view.frame.size.width, mainViewController.view.frame.size.height)];
        [viewController.view setFrame:CGRectMake(0, 0, SLIDEMENU_SIZE, mainViewController.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [viewController.view needsUpdateConstraints];
    }];;
}

+ (void)hideViewController:(UIViewController *)viewController fromMainViewController:(UIViewController *)mainViewController inDuration:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        [mainViewController.view setFrame:CGRectMake(0, 0, mainViewController.view.frame.size.width, mainViewController.view.frame.size.height)];
        [viewController.view setFrame:CGRectMake(-SLIDEMENU_SIZE, 0, SLIDEMENU_SIZE, mainViewController.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [viewController.view removeFromSuperview];
    }];
}


@end
