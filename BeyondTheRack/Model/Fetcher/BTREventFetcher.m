//
//  BTREventFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventFetcher.h"

@implementation BTREventFetcher

+ (NSURL *)URLforRecentEventsForURLCategoryName:(NSString *)urlCategoryName forPage:(int)pagenum{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/%@", BASEURL,urlCategoryName]];
//  return [self URLForQuery:[NSString stringWithFormat:@"%@/events/%@?page=%i&limit=%i", BASEURL, urlCategoryName,pagenum,MAX_EVENTS_PER_PAGE]];
}

+ (NSURL *)URLforAllRecentEvents {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/all", BASEURL]];
}

+ (NSURL *)URLforEventImageWithId:(NSString *)imageId {
    return [self URLForQuery:[NSString stringWithFormat:@"%@%@", STATICURL,imageId]];
}

@end
 