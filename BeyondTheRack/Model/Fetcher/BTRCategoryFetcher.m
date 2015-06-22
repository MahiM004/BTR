//
//  BTREventCategoryFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCategoryFetcher.h"

@implementation BTRCategoryFetcher


+ (NSURL *)URLforCategories
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/categories", BASEURL]];
}

@end