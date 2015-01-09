//
//  UserNotifications+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "UserNotifications.h"

@interface UserNotifications (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (UserNotifications *)userNotificationsWithAppServerInfo:(NSDictionary *)userNotificationsDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;

@end
