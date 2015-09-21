//
//  BTRLoader.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-21.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRLoader.h"
#import <SpinKit/RTSpinKitView.h>
#import "BTRViewUtility.h"

#define kLOADERTAG 1000

@implementation BTRLoader

+ (void)showLoaderInView:(UIView *)view {
    for (UIView* subview in [view subviews])
        if (subview.tag == kLOADERTAG)
            return;
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleThreeBounce];
    spinner.color = [UIColor colorWithRed:1.0 green:0.2 blue:0.1 alpha:1];
    if ([BTRViewUtility isIPAD])
        spinner.spinnerSize = 300;
    else
        spinner.spinnerSize = 100;
    spinner.tag = kLOADERTAG;
    spinner.center = CGPointMake(([UIScreen mainScreen].bounds.size.width)/2 - spinner.spinnerSize / 2 + 10, ([UIScreen mainScreen].bounds.size.height)/2 - spinner.spinnerSize);
    [view addSubview:spinner];
}

+ (void)hideLoaderFromView:(UIView *)view {
    for (UIView* subView in [view subviews])
        if (subView.tag == kLOADERTAG)
            [subView removeFromSuperview];
}

@end
