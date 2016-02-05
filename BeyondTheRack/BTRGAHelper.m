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

+ (NSString *)uID {
    NSString *uID;
    if ([[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERID])
        uID = [[BTRSettingManager defaultManager]objectForKeyInSetting:kUSERID];
    else
        uID = @"Anonymous";
    return uID;
}

+ (void)logScreenWithName:(NSString *)name {
    [self sendlogScreenWithName:name withCustomDimensions:[NSArray arrayWithObject:[self uID]]];
}

+ (void)logScreenWithName:(NSString *)name WithAdditionalDimensions:(NSArray *)dimensions{
    NSMutableArray *customField = [[NSMutableArray alloc]init];
    [customField addObject:[self uID]];
    for (NSString *dim in dimensions) {
        [customField addObject:dim];
    }
    [self sendlogScreenWithName:name withCustomDimensions:dimensions];
}

+ (void)logEventWithCatrgory:(NSString *)category action:(NSString *)action label:(NSString *)label {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
}

+ (void)sendlogScreenWithName:(NSString *)name withCustomDimensions:(NSArray *)dimensions {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker set:kGAIAppVersion value:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    for (int i =0;i < [dimensions count];i++)
        [tracker set:[GAIFields customDimensionForIndex:i+1]value:[dimensions objectAtIndex:i]];
}

@end
