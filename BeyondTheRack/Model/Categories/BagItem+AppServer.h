//
//  BagItem+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BagItem.h"

@interface BagItem (AppServer)

+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadBagItemsFromAppServerArray:(NSArray *)bagItems // of AppServer BagItem NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context;

//+ (NSMutableArray *)extractBagItemsfromAppServerArray:(NSArray *)bagItemsJson;

@end
