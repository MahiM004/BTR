//
//  EventCategory+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "EventCategory+AppServer.h"

@implementation EventCategory (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    EventCategory *eventCategory = nil;
    
    eventCategory = [NSEntityDescription insertNewObjectForEntityForName:@"EventCategory"
                                          inManagedObjectContext:context];
    
    eventCategory.name = @"dummy";
}


+ (EventCategory *)eventWithAppServerInfo:(NSDictionary *)eventDictionary
           inManagedObjectContext:(NSManagedObjectContext *)context
{
    EventCategory *eventCategory = nil;
    NSString *unique = eventDictionary[@"id"];
    
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"EventCategory"];
    request.predicate = [NSPredicate predicateWithFormat:@"categoryId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        eventCategory = [matches firstObject];
        
        eventCategory = [self extractCategoriesFromJSONDictionary:eventDictionary forCategory:eventCategory];
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        eventCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                              inManagedObjectContext:context];
        
        eventCategory = [self extractCategoriesFromJSONDictionary:eventDictionary forCategory:eventCategory];
        
    }
    
    return eventCategory;
}

+ (NSMutableArray *)loadCategoriesFromAppServerArray:(NSArray *)eventCategories // of AppServer EventCategory NSDictionary
                        intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *eventCategory in eventCategories) {
        
        NSObject *someObject = [self eventWithAppServerInfo:eventCategory inManagedObjectContext:context];
        if (someObject)
            [categoryArray addObject:someObject];
        
    }
    
    return categoryArray;
}


+ (EventCategory *)extractCategoriesFromJSONDictionary:(NSDictionary *)categoryDictionary forCategory:(EventCategory *)eventCatgeory {
    
    
    
    if ([categoryDictionary valueForKeyPath:@"id"] && [categoryDictionary valueForKeyPath:@"id"] != [NSNull null])
        eventCatgeory.categoryId = [categoryDictionary valueForKeyPath:@"id"];

    
    
    return eventCatgeory;
}

@end

















