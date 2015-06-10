//
//  BTRBagFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRBagFetcher.h"

@implementation BTRBagFetcher



+ (NSURL *)URLforBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag", BASEURL]];
}


+ (NSURL *)URLforBagCount {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/count", BASEURL]];
}


+ (NSURL *)URLforSetBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/update", BASEURL]];
}

+ (NSURL *)URLforAddtoBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/add", BASEURL]];
}


+ (NSURL *)URLforRemovefromBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/remove", BASEURL]];
}


+ (NSURL *)URLforClearBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/clear", BASEURL]];
}



/**
  API URLs for Checkout
 */


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








