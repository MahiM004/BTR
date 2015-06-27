//
//  Event+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Event.h"

@interface Event (AppServer)

+ (Event *)eventWithAppServerInfo:(NSDictionary *)eventDictionary withCategoryName:(NSString *)myCategoryName;

+ (NSMutableArray *)loadEventsfromAppServerArray:(NSArray *)events withCategoryName:(NSString *)myCategoryName forEventsArray:(NSMutableArray *)eventsArray; // of AppServer Event NSDictionary


@end
