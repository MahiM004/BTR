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
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/mobile/%@", LIVEURL, sku]];
}


+ (NSURL *)URLforRecentItemsForEventId:(NSString *)eventId
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/%@", BASEURL, eventId]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery andPageNumber:(NSUInteger)pageNumber
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/query?q=%@&page=%lu", LIVEURL, searchQuery, (unsigned long)pageNumber]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withFacetString:(NSString *)facetsString andPageNumber:(NSUInteger)pageNumber {

    NSLog(@"something:  %@", [NSString stringWithFormat:@"%@/search/query?q=%@&page=%lu&facets=%@", LIVEURL, searchQuery, (unsigned long)pageNumber, facetsString]);
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/query?q=%@&page=%lu&facets=%@", LIVEURL, searchQuery, (unsigned long)pageNumber, facetsString]];
}



+ (NSURL *)URLforItemImageForSku:(NSString *)sku
{

    return [self URLForQuery:[NSString stringWithFormat:@"%@/productimages/%@/medium/%@_1.jpg", STATICURL,sku, sku]];
}


+ (NSString *)contentTypeForSearchQuery {
    
    return @"text/html";
}


@end
