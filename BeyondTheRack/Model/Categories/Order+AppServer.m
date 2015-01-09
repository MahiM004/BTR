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
    request.predicate = [NSPredicate predicateWithFormat:@"orderId = %@", unique];
    
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


@end
