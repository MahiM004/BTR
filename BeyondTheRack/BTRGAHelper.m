//
//  BTRGAHelper.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-04.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRGAHelper.h"
#import <Google/Analytics.h>

@implementation BTRGAHelper

+ (void)setupGA {
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    
#if TARGET_IPHONE_SIMULATOR
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"App-Open-In-Simulator" value:@"1"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
#elif TARGET_OS_IPHONE
    
#endif
}

+ (void)logScreenWithName:(NSString *)name {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker set:kGAIAppVersion value:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    if ([[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERID])
        [tracker set:[GAIFields customDimensionForIndex:1]value:[[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERID]];
    else
        [tracker set:[GAIFields customDimensionForIndex:1]value:@"Anonymous"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
