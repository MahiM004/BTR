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
    return [self URLForQuery:[NSString stringWithFormat:@"%@/register/facebook", BASEURL]];
}


+ (NSURL *)URLforFacebookLogin {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/authenticate/facebook", BASEURL]];
}


/*
 
 http://www.mobile.btrdev.com/siteapi/user/logout
 http://www.mobile.btrdev.com/siteapi/user/credits
 http://www.mobile.btrdev.com/siteapi/user/orders
 http://www.mobile.btrdev.com/siteapi/user/orderitems
 http://www.mobile.btrdev.com/siteapi/user/info
 http://www.mobile.btrdev.com/siteapi/user
 => requires "SESSION" http header with authentication session ID
 
 */


@end













