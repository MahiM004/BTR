//
//  BTRAppDelegate.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-15.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRRefreshManager.h"

@interface BTRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)backToInitialViewControllerFrom:(UIViewController *)viewController;
- (BOOL)connected;

@end

