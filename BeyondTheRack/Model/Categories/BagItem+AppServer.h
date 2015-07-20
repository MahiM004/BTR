//
//  BagItem+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BagItem.h"

@interface BagItem (AppServer)

/**
 *
 *  This category is used to reading the JSON object into its corresponding model
 *
 */

+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary withServerDateTime:(NSDate *)serverTime isExpired:(NSString *)isExpired;

+ (NSMutableArray *)loadBagItemsfromAppServerArray:(NSArray *)bagItems withServerDateTime:(NSDate *)serverTime forBagItemsArray:(NSMutableArray *)bagItemsArray isExpired:(NSString *)isExpireed;// of AppServer BagItem NSDictionary


@end
