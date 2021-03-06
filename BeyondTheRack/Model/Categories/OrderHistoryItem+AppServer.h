//
//  OrderHistoryItem+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "OrderHistoryItem.h"

@interface OrderHistoryItem (AppServer)

/**
 *
 *  This category is used to reading the JSON object into its corresponding model
 *
 */

+ (OrderHistoryItem *)orderItemWithAppServerInfo:(NSDictionary *)orderItemDictionary;

+ (NSMutableArray *)loadOrderHistoryItemsfromAppServerArray:(NSArray *)orderHistoryItems forOrderHistoryItemsArray:(NSMutableArray *)orderHistoryItemsArray;// of AppServer BagItem NSDictionary

+ (OrderHistoryItem *)extractOrderHistoryItemfromJSONDictionary:(NSDictionary *)jsonDictionary forOrderHistoryItem:(OrderHistoryItem *)orderHistoryItem;


@end
