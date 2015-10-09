//
//  BTROrderFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTROrderFetcher.h"

@implementation BTROrderFetcher


+ (NSURL *)URLforPaymentMethods {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/paymentmethods", BASEURL]];
}

+ (NSURL *)URLforCheckoutInfo {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/info", BASEURL]];
}

+ (NSURL *)URLforAddressValidation {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/validateaddress", BASEURL]];
}

+ (NSURL *)URLforGiftCardRedeem {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/giftcard/redeem", BASEURL]];
}

+ (NSURL *)URLforCheckoutProcess {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/process", BASEURL]];
}

+ (NSURL *)URLforOrderNumber:(NSString *)orderNumberString {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/order/%@/details", BASEURL, orderNumberString]];
}

@end
