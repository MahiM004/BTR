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
    
    return orderHistoryItem;
}



@end
