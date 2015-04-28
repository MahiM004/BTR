//
//  User+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "User.h"

@interface User (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (User *)userWithAppServerInfo:(NSDictionary *)userDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (User *)userAuthWithAppServerInfo:(NSDictionary *)userDictionary
             inManagedObjectContext:(NSManagedObjectContext *)context;

+ (User *)signUpUserWithAppServerInfo:(NSDictionary *)infoDictionary
                          andUserInfo:(NSDictionary *)userDictionary
               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSDictionary *)extractFacebookUserParamsfromResponseJsonDictionary:(NSDictionary *)jsonResponse withAccessToken:(NSString *)facebookAccessToken;


@end
