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
    
    
    if ([jsonDictionary valueForKeyPath:@"order_id"] && [jsonDictionary valueForKeyPath:@"order_id"] != [NSNull null])
        orderHistoryBag.orderId = [jsonDictionary valueForKeyPath:@"order_id"];

    if ([jsonDictionary valueForKeyPath:@"order_date"] && [jsonDictionary valueForKeyPath:@"order_date"] != [NSNull null])
        orderHistoryBag.orderDateString = [jsonDictionary valueForKeyPath:@"order_date"];

    if ([jsonDictionary valueForKeyPath:@"sub_total"] && [jsonDictionary valueForKeyPath:@"sub_total"] != [NSNull null]) {
        
        orderHistoryBag.subtotal = [[jsonDictionary valueForKeyPath:@"sub_total"] stringValue];
    }
    
    if ([jsonDictionary valueForKeyPath:@"total_taxes"] && [jsonDictionary valueForKeyPath:@"total_taxes"] != [NSNull null])
        orderHistoryBag.taxes = [[jsonDictionary valueForKeyPath:@"total_taxes"] stringValue];
    
    if ([jsonDictionary valueForKeyPath:@"total_shipping"] && [jsonDictionary valueForKeyPath:@"total_shipping"] != [NSNull null])
        orderHistoryBag.shipping = [jsonDictionary valueForKeyPath:@"total_shipping"];
    
    if ([jsonDictionary valueForKeyPath:@"total_credit_applied"] && [jsonDictionary valueForKeyPath:@"total_credit_applied"] != [NSNull null])
        orderHistoryBag.credits = [jsonDictionary valueForKeyPath:@"total_credit_applied"];
    
    if ([jsonDictionary valueForKeyPath:@"total_order_value"] && [jsonDictionary valueForKeyPath:@"total_order_value"] != [NSNull null])
        orderHistoryBag.total = [jsonDictionary valueForKeyPath:@"total_order_value"];
    
    return orderHistoryBag;
}



@end
