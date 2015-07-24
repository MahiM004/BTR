//
//  BTROrderHistoryFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTROrderHistoryFetcher.h"

@implementation BTROrderHistoryFetcher

+ (NSURL *)URLforOrderHistory {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/orders", BASEURL]];
}


@end
