//
//  OrderHistoryItem+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "OrderHistoryItem+AppServer.h"

@implementation OrderHistoryItem (AppServer)


+ (OrderHistoryItem *)orderItemWithAppServerInfo:(NSDictionary *)orderItemDictionary {
    
    OrderHistoryItem *orderHistoryItem = [[OrderHistoryItem alloc] init];
    
    orderHistoryItem = [self extractOrderHistoryItemfromJSONDictionary:orderItemDictionary forOrderHistoryItem:orderHistoryItem];
    
    return orderHistoryItem;
}


+ (NSMutableArray *)loadOrderHistoryItemsfromAppServerArray:(NSArray *)orderHistoryItems withServerDateTime:(NSDate *)serverTime forOrderHistoryItemsArray:(NSMutableArray *)orderHistoryItemsArray// of AppServer BagItem NSDictionary
{
    for (NSDictionary *orderHistoryItem in orderHistoryItemsArray) {
        
        NSObject *someObject = [self orderItemWithAppServerInfo:orderHistoryItem];
        if (someObject)
            [orderHistoryItemsArray addObject:someObject];
    }
    
    return orderHistoryItemsArray;
}



+ (OrderHistoryItem *)extractOrderHistoryItemfromJSONDictionary:(NSDictionary *)jsonDictionary forOrderHistoryItem:(OrderHistoryItem *)orderHistoryItem {

    
    if ([jsonDictionary valueForKeyPath:@"id"] && [jsonDictionary valueForKeyPath:@"id"] != [NSNull null])
        orderHistoryItem.orderHistoryItemId = [jsonDictionary valueForKeyPath:@"id"];
    
    if ([jsonDictionary valueForKeyPath:@"sku"] && [jsonDictionary valueForKeyPath:@"sku"] != [NSNull null])
        orderHistoryItem.skuNumber = [jsonDictionary valueForKeyPath:@"sku"];
    
    if ([jsonDictionary valueForKeyPath:@"order_id"] && [jsonDictionary valueForKeyPath:@"order_id"] != [NSNull null])
        orderHistoryItem.orderId = [jsonDictionary valueForKeyPath:@"order_id"];
    
    if ([jsonDictionary valueForKeyPath:@"description"] && [jsonDictionary valueForKeyPath:@"description"] != [NSNull null])
        orderHistoryItem.shortDescription = [jsonDictionary valueForKeyPath:@"description"];

    if ([jsonDictionary valueForKeyPath:@"variant"] && [jsonDictionary valueForKeyPath:@"variant"] != [NSNull null])
        orderHistoryItem.size = [jsonDictionary valueForKeyPath:@"variant"];

    if ([jsonDictionary valueForKeyPath:@"value"] && [jsonDictionary valueForKeyPath:@"value"] != [NSNull null])
        orderHistoryItem.price = [jsonDictionary valueForKeyPath:@"value"];
    
    if ([jsonDictionary valueForKeyPath:@"status"] && [jsonDictionary valueForKeyPath:@"status"] != [NSNull null])
        orderHistoryItem.status = [jsonDictionary valueForKeyPath:@"status"];
    
    int needs_work;
    if ([jsonDictionary valueForKeyPath:@"status_note"] && [jsonDictionary valueForKeyPath:@"status_note"] != [NSNull null])
        orderHistoryItem.statusNote = [jsonDictionary valueForKeyPath:@"status_note"];

    return orderHistoryItem;
}



@end
