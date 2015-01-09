//
//  Order+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Order.h"

@interface Order (AppServer)

+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (Order *)orderWithAppServerInfo:(NSDictionary *)orderDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadOrdersFromAppServerArray:(NSArray *)orders // of AppServer Order NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
