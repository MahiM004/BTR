//
//  BTRItemFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-22.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRItemFetcher.h"

@implementation BTRItemFetcher


+ (NSURL *)URLforItemWithProductSku:(NSString *)sku
{
    NSLog(@"through product-sku: %@", [NSString stringWithFormat:@"%@/product/%@", BASEURL, sku]);
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/product/%@", BASEURL, sku]];
}


+ (NSURL *)URLforAllItemsWithEventSku:(NSString *)eventSku {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/eventskus/%@&limit=100", BASEURL, eventSku]];
}


+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString andPageNumber:(NSUInteger)pageNumber
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/query?q=%@&page=%lu%@", LIVEURL, searchQuery, (unsigned long)pageNumber, sortString]];
}

+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery withSortString:(NSString *)sortString withFacetString:(NSString *)facetsString andPageNumber:(NSUInteger)pageNumber {
       
    if ([facetsString length] == 0)
        return [self URLforSearchQuery:searchQuery withSortString:sortString andPageNumber:pageNumber];
    
    
    NSString *encodedFacetString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)facetsString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/search/query?q=%@&page=%lu&facets=%@%@", LIVEURL, searchQuery, (unsigned long)pageNumber, encodedFacetString, sortString]];
}



+ (NSURL *)URLforItemImageForSku:(NSString *)sku
{
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/productimages/%@/medium/%@_1.jpg", STATICURL,sku, sku]];
}

// TODO: change text/html to application/json AFTER backend supports it in production
+ (NSString *)contentTypeForSearchQuery {
    
    return @"text/html";
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
