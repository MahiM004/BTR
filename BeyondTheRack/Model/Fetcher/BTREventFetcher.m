//
//  BTREventFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventFetcher.h"

@implementation BTREventFetcher



+ (NSURL *)URLforRecentEventsForCategoryId:(NSString *)categoryId
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/%@", BASEURL, categoryId]];
}

+ (NSURL *)URLforAllRecentEvents
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/all", BASEURL]];
}

+ (NSURL *)URLforEventImageWithId:(NSString *)imageId
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/%@", BASEURL, imageId]];
}

@end
