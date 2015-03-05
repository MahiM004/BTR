//
//  BTRItemFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-22.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRFetcher.h"


@interface BTRItemFetcher : BTRFetcher

+ (NSURL *)URLforItemWithProductSku:(NSString *)sku;
+ (NSURL *)URLforAllItemsWithEventSku:(NSString *)eventSku;

+ (NSURL *)URLforItemImageForSku:(NSString *)sku;

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString andPageNumber:(NSUInteger)pageNumber;
+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString withFacetString:(NSString *)facetsString andPageNumber:(NSUInteger)pageNumber;
+ (NSString *)contentTypeForSearchQuery;

@end
