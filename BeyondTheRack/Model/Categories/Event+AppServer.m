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
        
        
        
        
        /*
        
        @property (nonatomic, retain) NSString * categoryId;
        @property (nonatomic, retain) NSString * discount;
        @property (nonatomic, retain) NSString * eventDescription;
        @property (nonatomic, retain) NSString * eventId;
        @property (nonatomic, retain) NSDate * expiryDateTime;
        @property (nonatomic, retain) NSString * imageName;
        @property (nonatomic, retain) NSString * saveUpTo;
        @property (nonatomic, retain) NSString * title;
        
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
