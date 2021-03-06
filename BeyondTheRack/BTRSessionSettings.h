//
//  BTRSettings.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-28.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRSessionSettings : NSObject


+ (instancetype)sessionSettings;

- (NSString *)sessionId;
- (void)setSessionId:(NSString *)sessionId;

- (BOOL)activeSessionPresent;
- (BOOL)fbLoggedIn;

- (NSString *)email;
- (NSString *)password;
- (NSString *)fullName;


- (void)clearSession;


- (void)initSessionId:(NSString *)sessionId withEmail:(NSString *)email andPassword:(NSString *)password hasFBloggedIn:(BOOL)fbLoggedIn;
- (void)initSessionId:(NSString *)sessionId withEmail:(NSString *)email andPassword:(NSString *)password hasFBloggedIn:(BOOL)fbLoggedIn forName:(NSString *)fullName;

- (void)updatePassword:(NSString *)neuPassword;
 
- (BOOL)isUserLoggedIn;

@end
