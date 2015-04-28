//
//  BTRSettings.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-28.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSettings.h"

@interface BTRSettings ()

@property (nonatomic, assign) BOOL shouldSkipLogin;
@property (nonatomic, strong) NSString *sessionId;

@end


@implementation BTRSettings


#pragma mark - Class Methods

+ (instancetype)defaultSettings
{
    static BTRSettings *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settings = [[self alloc] init];
    });
    return settings;
}

#pragma mark - Properties

static NSString *const kShouldSkipLoginKey = @"shouldSkipLogin";
static NSString *const kSessionId = @"sessionId";


- (NSString *)sessionId
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kSessionId];
}

- (void)setSessionId:(NSString *)sessionId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionId forKey:kSessionId];
    [defaults synchronize];
}


- (BOOL)shouldSkipLogin
{
    if ([[self sessionId] length] > 10)
        return YES;
    
    return NO;
}


@end








