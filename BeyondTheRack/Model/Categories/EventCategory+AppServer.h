//
//  EventCategory+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//


#import "EventCategory.h"

/**
 *
 *  This category is used to reading the JSON object into its corresponding model
 *
 */

@interface EventCategory (AppServer)

+ (EventCategory *)eventWithAppServerInfo:(NSDictionary *)eventDictionary;

+ (NSMutableArray *)loadCategoriesfromAppServerArray:(NSArray *)eventCategories forCategoriesArray:(NSMutableArray *)categoriesArray; // of AppServer EventCategory NSDictionary


@end
