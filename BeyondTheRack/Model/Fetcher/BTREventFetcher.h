//
//  BTREventFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRFetcher.h"

#define LIMIT_NUM 35

@interface BTREventFetcher : BTRFetcher

+ (NSURL *)URLforRecentEventsForURLCategoryName:(NSString *)urlCategoryName forPage:(int)pagenum;
+ (NSURL *)URLforAllRecentEvents;
+ (NSURL *)URLforEventImageWithId:(NSString *)imageId;

@end
