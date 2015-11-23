//
//  BTRApplePayFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-11-18.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRApplePayFetcher.h"

@implementation BTRApplePayFetcher

+ (NSURL *)URLForRequestToken {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/applepay", BASEURL]];
}

+ (NSURL *)URLForCheckout {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/process/applepay", BASEURL]];
}

@end
