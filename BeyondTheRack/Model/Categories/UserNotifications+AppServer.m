//
//  UserNotifications+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "UserNotifications+AppServer.h"

@implementation UserNotifications (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    UserNotifications *userNotifications = nil;
    
    userNotifications = [NSEntityDescription insertNewObjectForEntityForName:@"UserNotifications"
                                                    inManagedObjectContext:context];
    
    userNotifications.usernameId = @"dummy";
}


+ (UserNotifications *)userNotificationsWithAppServerInfo:(NSDictionary *)userNotificationsDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    UserNotifications *userNotifications = nil;
    NSString *unique = userNotificationsDictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserNotifications"];
    request.predicate = [NSPredicate predicateWithFormat:@"userNotificationsId = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        userNotifications = [matches firstObject];
        
        if ([userNotificationsDictionary valueForKeyPath:@"id"])
            userNotifications.userNotificationsId = [userNotificationsDictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        userNotifications = [NSEntityDescription insertNewObjectForEntityForName:@"UserNotifications"
                                                        inManagedObjectContext:context];
        
        if ([[userNotificationsDictionary valueForKeyPath:@"id"] stringValue])
            userNotifications.userNotificationsId = [[userNotificationsDictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return userNotifications;
}




@end
