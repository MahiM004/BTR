//
//  OrderHistoryBag+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "OrderHistoryBag.h"

@interface OrderHistoryBag (AppServer)


+ (OrderHistoryBag *)orderWithAppServerInfo:(NSDictionary *)orderDictionary;

+ (NSMutableArray *)loadOrderHistoryBagsfromAppServerArray:(NSArray *)orderHistoryBags withServerDateTime:(NSDate *)serverTime forOrderHistoryBagsArray:(NSMutableArray *)orderHistoryBagsArray;// of AppServer BagItem NSDictionary

+ (OrderHistoryBag *)extractOrderHistoryfromJSONDictionary:(NSDictionary *)jsonDictionary forOrderHistoryBag:(OrderHistoryBag *)orderHistoryBag;


@end
