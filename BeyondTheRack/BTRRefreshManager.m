//
//  BTRRefreshManager.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-01-27.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRRefreshManager.h"

@implementation BTRRefreshManager

static BTRRefreshManager *SINGLETON = nil;
static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];
        [[NSNotificationCenter defaultCenter] addObserver:SINGLETON selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:SINGLETON selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
    return SINGLETON;
}

#pragma mark - Methods

- (void)appDidEnterBackground {
    self.backGroundTime = [NSDate date];
}

- (void)appWillEnterForeground {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:self.backGroundTime];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    if (hoursBetweenDates > 1) {
        BTRAppDelegate *appdel = (BTRAppDelegate *)[[UIApplication sharedApplication]delegate];
        [appdel backToInitialViewControllerFrom:self.topViewController];
    }
}

- (void)start {
    NSLog(@"refresh monitor started");
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copy {
    return [[BTRRefreshManager alloc] init];
}

- (id)mutableCopy {
    return [[BTRRefreshManager alloc] init];
}

- (id) init {
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}


@end
