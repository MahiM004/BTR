//
//  BTREventFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTREventFetcher.h"

@implementation BTREventFetcher

+ (NSURL *)URLforRecentEventsForURLCategoryName:(NSString *)urlCategoryName
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/%@", BASEURL, urlCategoryName]];
}

+ (NSURL *)URLforAllRecentEvents
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/events/all", BASEURL]];
}

+ (NSURL *)URLforEventImageWithId:(NSString *)imageId
{
    return [self URLForQuery:[NSString stringWithFormat:@"http:%@", imageId]];
}

@end
