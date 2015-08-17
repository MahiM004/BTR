//
//  BTRPaypalFetcher.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRFetcher.h"

@interface BTRPaypalFetcher : BTRFetcher

+ (NSURL *)URLforStartPaypal;
+ (NSURL *)URLforPaypalInfo;
+ (NSURL *)URLforPaypalProcess;
+ (NSURL *)URLforPaypalProcessCallBackWithTransactionNumber:(NSString *)transaction;

@end
