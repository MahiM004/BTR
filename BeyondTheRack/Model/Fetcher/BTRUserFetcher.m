//
//  BTRUserFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRUserFetcher.h"

@implementation BTRUserFetcher


+ (NSURL *)URLforUserAuthentication {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/authenticate", BASEURL]];
}


+ (NSURL *)URLforUserLogout {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/logout", BASEURL]];
}


+ (NSURL *)URLforUserInfo {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/info", BASEURL]];
}


+ (NSURL *)URLforUserDetail {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/detail", BASEURL]];
}

+ (NSURL *)URLforUserInfoDetail {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/infodetail", BASEURL]];
}

+ (NSURL *)URLforUserCredits {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/credits", BASEURL]];
}

+ (NSURL *)URLforUserOrders {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/orders", BASEURL]];
}


+ (NSURL *)URLforUserOrderItems {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/orderitems", BASEURL]];
}


+ (NSURL *)URLforUserRegistration {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/register", BASEURL]];
}


+ (NSURL *)URLforFacebookRegistration {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/register/facebook", BASEURL]];
}


+ (NSURL *)URLforFacebookAuthentication {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/authenticate/facebook", BASEURL]];
}

+ (NSURL *)URLforCurrentUser {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/currentuser", BASEURL]];
}

+ (NSURL *)URLforDeleteCCToken {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/deletecctoken", BASEURL]];
}

/*
 http://www.mobile.btrdev.com/siteapi/user/logout
 http://www.mobile.btrdev.com/siteapi/user/credits
 http://www.mobile.btrdev.com/siteapi/user/orders
 http://www.mobile.btrdev.com/siteapi/user/orderitems
 http://www.mobile.btrdev.com/siteapi/user/info
 http://www.mobile.btrdev.com/siteapi/user/detail
 http://www.mobile.btrdev.com/siteapi/user/infodetail
 http://www.mobile.btrdev.com/siteapi/user
 http://www.mobile.btrdev.com/siteapi/currentuser
 
 => requires "SESSION" http header with authentication session ID
 */



+ (NSURL *)URLforPasswordReset {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/resetpassword", BASEURL]];
}


@end













