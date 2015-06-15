//
//  BagItem+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BagItem+AppServer.h"

@implementation BagItem (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    BagItem *bagItem = nil;
    
    bagItem = [NSEntityDescription insertNewObjectForEntityForName:@"BagItem"
                                                    inManagedObjectContext:context];
    
    bagItem.saleUnitPrice = @"dummy";
}


+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary withServerDateTime:(NSDate *)serverTime
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    BagItem *bagItem = nil;
    NSString *unique =[NSString stringWithFormat:@"%@%@", bagItemDictionary[@"sku"], bagItemDictionary[@"variant"]];
    
   
    //  [NSString stringWithFormat:@"%@%@", [bagItemDictionary valueForKeyPath:@"sku"], [bagItemDictionary valueForKeyPath:@"variant"]];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BagItem"];
    request.predicate = [NSPredicate predicateWithFormat:@"bagItemId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        bagItem = [matches firstObject];
        
        bagItem = [self extractBagItemfromJSONDictionary:bagItemDictionary withServerTime:serverTime forBagItem:bagItem];
        
        if ([bagItemDictionary valueForKeyPath:@"sku"]  && [bagItemDictionary valueForKeyPath:@"variant"])
            bagItem.bagItemId = [NSString stringWithFormat:@"%@%@", [bagItemDictionary valueForKeyPath:@"sku"], [bagItemDictionary valueForKeyPath:@"variant"]];
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        bagItem = [NSEntityDescription insertNewObjectForEntityForName:@"BagItem"
                                                        inManagedObjectContext:context];
        bagItem = [self extractBagItemfromJSONDictionary:bagItemDictionary withServerTime:serverTime forBagItem:bagItem];
        
        if ([bagItemDictionary valueForKeyPath:@"sku"]  && [bagItemDictionary valueForKeyPath:@"variant"])
          bagItem.bagItemId = [NSString stringWithFormat:@"%@%@", [bagItemDictionary valueForKeyPath:@"sku"], [bagItemDictionary valueForKeyPath:@"variant"]];
        
    }
    
    return bagItem;
}



+ (NSMutableArray *)loadBagItemsfromAppServerArray:(NSArray *)bagItems withServerDateTime:(NSDate *)serverTime// of AppServer BagItem NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *bagItemArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *bagItem in bagItems) {
        
        NSObject *someObject = [self bagItemWithAppServerInfo:bagItem withServerDateTime:serverTime inManagedObjectContext:context];
        if (someObject)
            [bagItemArray addObject:someObject];
        
    }
    
    return bagItemArray;
}






+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary withServerDateTime:(NSDate *)serverTime
{
    BagItem *bagItem = nil;
    
    
    bagItem = [self extractBagItemfromJSONDictionary:bagItemDictionary withServerTime:serverTime forBagItem:bagItem];
    
    if ([bagItemDictionary valueForKeyPath:@"sku"]  && [bagItemDictionary valueForKeyPath:@"variant"])
        bagItem.bagItemId = [NSString stringWithFormat:@"%@%@", [bagItemDictionary valueForKeyPath:@"sku"], [bagItemDictionary valueForKeyPath:@"variant"]];
    
    
    return bagItem;
}



+ (NSMutableArray *)loadBagItemsfromAppServerArray:(NSArray *)bagItems withServerDateTime:(NSDate *)serverTime// of AppServer BagItem NSDictionary
{
    
    NSMutableArray *bagItemArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *bagItem in bagItems) {
        
        NSObject *someObject = [self bagItemWithAppServerInfo:bagItem withServerDateTime:serverTime];
        if (someObject)
            [bagItemArray addObject:someObject];
        
    }
    
    return bagItemArray;
}




+ (BagItem *)extractBagItemfromJSONDictionary:(NSDictionary *)bagItemDictionary withServerTime:(NSDate *)serverTime forBagItem:(BagItem *)bagItem {
    
    
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
    


    
    
    return bagItem;
}




@end





























