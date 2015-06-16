//
//  BTROrderFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"

@interface BTROrderFetcher : BTRFetcher



+ (NSURL *)URLforPaymentMethods;
+ (NSURL *)URLforCheckoutInfo;
+ (NSURL *)URLforAddressValidation;
+ (NSURL *)URLforGiftCardRedeem;
+ (NSURL *)URLforCheckoutProcess;
+ (NSURL *)URLforOrderNumber:(NSString *)orderNumberString;


@end
