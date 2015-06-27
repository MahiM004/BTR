//
//  EventCategory+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "EventCategory+AppServer.h"

@implementation EventCategory (AppServer)



+ (EventCategory *)eventWithAppServerInfo:(NSDictionary *)eventDictionary
{
    EventCategory *eventCategory = [[EventCategory alloc] init];

    eventCategory = [self extractCategoriesFromJSONDictionary:eventDictionary forCategory:eventCategory];
    
    return eventCategory;
}

+ (NSMutableArray *)loadCategoriesfromAppServerArray:(NSArray *)eventCategories  forCategoriesArray:(NSMutableArray *)categoriesArray // of AppServer EventCategory NSDictionary
{
    
    
    for (NSDictionary *eventCategory in eventCategories) {
        
        NSObject *someObject = [self eventWithAppServerInfo:eventCategory];
        if (someObject)
            [categoriesArray addObject:someObject];
        
    }
    
    return categoriesArray;
}


+ (EventCategory *)extractCategoriesFromJSONDictionary:(NSDictionary *)categoryDictionary forCategory:(EventCategory *)eventCatgeory {

    
    if ([categoryDictionary valueForKeyPath:@"id"] && [categoryDictionary valueForKeyPath:@"id"] != [NSNull null])
        eventCatgeory.categoryId = [categoryDictionary valueForKeyPath:@"id"];

    if ([categoryDictionary valueForKeyPath:@"name"] && [categoryDictionary valueForKeyPath:@"name"] != [NSNull null])
        eventCatgeory.name = [categoryDictionary valueForKeyPath:@"name"];
    
    //if ([categoryDictionary valueForKeyPath:@"sort_criteria"] && [categoryDictionary valueForKeyPath:@"sort_criteria"] != [NSNull null])
      //  eventCatgeory.sortCriteria = [categoryDictionary valueForKeyPath:@"sort_criteria"];
    
    //if ([categoryDictionary valueForKeyPath:@"sort_criteria_new_site"] && [categoryDictionary valueForKeyPath:@"sort_criteria_new_site"] != [NSNull null])
      //  eventCatgeory.sortCriteriaNewSite = [categoryDictionary valueForKeyPath:@"sort_criteria_new_site"];
    
    if ([categoryDictionary valueForKeyPath:@"category_order"] && [categoryDictionary valueForKeyPath:@"category_order"] != [NSNull null])
        eventCatgeory.categoryOrder = [categoryDictionary valueForKeyPath:@"category_order"];
    
    if ([categoryDictionary valueForKeyPath:@"active"] && [categoryDictionary valueForKeyPath:@"active"] != [NSNull null])
        eventCatgeory.active = [categoryDictionary valueForKeyPath:@"active"];
    
    if ([categoryDictionary valueForKeyPath:@"display_name"] && [categoryDictionary valueForKeyPath:@"display_name"] != [NSNull null])
        eventCatgeory.displayName = [categoryDictionary valueForKeyPath:@"display_name"];
    
    
    
    return eventCatgeory;
}

@end

















