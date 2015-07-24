//
//  BTRFAQFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFAQFetcher.h"

@implementation BTRFAQFetcher

+ (NSURL *)URLforFAQ
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/content/faq", BASEURL]];
}

@end
