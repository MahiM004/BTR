//
//  Item+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Item.h"

@interface Item (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


/*
 
 *** IMPORTAMT NOTE:
 
 The "keys" and "json format" in the JSON response coming from search-api and product-api are drastically different. For this we parse json response using different methods depending which api we get it from. The result of both are stored in the same db table.
 
 
 */

+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadItemsFromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context;



+ (Item *)itemWithSearchResponseInfo:(NSDictionary *)itemDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadItemsFromSearchResponseArray:(NSArray *)items // of AppServer Item NSDictionary
                       intoManagedObjectContext:(NSManagedObjectContext *)context;


@end


