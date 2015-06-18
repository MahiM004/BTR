//
//  EventCategory+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//


#import "EventCategory.h"


@interface EventCategory (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;

+ (EventCategory *)eventWithAppServerInfo:(NSDictionary *)eventDictionary
                   inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadCategoriesFromAppServerArray:(NSArray *)eventCategories // of AppServer EventCategory NSDictionary
                            intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
