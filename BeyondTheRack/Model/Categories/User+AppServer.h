//
//  User+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "User.h"

@interface User (AppServer)

+ (User *)userWithAppServerInfo:(NSDictionary *)userDictionary forUser:(User *)user;

+ (User *)userAuthWithAppServerInfo:(NSDictionary *)userDictionary forUser:(User *)user;

+ (User *)signUpUserWithAppServerInfo:(NSDictionary *)infoDictionary
                          andUserInfo:(NSDictionary *)userDictionary forUser:(User *)user;

+ (NSDictionary *)extractFacebookUserParamsfromResponseJsonDictionary:(NSDictionary *)jsonResponse withAccessToken:(NSString *)facebookAccessToken;


@end
