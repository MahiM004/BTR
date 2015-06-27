//
//  Item+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Item.h"

@interface Item (AppServer)

/*
 
 *** IMPORTAMT NOTE:
 
 The "keys" and "json format" in the JSON response coming from search-api and product-api are drastically different. For this we parse json response using different methods depending which api we get it from. The result of both are stored in the same db table.
 
 
 */

+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary
                    withEventId:(NSString *)eventId;

+ (NSMutableArray *)loadItemsfromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                    withEventId:(NSString *)eventId
                                 forItemsArray:(NSMutableArray *)itemsArray;

+ (NSMutableArray *)loadItemsfromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                  forItemsArray:(NSMutableArray *)itemsArray;

+ (Item *)itemWithSearchResponseInfo:(NSDictionary *)itemDictionary;

+ (NSMutableArray *)loadItemsfromAppSearchServerArray:(NSArray *)items forItemsArray:(NSMutableArray *)itemsArray; // of AppServer Item NSDictionary




@end


