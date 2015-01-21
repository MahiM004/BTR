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


+ (Event *)eventWithAppServerInfo:(NSDictionary *)eventDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    Event *event = nil;
    NSString *unique = eventDictionary[@"event_id"];
    
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    request.predicate = [NSPredicate predicateWithFormat:@"eventId = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        event = [matches firstObject];
        
        if ([eventDictionary valueForKeyPath:@"event_id"])
            event.eventId = [eventDictionary valueForKeyPath:@"event_id"];
        
        if ([eventDictionary[@"images"]  valueForKey:@"470x230"])
            event.imageName = [eventDictionary[@"images"]  valueForKey:@"470x230"];
        
        if ([eventDictionary valueForKeyPath:@"short_desc"])
            event.shortEventDescription = [eventDictionary valueForKey:@"short_desc"];
    
        if ([eventDictionary valueForKeyPath:@"long_desc"])
            event.longEventDescription = [eventDictionary valueForKey:@"long_desc"];
        
        if ([eventDictionary valueForKeyPath:@"keyword"])
            event.keyword = [eventDictionary valueForKey:@"keyword"];
        
        if ([eventDictionary valueForKeyPath:@"importance"])
            event.importance = [eventDictionary valueForKey:@"importance"];
        
        if ([eventDictionary valueForKeyPath:@"type"])
            event.eventType = [eventDictionary valueForKey:@"type"];
        
        if ([eventDictionary valueForKeyPath:@"is_flat_rate"])
            event.isFlatRate = [eventDictionary valueForKey:@"is_flat_rate"];
        
        if ([eventDictionary valueForKeyPath:@"is_drop_ship"])
            event.isDropShip = [eventDictionary valueForKey:@"is_drop_ship"];
        
        if ([eventDictionary valueForKeyPath:@"is_white_glove"])
            event.isWhiteGlove = [eventDictionary valueForKey:@"is_white_glove"];
        
        if ([eventDictionary valueForKeyPath:@"top_performers"])
            event.topPerformers = [eventDictionary valueForKey:@"top_performers"];
        
        if ([eventDictionary valueForKeyPath:@"name"])
            event.eventName = [eventDictionary valueForKey:@"name"];
        
        if ([eventDictionary valueForKeyPath:@"active"])
            event.activeEvent = [eventDictionary valueForKey:@"active"];
        
        if ([eventDictionary valueForKeyPath:@"special_note"])
            event.specialNote = [eventDictionary valueForKey:@"special_note"];
        
        if ([eventDictionary valueForKeyPath:@"po_status"])
            event.poStatus = [eventDictionary valueForKey:@"po_status"];
        
        if ([eventDictionary valueForKeyPath:@"tags"])
            event.eventTags = [eventDictionary valueForKey:@"tags"];

        if ([eventDictionary valueForKeyPath:@"outfit_flag"])
            event.outfitFlag = [eventDictionary valueForKey:@"outfit_flag"];
            
        if ([eventDictionary valueForKeyPath:@"category_list"])
            event.categoryList = [eventDictionary valueForKey:@"category_list"];
        
        if ([eventDictionary valueForKeyPath:@"live_upcoming"])
            event.liveUpcoming = [eventDictionary valueForKey:@"live_upcoming"];
        
        if ([eventDictionary valueForKeyPath:@"item_limit"])
            event.itemLimit = [eventDictionary valueForKey:@"item_limit"];
        
        if ([eventDictionary valueForKeyPath:@"include_brand_name"])
            event.includeBrandName = [eventDictionary valueForKey:@"include_brand_name"];
        
        if ([eventDictionary valueForKeyPath:@"show_min_qty_flag"])
            event.showMinQtyFlag = [eventDictionary valueForKey:@"show_min_qty_flag"];
        
        if ([eventDictionary valueForKeyPath:@"show_min_qty_minutes"])
            event.showMinQtyMinutes = [eventDictionary valueForKey:@"show_min_qty_minutes"];
  
                    
        /*
         @dynamic expiryDateTime;
         @dynamic startDateTime;
         @dynamic endDateTime;
        */
        
        
        
        
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        event = [NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                        inManagedObjectContext:context];
        
        
        if ([eventDictionary valueForKeyPath:@"event_id"])
            event.eventId = [eventDictionary valueForKeyPath:@"event_id"];
        
        if ([eventDictionary[@"images"]  valueForKey:@"470x230"])
            event.imageName = [eventDictionary[@"images"]  valueForKey:@"470x230"];
        
        if ([eventDictionary valueForKeyPath:@"short_desc"])
            event.shortEventDescription = [eventDictionary valueForKey:@"short_desc"];
        
        if ([eventDictionary valueForKeyPath:@"long_desc"])
            event.longEventDescription = [eventDictionary valueForKey:@"long_desc"];
        
        if ([eventDictionary valueForKeyPath:@"keyword"])
            event.keyword = [eventDictionary valueForKey:@"keyword"];
        
        if ([eventDictionary valueForKeyPath:@"importance"])
            event.importance = [eventDictionary valueForKey:@"importance"];
        
        if ([eventDictionary valueForKeyPath:@"type"])
            event.eventType = [eventDictionary valueForKey:@"type"];
        
        if ([eventDictionary valueForKeyPath:@"is_flat_rate"])
            event.isFlatRate = [eventDictionary valueForKey:@"is_flat_rate"];
        
        if ([eventDictionary valueForKeyPath:@"is_drop_ship"])
            event.isDropShip = [eventDictionary valueForKey:@"is_drop_ship"];
        
        if ([eventDictionary valueForKeyPath:@"is_white_glove"])
            event.isWhiteGlove = [eventDictionary valueForKey:@"is_white_glove"];
        
        if ([eventDictionary valueForKeyPath:@"top_performers"])
            event.topPerformers = [eventDictionary valueForKey:@"top_performers"];
        
        if ([eventDictionary valueForKeyPath:@"name"])
            event.eventName = [eventDictionary valueForKey:@"name"];
        
        if ([eventDictionary valueForKeyPath:@"active"])
            event.activeEvent = [eventDictionary valueForKey:@"active"];
        
        if ([eventDictionary valueForKeyPath:@"special_note"])
            event.specialNote = [eventDictionary valueForKey:@"special_note"];
        
        if ([eventDictionary valueForKeyPath:@"po_status"])
            event.poStatus = [eventDictionary valueForKey:@"po_status"];
        
        if ([eventDictionary valueForKeyPath:@"tags"])
            event.eventTags = [eventDictionary valueForKey:@"tags"];
        
        if ([eventDictionary valueForKeyPath:@"outfit_flag"])
            event.outfitFlag = [eventDictionary valueForKey:@"outfit_flag"];
        
        if ([eventDictionary valueForKeyPath:@"category_list"])
            event.categoryList = [eventDictionary valueForKey:@"category_list"];
        
        if ([eventDictionary valueForKeyPath:@"live_upcoming"])
            event.liveUpcoming = [eventDictionary valueForKey:@"live_upcoming"];
        
        if ([eventDictionary valueForKeyPath:@"item_limit"])
            event.itemLimit = [eventDictionary valueForKey:@"item_limit"];
        
        if ([eventDictionary valueForKeyPath:@"include_brand_name"])
            event.includeBrandName = [eventDictionary valueForKey:@"include_brand_name"];
        
        if ([eventDictionary valueForKeyPath:@"show_min_qty_flag"])
            event.showMinQtyFlag = [eventDictionary valueForKey:@"show_min_qty_flag"];
        
        if ([eventDictionary valueForKeyPath:@"show_min_qty_minutes"])
            event.showMinQtyMinutes = [eventDictionary valueForKey:@"show_min_qty_minutes"];
        
        
        /*
         @dynamic expiryDateTime;
         @dynamic startDateTime;
         @dynamic endDateTime;
         */
        

    }
    
    return event;
}

+ (NSMutableArray *)loadEventsFromAppServerArray:(NSArray *)events // of AppServer Event NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *eventArray = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *event in events) {
        
        NSObject *someObject = [self eventWithAppServerInfo:event inManagedObjectContext:context];
        if (someObject)
            [eventArray addObject:someObject];
        
    }
    
    return eventArray;
}


@end
