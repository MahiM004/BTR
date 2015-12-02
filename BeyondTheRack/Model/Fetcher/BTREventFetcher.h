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

+ (NSURL *)URLforRecentEventsForURLCategoryName:(NSString *)urlCategoryName forPage:(int)pagenum;
+ (NSURL *)URLforAllRecentEvents;
+ (NSURL *)URLforEventImageWithId:(NSString *)imageId;
+ (NSURL *)URLforRecentEventsForURLCategoryName:(NSString *)urlCategoryName inCountry:(NSString *)country;

@end
