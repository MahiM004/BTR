//
//  BTRItemFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-22.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRItemFetcher.h"

@implementation BTRItemFetcher

+ (NSURL *)URLforItemWithProductSku:(NSString *)sku {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/product/%@", BASEURL, sku]];
}

+ (NSURL *)URLforItemWithProductSku:(NSString *)sku forCountry:(NSString *)country {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/product/%@?filter=%@", BASEURL, sku,country]];
}

+ (NSURL *)URLforAllItemsWithEventSku:(NSString *)eventSku inPageNumber:(int)pageNum withSortingMode:(sortMode)sortingMode andSizeFilter:(NSString *)size {
    if (sortingMode != kSUGGESTED) {
        if ([size isEqualToString:defaultSize])
            return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&filter=%@&limit=%i", BASEURL, eventSku,pageNum,sortingMode,MAX_ITEMS_PER_PAGE]];
        return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&filter=%@&limit=%i&size=%@", BASEURL, eventSku,pageNum,sortingMode,MAX_ITEMS_PER_PAGE,size]];
    } else if ([size isEqualToString:defaultSize])
        return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&limit=%i", BASEURL, eventSku,pageNum,MAX_ITEMS_PER_PAGE]];
    else
     return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&limit=%i&size=%@", BASEURL, eventSku,pageNum,MAX_ITEMS_PER_PAGE,size]];
}

+ (NSURL *)URLforAllItemsWithEventSku:(NSString *)eventSku inPageNumber:(int)pageNum withSortingMode:(sortMode)sortingMode andSizeFilter:(NSString *)size forCountry:(NSString *)country {
    if (sortingMode != kSUGGESTED) {
        if ([size isEqualToString:defaultSize])
            return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&filter=%@;%@&limit=%i", BASEURL, eventSku,pageNum,sortingMode,country,MAX_ITEMS_PER_PAGE]];
        return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&filter=%@;%@&limit=%i&size=%@", BASEURL, eventSku,pageNum,sortingMode,country,MAX_ITEMS_PER_PAGE,size]];
    } else if ([size isEqualToString:defaultSize])
        return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&limit=%i&filter=%@", BASEURL, eventSku,pageNum,MAX_ITEMS_PER_PAGE,country]];
    else
        return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@?page=%i&limit=%i&size=%@&filter=%@", BASEURL, eventSku,pageNum,MAX_ITEMS_PER_PAGE,size,country]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString andPageNumber:(NSUInteger)pageNumber{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search?q=%@&page=%lu%@", BASEURL, searchQuery, (unsigned long)pageNumber, sortString]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString andPageNumber:(NSUInteger)pageNumber forCountry:(NSString *)country{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search?q=%@&country=%@&page=%lu%@", BASEURL, searchQuery,country,(unsigned long)pageNumber, sortString]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString withFacetString:(NSString *)facetsString andPageNumber:(NSUInteger)pageNumber forCountry:(NSString *)country{
    if ([facetsString length] == 0)
        return [self URLforSearchQuery:searchQuery withSortString:sortString andPageNumber:pageNumber forCountry:country];
    NSString *encodedFacetString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                         NULL,
                                                                                                         (CFStringRef)facetsString,
                                                                                                         NULL,
                                                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                         kCFStringEncodingUTF8 ));
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search?q=%@&page=%lu&facets=%@%@&country=%@", BASEURL, searchQuery, (unsigned long)pageNumber, encodedFacetString, sortString,country]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString withFacetString:(NSString *)facetsString andPageNumber:(NSUInteger)pageNumber{
    if ([facetsString length] == 0)
        return [self URLforSearchQuery:searchQuery withSortString:sortString andPageNumber:pageNumber];
    NSString *encodedFacetString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)facetsString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
   return [self URLForQuery:[NSString stringWithFormat:@"%@/search?q=%@&page=%lu&facets=%@%@", BASEURL, searchQuery, (unsigned long)pageNumber, encodedFacetString, sortString]];
}
//Static Domain
+ (NSURL *)URLforItemImageForSku:(NSString *)sku{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/productimages/%@/medium/%@_1.jpg", STATICURL,sku, sku]];
}

//Dynamic Domain
+ (NSURL *)URLforItemImageForSkuWithDomain:(NSString *)domainURL withSku:(NSString*)sku{
    return [self URLForQuery:[NSString stringWithFormat:@"https:%@/productimages/%@/medium/%@_1.jpg", [domainURL stringByReplacingOccurrencesOfString:@"\\" withString:@""],sku,sku]];
}

//Static Domain
+ (NSURL *)URLforItemImageForSku:(NSString *)sku withCount:(NSInteger)countNumber andSize:(NSString *)sizeString {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/productimages/%@/%@/%@_%ld.jpg", STATICURL,sku, sizeString, sku, (long)countNumber]];
}

//Dynamic Domain
+ (NSURL *)URLforItemImageForSkuWithDomain:(NSString *)domainURL withSku:(NSString*)sku withCount:(NSInteger)countNumber andSize:(NSString *)sizeString {
    return [self URLForQuery:[NSString stringWithFormat:@"https:%@/productimages/%@/%@/%@_%ld.jpg", [domainURL stringByReplacingOccurrencesOfString:@"\\" withString:@""],sku, sizeString, sku, (long)countNumber]];
}

+ (NSURL *)URLtoShareforEventId:(NSString *)eventId withProductSku:(NSString *)productSku {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/event/sku/%@/%@", WEBBASEURL, eventId, productSku]];
}

+ (NSString *)contentTypeForSearchQuery {
   return @"application/json";
}

- (NSString *)customURLencodeString:(NSString *)unencodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)unencodedString,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 ));
    return encodedString;
}



@end
