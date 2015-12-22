//
//  BTRSKUContentFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-12-22.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSKUContentFetcher.h"

@implementation BTRSKUContentFetcher

+ (NSURL *)URLForContent {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/content/sku?render=text", BASEURL]];
}

@end
