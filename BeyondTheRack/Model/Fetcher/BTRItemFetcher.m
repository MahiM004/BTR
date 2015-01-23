//
//  BTRItemFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-22.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRItemFetcher.h"

@implementation BTRItemFetcher


+ (NSURL *)URLforItemWithSku:(NSString *)sku
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/mobile/%@", RC03URL, sku]];
}


+ (NSURL *)URLforRecentItemsForEventId:(NSString *)eventId
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/%@", BASEURL, eventId]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/mobile/?q=%@", RC03URL, searchQuery]];
}

+ (NSURL *)URLforItemImageForSku:(NSString *)sku
{

    return [self URLForQuery:[NSString stringWithFormat:@"%@/productimages/%@/medium/%@_1.jpg", STATICURL,sku, sku]];
}


@end
