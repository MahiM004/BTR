//
//  BTRUserFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"

@interface BTRUserFetcher : BTRFetcher


+ (NSURL *)URLforUserAuthentication;
+ (NSURL *)URLforUserLogout;
+ (NSURL *)URLforUserInfo;
+ (NSURL *)URLforUserCredits;
+ (NSURL *)URLforUserOrders;
+ (NSURL *)URLforUserOrderItems;
+ (NSURL *)URLforUserRegistration;


@end
