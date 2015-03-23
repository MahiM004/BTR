//
//  Event+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Event+AppServer.h"

@implementation Event (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    Event *event = nil;
    
    event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                    inManagedObjectContext:context];
    
    event.eventDescription = @"dummy";
}


+ (Event *)eventWithAppServerInfo:(NSDictionary *)eventDictionary andCategoryName:(NSString *)myCategoryName
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    Event *event = nil;
    NSString *unique = eventDictionary[@"event_id"];
    
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"eventId == %@ AND myCategoryName == %@", unique, myCategoryName];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        event = [matches firstObject];
        
        event = [self extractEventFromJSONDictionary:eventDictionary forEvent:event andCategoryName:myCategoryName];
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                        inManagedObjectContext:context];
        
        event = [self extractEventFromJSONDictionary:eventDictionary forEvent:event andCategoryName:myCategoryName];
        
    }
    
    return event;
}

+ (NSMutableArray *)loadEventsFromAppServerArray:(NSArray *)events andCategoryName:(NSString *)myCategoryName// of AppServer Event NSDictionary
                        intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *eventArray = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *event in events) {
        
        NSObject *someObject = [self eventWithAppServerInfo:event andCategoryName:myCategoryName inManagedObjectContext:context];
        if (someObject)
            [eventArray addObject:someObject];
        
    }
    
    return eventArray;
}


+ (Event *)extractEventFromJSONDictionary:(NSDictionary *)eventDictionary forEvent:(Event *)event andCategoryName:(NSString *)myCategoryName {
    
    
    if (myCategoryName)
        event.myCategoryName = myCategoryName;
    
    if ([eventDictionary valueForKeyPath:@"event_id"] && [eventDictionary valueForKeyPath:@"event_id"] != [NSNull null])
        event.eventId = [eventDictionary valueForKeyPath:@"event_id"];
    
    if ([eventDictionary[@"images"]  valueForKey:@"470x230"] && [eventDictionary[@"images"] valueForKeyPath:@"470x230"] != [NSNull null])
        event.imageName = [eventDictionary[@"images"]  valueForKey:@"470x230"];
    
    if ([eventDictionary valueForKeyPath:@"short_desc"] && [eventDictionary valueForKeyPath:@"short_desc"] != [NSNull null])
        event.shortEventDescription = [eventDictionary valueForKey:@"short_desc"];
    
    if ([eventDictionary valueForKeyPath:@"long_desc"] && [eventDictionary valueForKeyPath:@"long_desc"] != [NSNull null])
        event.longEventDescription = [eventDictionary valueForKey:@"long_desc"];
    
    if ([eventDictionary valueForKeyPath:@"keyword"] && [eventDictionary valueForKeyPath:@"keyword"] != [NSNull null])
        event.keyword = [eventDictionary valueForKey:@"keyword"];
    
    if ([eventDictionary valueForKeyPath:@"importance"] && [eventDictionary valueForKeyPath:@"importance"] != [NSNull null])
        event.importance = [eventDictionary valueForKey:@"importance"];
    
    if ([eventDictionary valueForKeyPath:@"type"] && [eventDictionary valueForKeyPath:@"type"] != [NSNull null])
        event.eventType = [eventDictionary valueForKey:@"type"];
    
    if ([eventDictionary valueForKeyPath:@"is_flat_rate"] && [eventDictionary valueForKeyPath:@"is_flat_rate"] != [NSNull null])
        event.isFlatRate = [eventDictionary valueForKey:@"is_flat_rate"];
    
    if ([eventDictionary valueForKeyPath:@"is_drop_ship"] && [eventDictionary valueForKeyPath:@"is_drop_ship"] != [NSNull null])
        event.isDropShip = [eventDictionary valueForKey:@"is_drop_ship"];
    
    if ([eventDictionary valueForKeyPath:@"is_white_glove"] && [eventDictionary valueForKeyPath:@"is_white_glove"] != [NSNull null])
        event.isWhiteGlove = [eventDictionary valueForKey:@"is_white_glove"];
    
    if ([eventDictionary valueForKeyPath:@"top_performers"] && [eventDictionary valueForKeyPath:@"top_performers"] != [NSNull null])
        event.topPerformers = [eventDictionary valueForKey:@"top_performers"];
    
    if ([eventDictionary valueForKeyPath:@"name"] && [eventDictionary valueForKeyPath:@"name"] != [NSNull null])
        event.eventName = [eventDictionary valueForKey:@"name"];
    
    if ([eventDictionary valueForKeyPath:@"active"] && [eventDictionary valueForKeyPath:@"active"] != [NSNull null])
        event.activeEvent = [eventDictionary valueForKey:@"active"];
    
    if ([eventDictionary valueForKeyPath:@"special_note"] && [eventDictionary valueForKeyPath:@"special_note"] != [NSNull null])
        event.specialNote = [eventDictionary valueForKey:@"special_note"];
    
    if ([eventDictionary valueForKeyPath:@"po_status"] && [eventDictionary valueForKeyPath:@"po_status"] != [NSNull null])
        event.poStatus = [eventDictionary valueForKey:@"po_status"];
    
    if ([eventDictionary valueForKeyPath:@"tags"] && [eventDictionary valueForKeyPath:@"tags"] != [NSNull null])
        event.eventTags = [eventDictionary valueForKey:@"tags"];
    
    if ([eventDictionary valueForKeyPath:@"outfit_flag"] && [eventDictionary valueForKeyPath:@"outfit_flag"] != [NSNull null])
        event.outfitFlag = [eventDictionary valueForKey:@"outfit_flag"];
    
    if ([eventDictionary valueForKeyPath:@"category_list"] && [eventDictionary valueForKeyPath:@"category_list"] != [NSNull null])
        event.categoryList = [eventDictionary valueForKey:@"category_list"];
    
    if ([eventDictionary valueForKeyPath:@"live_upcoming"] && [eventDictionary valueForKeyPath:@"live_upcoming"] != [NSNull null])
        event.liveUpcoming = [eventDictionary valueForKey:@"live_upcoming"];
    
    if ([eventDictionary valueForKeyPath:@"item_limit"] && [eventDictionary valueForKeyPath:@"item_limit"] != [NSNull null])
        event.itemLimit = [eventDictionary valueForKey:@"item_limit"];
    
    if ([eventDictionary valueForKeyPath:@"include_brand_name"] && [eventDictionary valueForKeyPath:@"include_brand_name"] != [NSNull null])
        event.includeBrandName = [eventDictionary valueForKey:@"include_brand_name"];
    
    if ([eventDictionary valueForKeyPath:@"show_min_qty_flag"] && [eventDictionary valueForKeyPath:@"show_min_qty_flag"] != [NSNull null])
        event.showMinQtyFlag = [eventDictionary valueForKey:@"show_min_qty_flag"];
    
    if ([eventDictionary valueForKeyPath:@"show_min_qty_minutes"] && [eventDictionary valueForKeyPath:@"show_min_qty_minutes"] != [NSNull null])
        event.showMinQtyMinutes = [eventDictionary valueForKey:@"show_min_qty_minutes"];
    

    /*
     @dynamic expiryDateTime;
     @dynamic startDateTime;
     @dynamic endDateTime;
     */
    
    
    return event;
}




@end






































