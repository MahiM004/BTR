//
//  BTRSettings.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-28.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSessionSettings.h"


@interface BTRSessionSettings ()


@end


@implementation BTRSessionSettings


#pragma mark - Class Methods

+ (instancetype)sessionSettings
{
    static BTRSessionSettings *sessionSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionSettings = [[self alloc] init];
    });
    return sessionSettings;
}

#pragma mark - Properties

static NSString *const kShouldSkipLoginKey = @"shouldSkipLogin";
static NSString *const kLoggedInWithFacebook = @"loggedInWithFacebook";

static NSString *const kSessionId = @"sessionId";
static NSString *const kPassword = @"password";
static NSString *const kEmail = @"email";
static NSString *const kFullName = @"fullName";


- (NSString *)sessionId {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kSessionId];
}



- (void)setSessionId:(NSString *)sessionId {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionId forKey:kSessionId];
    [defaults synchronize];
}


- (BOOL)fbLoggedIn {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kLoggedInWithFacebook];
}


- (void)setFbLoggedIn:(BOOL)fbLoggedIn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:fbLoggedIn forKey:kLoggedInWithFacebook];
    [defaults synchronize];
}


- (NSString *)email {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kEmail];
}


- (NSString *)password {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kPassword];
}


- (NSString *)fullName {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:kFullName];
}


- (BOOL)activeSessionPresent {
    
    if ([[self sessionId] length] > 10)
        return YES;
    
    return NO;
}



- (void)clearSession {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:kSessionId];
    [defaults setObject:@"" forKey:kEmail];
    [defaults setObject:@"" forKey:kPassword];
    [defaults setObject:@"" forKey:kFullName];
    [defaults setBool:NO forKey:kLoggedInWithFacebook];
    
    [defaults synchronize];
}


- (void)initSessionId:(NSString *)sessionId withEmail:(NSString *)email andPassword:(NSString *)password hasFBloggedIn:(BOOL)fbLoggedIn {
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionId forKey:kSessionId];
    [defaults setObject:email forKey:kEmail];
    [defaults setObject:password forKey:kPassword];
    [defaults setBool:fbLoggedIn forKey:kLoggedInWithFacebook];

    [defaults synchronize];
}


- (void)initSessionId:(NSString *)sessionId withEmail:(NSString *)email andPassword:(NSString *)password hasFBloggedIn:(BOOL)fbLoggedIn forName:(NSString *)fullName {
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessionId forKey:kSessionId];
    [defaults setObject:email forKey:kEmail];
    [defaults setObject:password forKey:kPassword];
    [defaults setBool:fbLoggedIn forKey:kLoggedInWithFacebook];
    [defaults setObject:fullName forKey:kFullName];
    
    [defaults synchronize];
}




- (void)updatePassword:(NSString *)neuPassword {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:neuPassword forKey:kPassword];
}



@end




















