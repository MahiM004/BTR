//
//  BTRAnimationHandler.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRAnimationHandler : NSObject

+ (void)moveAndshrinkView:(UIView *)view toPoint:(CGPoint)endPoint withDuration:(float)duration;
+ (void)showViewController:(UIViewController *)viewController atLeftOfViewController:(UIViewController *)mainViewController inDuration:(CGFloat)duration;
+ (void)hideViewController:(UIViewController *)viewController fromMainViewController:(UIViewController *)mainViewController inDuration:(CGFloat)duration;

@end
