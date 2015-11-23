//
//  BTRApplePayFetcher.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-11-18.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"

@interface BTRApplePayFetcher : BTRFetcher

+ (NSURL *)URLForRequestToken;
+ (NSURL *)URLForCheckout;

@end
