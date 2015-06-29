//
//  OrderHistoryBag+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "OrderHistoryBag+AppServer.h"

@implementation OrderHistoryBag (AppServer)


+ (OrderHistoryBag *)orderWithAppServerInfo:(NSDictionary *)orderDictionary
{
    OrderHistoryBag *orderHistoryBag = [[OrderHistoryBag alloc] init];
    
    orderHistoryBag = [self extractOrderHistoryfromJSONDictionary:orderDictionary forOrderHistoryBag:orderHistoryBag];
    
    return orderHistoryBag;
}


+ (NSMutableArray *)loadOrderHistoryBagsfromAppServerArray:(NSArray *)orderHistoryBags withServerDateTime:(NSDate *)serverTime forOrderHistoryBagsArray:(NSMutableArray *)orderHistoryBagsArray// of AppServer BagItem NSDictionary
{
    for (NSDictionary *orderHistoryBag in orderHistoryBagsArray) {
        
        NSObject *someObject = [self orderWithAppServerInfo:orderHistoryBag];
        if (someObject)
            [orderHistoryBagsArray addObject:someObject];
    }
    
    return orderHistoryBagsArray;
}



+ (OrderHistoryBag *)extractOrderHistoryfromJSONDictionary:(NSDictionary *)jsonDictionary forOrderHistoryBag:(OrderHistoryBag *)orderHistoryBag {
    
    return orderHistoryBag;
}



@end
