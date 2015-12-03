//
//  BTRItemFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-22.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRFetcher.h"

#define SMALL_IMAGE @"small"
#define MEDIUM_IMAGE @"medium"
#define LARGE_IMAGE @"large"

typedef NSString *const sortMode;
static sortMode kDISCOUNTASCENDING = @"orderDiscountAsc",kDISCOUNTDESCENDING = @"orderDiscountDesc",
kPRICEASCENDING = @"orderPriceAsc",kPRICEDESCENDING = @"orderPriceDesc",
kSKUASCENDING = @"orderSkuAsc" ,kSUGGESTED = @"suggested" ;

static NSString *defaultSize = @"Size";

@interface BTRItemFetcher : BTRFetcher

+ (NSURL *)URLforItemWithProductSku:(NSString *)sku;
+ (NSURL *)URLforItemWithProductSku:(NSString *)sku forCountry:(NSString *)country;

+ (NSURL *)URLforAllItemsWithEventSku:(NSString *)eventSku inPageNumber:(int)pageNum withSortingMode:(sortMode)sortingMode andSizeFilter:(NSString *)size;
+ (NSURL *)URLforAllItemsWithEventSku:(NSString *)eventSku inPageNumber:(int)pageNum withSortingMode:(sortMode)sortingMode andSizeFilter:(NSString *)size forCountry:(NSString *)country;

+ (NSURL *)URLforItemImageForSku:(NSString *)sku;
+ (NSURL *)URLforItemImageForSku:(NSString *)sku withCount:(NSInteger)countNumber andSize:(NSString *)sizeString;

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString andPageNumber:(NSUInteger)pageNumber;
+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString andPageNumber:(NSUInteger)pageNumber forCountry:(NSString *)country;
+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString withFacetString:(NSString *)facetsString andPageNumber:(NSUInteger)pageNumber;
+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString withFacetString:(NSString *)facetsString andPageNumber:(NSUInteger)pageNumber forCountry:(NSString *)country;
+ (NSString *)contentTypeForSearchQuery;

+ (NSURL *)URLtoShareforEventId:(NSString *)eventId withProductSku:(NSString *)productSku;


@end
