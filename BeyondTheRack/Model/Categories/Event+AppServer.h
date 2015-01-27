//
//  Event+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Event.h"

@interface Event (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (Event *)eventWithAppServerInfo:(NSDictionary *)eventDictionary andCategoryName:(NSString *)myCategoryName
           inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadEventsFromAppServerArray:(NSArray *)events andCategoryName:(NSString *)myCategoryName// of AppServer Event NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
