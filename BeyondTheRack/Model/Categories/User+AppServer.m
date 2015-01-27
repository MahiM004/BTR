//
//  User+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "User+AppServer.h"

@implementation User (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                    inManagedObjectContext:context];
    
    user.usernameId = @"dummy";
}


+ (User *)userWithAppServerInfo:(NSDictionary *)userDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    NSString *unique = userDictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"usernameId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        user = [matches firstObject];
        
        if ([userDictionary valueForKeyPath:@"id"])
            user.usernameId = [userDictionary valueForKeyPath:@"id"];
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                        inManagedObjectContext:context];
        
        if ([[userDictionary valueForKeyPath:@"id"] stringValue])
            user.usernameId = [[userDictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return user;
}




@end
