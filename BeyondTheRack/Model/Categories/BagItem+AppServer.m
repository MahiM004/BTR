//
//  BagItem+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BagItem+AppServer.h"

@implementation BagItem (AppServer)



+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary withServerDateTime:(NSDate *)serverTime
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    BagItem *bagItem = [[BagItem alloc] init];
    
    if ([bagItemDictionary valueForKeyPath:@"sku"]  && [bagItemDictionary valueForKeyPath:@"variant"])
        bagItem.bagItemId = [NSString stringWithFormat:@"%@%@", [bagItemDictionary valueForKeyPath:@"sku"], [bagItemDictionary valueForKeyPath:@"variant"]];
    
    return bagItem;
}



+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary withServerDateTime:(NSDate *)serverTime
{
    BagItem *bagItem = [[BagItem alloc] init];
    
    bagItem = [self extractBagItemfromJSONDictionary:bagItemDictionary withServerTime:serverTime forBagItem:bagItem];
    
    if ([bagItemDictionary valueForKeyPath:@"sku"]  && [bagItemDictionary valueForKeyPath:@"variant"])
        bagItem.bagItemId = [NSString stringWithFormat:@"%@%@", [bagItemDictionary valueForKeyPath:@"sku"], [bagItemDictionary valueForKeyPath:@"variant"]];
    
    
    return bagItem;
}



+ (NSMutableArray *)loadBagItemsfromAppServerArray:(NSArray *)bagItems withServerDateTime:(NSDate *)serverTime forBagItemsArray:(NSMutableArray *)bagItemsArray// of AppServer BagItem NSDictionary
{
    
    for (NSDictionary *bagItem in bagItems) {
        
        NSObject *someObject = [self bagItemWithAppServerInfo:bagItem withServerDateTime:serverTime];
        if (someObject)
            [bagItemsArray addObject:someObject];
        
    }
    
    return bagItemsArray;
}




+ (BagItem *)extractBagItemfromJSONDictionary:(NSDictionary *)bagItemDictionary withServerTime:(NSDate *)serverTime forBagItem:(BagItem *)bagItem {
    
    
    bagItem.serverDateTime = serverTime;
    
    if ([bagItemDictionary valueForKeyPath:@"sku"] && [bagItemDictionary valueForKeyPath:@"sku"] != [NSNull null]) {
        bagItem.sku = [bagItemDictionary valueForKeyPath:@"sku"];
    }
    
    if ([bagItemDictionary valueForKeyPath:@"variant"] && [bagItemDictionary valueForKeyPath:@"variant"] != [NSNull null]) {
        bagItem.variant = [bagItemDictionary valueForKeyPath:@"variant"];
    }

    if ([bagItemDictionary valueForKeyPath:@"addtionalShipping"] && [bagItemDictionary valueForKeyPath:@"addtionalShipping"] != [NSNull null]) {
        bagItem.additionalShipping = [bagItemDictionary valueForKeyPath:@"addtionalShipping"];
    }
    
    if ([bagItemDictionary valueForKeyPath:@"employee"] && [bagItemDictionary valueForKeyPath:@"employee"] != [NSNull null]) {
        bagItem.isEmployee = [[bagItemDictionary valueForKeyPath:@"employee"] stringValue];
    }
    
    if ([bagItemDictionary valueForKeyPath:@"country"] && [bagItemDictionary valueForKeyPath:@"country"] != [NSNull null]) {
        bagItem.country = [bagItemDictionary valueForKeyPath:@"country"];
    }
    
    if ([bagItemDictionary valueForKeyPath:@"pricing"] && [bagItemDictionary valueForKeyPath:@"pricing"] != [NSNull null]) {
        bagItem.pricing = [bagItemDictionary valueForKeyPath:@"pricing"];
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





























