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

+ (NSURL *)URLforItemWithSku:(NSString *)sku;
+ (NSURL *)URLforRecentItemsForEventId:(NSString *)eventId;
+ (NSURL *)URLforSearchQuery:(NSString *)searchQuery forCountry:(NSString *)country andPageNumber:(NSUInteger)pageNumber;
+ (NSURL *)URLforItemImageForSku:(NSString *)sku;

@end
