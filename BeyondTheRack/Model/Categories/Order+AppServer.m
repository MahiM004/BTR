//
//  Order+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Order+AppServer.h"

@implementation Order (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    Order *order = nil;
    
    order = [NSEntityDescription insertNewObjectForEntityForName:@"Order"
                                                    inManagedObjectContext:context];
    
    order.orderStatus = @"dummy";
}


+ (Order *)orderWithAppServerInfo:(NSDictionary *)orderDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    Order *order = nil;
    NSString *unique = orderDictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Order"];
    request.predicate = [NSPredicate predicateWithFormat:@"orderId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        order = [matches firstObject];
        
        if ([orderDictionary valueForKeyPath:@"id"])
            order.orderId = [orderDictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        order = [NSEntityDescription insertNewObjectForEntityForName:@"Order"
                                                        inManagedObjectContext:context];
        
        if ([[orderDictionary valueForKeyPath:@"id"] stringValue])
            order.orderId = [[orderDictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return order;
}

+ (NSMutableArray *)loadOrdersFromAppServerArray:(NSArray *)orders // of AppServer Order NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *orderArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *order in orders) {
        
        NSObject *someObject = [self orderWithAppServerInfo:order inManagedObjectContext:context];
        if (someObject)
            [orderArray addObject:someObject];
        
    }
    
    return orderArray;
}




+ (Order *)extractOrderfromJSONDictionary:(NSDictionary *)orderDictionary withServerTime:(NSDate *)serverTime forOrder:(Order *)order {
    
    /*
    bagItem.serverDateTime = serverTime;
    
    if ([bagItemDictionary valueForKeyPath:@"sku"] && [bagItemDictionary valueForKeyPath:@"sku"] != [NSNull null]) {
        bagItem.sku = [bagItemDictionary valueForKeyPath:@"sku"];
    }
    
    if ([bagItemDictionary valueForKeyPath:@"variant"] && [bagItemDictionary valueForKeyPath:@"variant"] != [NSNull null]) {
        bagItem.variant = [bagItemDictionary valueForKeyPath:@"variant"];
    }
    
    if ([bagItemDictionary valueForKeyPath:@"event_id"] && [bagItemDictionary valueForKeyPath:@"event_id"] != [NSNull null])
        bagItem.eventId = [bagItemDictionary valueForKeyPath:@"event_id"];
    
    if ([bagItemDictionary valueForKeyPath:@"quantity"] && [bagItemDictionary valueForKeyPath:@"quantity"] != [NSNull null]) {
        NSString *tempString = [NSString stringWithFormat:@"%@", [bagItemDictionary valueForKeyPath:@"quantity"]];
        bagItem.quantity = tempString;
    }
    
    if ([bagItemDictionary valueForKeyPath:@"cart_time"] && [bagItemDictionary valueForKeyPath:@"cart_time"] != [NSNull null]) {
        
        NSLog(@"time difference NEEDS to be considered from backend!");
        
        bagItem.createDateTime = [NSDate dateWithTimeIntervalSince1970:[[bagItemDictionary valueForKeyPath:@"cart_time"] integerValue]];
        NSDate *nowDate = [NSDate date];
        NSTimeInterval interval = [nowDate timeIntervalSinceDate:serverTime];
        bagItem.dueDateTime =  [bagItem.createDateTime dateByAddingTimeInterval:1200];
        bagItem.dueDateTime = [bagItem.dueDateTime dateByAddingTimeInterval:interval];
    }
    */
    return order;
}





@end


























