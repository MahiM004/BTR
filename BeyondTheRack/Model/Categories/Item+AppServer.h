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


+ (Item *)itemWithAppServerInfo:(NSDictionary *)itemDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadItemsFromAppServerArray:(NSArray *)items // of AppServer Item NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
