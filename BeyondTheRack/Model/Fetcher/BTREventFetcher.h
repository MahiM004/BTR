//
//  BTREventFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTRFetcher.h"

@interface BTREventFetcher : BTRFetcher

+ (NSURL *)URLforRecentEventsForURLCategoryName:(NSString *)urlCategoryName;
+ (NSURL *)URLforAllRecentEvents;
+ (NSURL *)URLforEventImageWithId:(NSString *)imageId;

@end
