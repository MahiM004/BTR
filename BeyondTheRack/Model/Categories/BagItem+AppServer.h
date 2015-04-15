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

+ (BagItem *)bagItemWithAppServerInfo:(NSDictionary *)bagItemDictionary withServerDateTime:(NSDate *)serverTime
               inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadBagItemsfromAppServerArray:(NSArray *)bagItems withServerDateTime:(NSDate *)serverTime// of AppServer BagItem NSDictionary
                          intoManagedObjectContext:(NSManagedObjectContext *)context;


+ (NSMutableArray *)loadBagItemsfromAppServerArray:(NSArray *)bagItems withServerDateTime:(NSDate *)serverTime;// of AppServer BagItem NSDictionary

@end
