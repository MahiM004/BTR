//
//  User+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "User+AppServer.h"

@implementation User (AppServer)


+ (User *)signUpUserWithAppServerInfo:(NSDictionary *)infoDictionary
                          andUserInfo:(NSDictionary *)userDictionary
                              forUser:(User *)user
{
    user = [self extractUserFromJSONDictionary:infoDictionary forUser:user];
    user = [self extractUserAuthFromJSONDictionary:userDictionary forUser:user];
    
    return user;
}


+ (User *)userWithAppServerInfo:(NSDictionary *)userDictionary forUser:(User *)user {
    
    
    user = [self extractUserFromJSONDictionary:userDictionary forUser:user];
    
    return user;
}

+ (User *)extractUserFromJSONDictionary:(NSDictionary *)userDictionary forUser:(User *)user  {
 
    
    if ([userDictionary valueForKeyPath:@"uid"]  != [NSNull null])
        user.userId = [userDictionary valueForKeyPath:@"uid"];

    if ([userDictionary valueForKeyPath:@"name"]  != [NSNull null])
        user.name = [userDictionary valueForKeyPath:@"name"];

    if ([userDictionary valueForKeyPath:@"last_name"] != [NSNull null])
        user.lastName = [userDictionary valueForKeyPath:@"last_name"];
    
    if ([userDictionary valueForKeyPath:@"country"]  != [NSNull null])
        user.country = [userDictionary valueForKeyPath:@"country"];
    
    if ([userDictionary valueForKeyPath:@"gender"] != [NSNull null])
        user.gender = [userDictionary valueForKeyPath:@"gender"];
    
    if ([userDictionary valueForKeyPath:@"postal"]  != [NSNull null])
        user.postalCode = [userDictionary valueForKeyPath:@"postal"];
    
    if ([userDictionary valueForKeyPath:@"email"]  != [NSNull null])
        user.email = [userDictionary valueForKeyPath:@"email"];
    
    if ([userDictionary valueForKeyPath:@"password_hint"]  != [NSNull null])
        user.passwordHint = [userDictionary valueForKeyPath:@"password_hint"];
    
    if ([userDictionary valueForKeyPath:@"personal_code"] != [NSNull null])
        user.personalCode = [userDictionary valueForKeyPath:@"personal_code"];
    
    if ([userDictionary valueForKeyPath:@"invitation_code"]  != [NSNull null])
        user.invitationCode = [userDictionary valueForKeyPath:@"invitation_code"];
    
    if ([userDictionary valueForKeyPath:@"reference"] != [NSNull null])
        user.reference = [userDictionary valueForKeyPath:@"reference"];

    if ([userDictionary valueForKeyPath:@"cobrand_keyword"]  != [NSNull null])
        user.cobrandKeyword = [userDictionary valueForKeyPath:@"cobrand_keyword"];
    
    if ([userDictionary valueForKeyPath:@"preferences_list"] != [NSNull null])
        user.preferencesList = [userDictionary valueForKeyPath:@"preferences_list"];
 
    if ([userDictionary valueForKeyPath:@"notes"]  != [NSNull null])
        user.notes = [userDictionary valueForKeyPath:@"notes"];
    
    if ([userDictionary valueForKeyPath:@"address1"] != [NSNull null])
        user.addressLine1 = [userDictionary valueForKeyPath:@"address1"];
    
    if ([userDictionary valueForKeyPath:@"address2"] != [NSNull null])
        user.addressLine2 = [userDictionary valueForKeyPath:@"address2"];
    
    if ([userDictionary valueForKeyPath:@"city"] != [NSNull null])
        user.city = [userDictionary valueForKeyPath:@"city"];
    
    if ([userDictionary valueForKeyPath:@"region"]  != [NSNull null])
        user.province = [userDictionary valueForKeyPath:@"region"];
    
    if ([userDictionary valueForKeyPath:@"birthdate"]  != [NSNull null])
        user.birthDate = [userDictionary valueForKeyPath:@"birthdate"];
    
    if ([userDictionary valueForKeyPath:@"employee"]  != [NSNull null])
        user.isEmployee = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"employee"]];

    if ([userDictionary valueForKeyPath:@"alternate_email"] != [NSNull null])
        user.alternateEmail = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"alternate_email"]];

    if ([userDictionary valueForKeyPath:@"children"] != [NSNull null])
        user.children = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"children"]];
    
    if ([userDictionary valueForKeyPath:@"education"]  != [NSNull null])
        user.education = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"education"]];
    
    if ([userDictionary valueForKeyPath:@"favorite_shopping"]  != [NSNull null])
        user.favoriteShopping = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"favorite_shopping"]];
    
    if ([userDictionary valueForKeyPath:@"income"]  != [NSNull null])
        user.income = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"income"]];
    
    if ([userDictionary valueForKeyPath:@"marital_status"] != [NSNull null])
        user.maritalStatus = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"marital_status"]];
    
    if ([userDictionary valueForKeyPath:@"occupation"] != [NSNull null])
        user.occupation = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"occupation"]];
    
    if ([userDictionary valueForKeyPath:@"mobile"] != [NSNull null])
        user.mobile = [NSString stringWithFormat:@"%@", [userDictionary valueForKeyPath:@"mobile"]];
    
    
    return user;
}



+ (User *)userAuthWithAppServerInfo:(NSDictionary *)userDictionary forUser:(User *)user {
        
    user = [self extractUserAuthFromJSONDictionary:userDictionary forUser:user];
    
    return user;
}




+ (User *)extractUserAuthFromJSONDictionary:(NSDictionary *)userDictionary forUser:(User *)user  {
    
    
    if ([userDictionary valueForKeyPath:@"uid"] != [NSNull null])
        user.userId = [userDictionary valueForKeyPath:@"uid"];
    
    if ([userDictionary valueForKeyPath:@"email"] != [NSNull null])
        user.email = [userDictionary valueForKeyPath:@"email"];
    
    if ([userDictionary valueForKeyPath:@"password"] != [NSNull null])
        user.password = [userDictionary valueForKeyPath:@"password"];
    
    
    return user;
}



+ (NSDictionary *)extractFacebookUserParamsfromResponseJsonDictionary:(id)jsonResponse withAccessToken:(NSString *)facebookAccessToken {
    
    NSString *facebookUserId = @"";
    NSString *firstName = @"";
    NSString *lastName = @"";
    NSString *gender = @"";
    NSString *email = @"";
    /*
    if ([jsonResponse objectForKey:@"email"] && [jsonResponse valueForKeyPath:@"email"] != [NSNull null])
        email = [jsonResponse valueForKeyPath:@"email"];
    
    if ([jsonResponse objectForKey:@"first_name"] && [jsonResponse valueForKeyPath:@"first_name"] != [NSNull null])
        firstName = [jsonResponse valueForKeyPath:@"first_name"];
    
    if ([jsonResponse objectForKey:@"last_name"] && [jsonResponse valueForKeyPath:@"last_name"] != [NSNull null])
        lastName = [jsonResponse valueForKeyPath:@"last_name"];
    
    if ([jsonResponse objectForKey:@"id"] && [jsonResponse valueForKeyPath:@"id"] != [NSNull null])
        facebookUserId = [jsonResponse valueForKeyPath:@"id"];

    if ([jsonResponse objectForKey:@"gender"] && [jsonResponse valueForKeyPath:@"gender"] != [NSNull null])
        facebookUserId = [jsonResponse valueForKeyPath:@"gender"];
    */
    
    NSDictionary *params = (@{
                              @"id": facebookUserId,
                              @"access_token": facebookAccessToken,
                              @"email": email,
                              @"first_name": firstName,
                              @"last_name": lastName,
                              @"gender": gender
                              });
    
    
    return params;
}



@end












