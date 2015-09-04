//
//  BTRPaypalFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRPaypalFetcher.h"

@implementation BTRPaypalFetcher

+ (NSURL *)URLforStartPaypal {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/paypal", BASEURL]];
}

+ (NSURL *)URLforPaypalInfo {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/info/paypal", BASEURL]];
}

+ (NSURL *)URLforPaypalProcess {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/process/paypal", BASEURL]];
}

+ (NSURL *)URLforPaypalProcessCallBackWithTransactionNumber:(NSString *)transaction {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/process/paypal/%@", BASEURL,transaction]];
}

+ (NSURL *)URLforCancelPaypal {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/paypal?token=", BASEURL]];
}

+ (NSURL *)URLforPayment {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/info/paypal?token=", BASEURL]];
}

@end
