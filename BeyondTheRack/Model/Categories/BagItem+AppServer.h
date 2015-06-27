//
//  BagItem+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BagItem.h"

@interface BagItem (AppServer)


+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary withServerDateTime:(NSDate *)serverTime;

+ (NSMutableArray *)loadBagItemsfromAppServerArray:(NSArray *)bagItems withServerDateTime:(NSDate *)serverTime forBagItemsArray:(NSMutableArray *)bagItemsArray;// of AppServer BagItem NSDictionary


@end
