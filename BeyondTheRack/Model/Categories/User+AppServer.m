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
    
    user.userId = @"dummy";
}


+ (User *)signUpUserWithAppServerInfo:(NSDictionary *)infoDictionary
                          andUserInfo:(NSDictionary *)userDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context {
    
    
    User *user = nil;
    NSString *unique = userDictionary[@"uid"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        user = [matches firstObject];
        
        user = [self extractUserFromJSONDictionary:infoDictionary forUser:user];
        user = [self extractUserAuthFromJSONDictionary:userDictionary forUser:user];
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:context];
        
        user = [self extractUserFromJSONDictionary:infoDictionary forUser:user];
        user = [self extractUserAuthFromJSONDictionary:userDictionary forUser:user];
        
    }
    
    return user;
}


+ (User *)userWithAppServerInfo:(NSDictionary *)userDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    NSString *unique = userDictionary[@"uid"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        user = [matches firstObject];
        
        user = [self extractUserFromJSONDictionary:userDictionary forUser:user];

    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                        inManagedObjectContext:context];
        
        user = [self extractUserFromJSONDictionary:userDictionary forUser:user];

    }
    
    return user;
}

+ (User *)extractUserFromJSONDictionary:(NSDictionary *)userDictionary forUser:(User *)user  {
 
    
    if ([userDictionary valueForKeyPath:@"uid"] && [userDictionary valueForKeyPath:@"uid"] != [NSNull null])
        user.userId = [userDictionary valueForKeyPath:@"uid"];

    if ([userDictionary valueForKeyPath:@"name"] && [userDictionary valueForKeyPath:@"name"] != [NSNull null])
        user.name = [userDictionary valueForKeyPath:@"name"];

    if ([userDictionary valueForKeyPath:@"last_name"] && [userDictionary valueForKeyPath:@"last_name"] != [NSNull null])
        user.lastName = [userDictionary valueForKeyPath:@"last_name"];
    
    if ([userDictionary valueForKeyPath:@"country"] && [userDictionary valueForKeyPath:@"country"] != [NSNull null])
        user.country = [userDictionary valueForKeyPath:@"country"];
    
    if ([userDictionary valueForKeyPath:@"gender"] && [userDictionary valueForKeyPath:@"gender"] != [NSNull null])
        user.gender = [userDictionary valueForKeyPath:@"gender"];
    
    if ([userDictionary valueForKeyPath:@"postal"] && [userDictionary valueForKeyPath:@"postal"] != [NSNull null])
        user.postalCode = [userDictionary valueForKeyPath:@"postal"];
    
    if ([userDictionary valueForKeyPath:@"password_hint"] && [userDictionary valueForKeyPath:@"password_hint"] != [NSNull null])
        user.passwordHint = [userDictionary valueForKeyPath:@"password_hint"];
    
    if ([userDictionary valueForKeyPath:@"personal_code"] && [userDictionary valueForKeyPath:@"personal_code"] != [NSNull null])
        user.personalCode = [userDictionary valueForKeyPath:@"personal_code"];
    
    if ([userDictionary valueForKeyPath:@"invitation_code"] && [userDictionary valueForKeyPath:@"invitation_code"] != [NSNull null])
        user.invitationCode = [userDictionary valueForKeyPath:@"invitation_code"];
    
    if ([userDictionary valueForKeyPath:@"reference"] && [userDictionary valueForKeyPath:@"reference"] != [NSNull null])
        user.reference = [userDictionary valueForKeyPath:@"reference"];

    if ([userDictionary valueForKeyPath:@"cobrand_keyword"] && [userDictionary valueForKeyPath:@"cobrand_keyword"] != [NSNull null])
        user.cobrandKeyword = [userDictionary valueForKeyPath:@"cobrand_keyword"];
    
    if ([userDictionary valueForKeyPath:@"preferences_list"] && [userDictionary valueForKeyPath:@"preferences_list"] != [NSNull null])
        user.preferencesList = [userDictionary valueForKeyPath:@"preferences_list"];
    
    if ([userDictionary valueForKeyPath:@"class_list"] && [userDictionary valueForKeyPath:@"class_list"] != [NSNull null])
        user.classList = [userDictionary valueForKeyPath:@"class_list"];
    
    if ([userDictionary valueForKeyPath:@"notes"] && [userDictionary valueForKeyPath:@"notes"] != [NSNull null])
        user.notes = [userDictionary valueForKeyPath:@"notes"];
    
    if ([userDictionary valueForKeyPath:@"queuestatus"] && [userDictionary valueForKeyPath:@"queuestatus"] != [NSNull null])
        user.queueStatus = [userDictionary valueForKeyPath:@"queuestatus"];
    
    if ([userDictionary valueForKeyPath:@"update_ns"] && [userDictionary valueForKeyPath:@"update_ns"] != [NSNull null])
        user.updateNs = [userDictionary valueForKeyPath:@"update_ns"];
    
    if ([userDictionary valueForKeyPath:@"nsid"] && [userDictionary valueForKeyPath:@"nsid"] != [NSNull null])
        user.nsId = [userDictionary valueForKeyPath:@"nsid"];
    
    if ([userDictionary valueForKeyPath:@"address1"] && [userDictionary valueForKeyPath:@"address1"] != [NSNull null])
        user.addressLine1 = [userDictionary valueForKeyPath:@"address1"];
    
    if ([userDictionary valueForKeyPath:@"address2"] && [userDictionary valueForKeyPath:@"address2"] != [NSNull null])
        user.addressLine2 = [userDictionary valueForKeyPath:@"address2"];
    
    if ([userDictionary valueForKeyPath:@"city"] && [userDictionary valueForKeyPath:@"city"] != [NSNull null])
        user.city = [userDictionary valueForKeyPath:@"city"];
    
    if ([userDictionary valueForKeyPath:@"region"] && [userDictionary valueForKeyPath:@"region"] != [NSNull null])
        user.region = [userDictionary valueForKeyPath:@"region"];
    
    if ([userDictionary valueForKeyPath:@"birthdate"] && [userDictionary valueForKeyPath:@"birthdate"] != [NSNull null])
        user.birthDate = [userDictionary valueForKeyPath:@"birthdate"];
  
    if ([userDictionary valueForKeyPath:@"employee"] && [userDictionary valueForKeyPath:@"employee"] != [NSNull null])
        user.isEmployee = [userDictionary valueForKeyPath:@"employee"];

    
    return user;
}






+ (User *)userAuthWithAppServerInfo:(NSDictionary *)userDictionary
             inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    NSString *unique = userDictionary[@"uid"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        user = [matches firstObject];
        
        user = [self extractUserAuthFromJSONDictionary:userDictionary forUser:user];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                             inManagedObjectContext:context];
        
        user = [self extractUserAuthFromJSONDictionary:userDictionary forUser:user];
        
    }
    
    return user;
}




+ (User *)extractUserAuthFromJSONDictionary:(NSDictionary *)userDictionary forUser:(User *)user  {
    
    
    if ([userDictionary valueForKeyPath:@"uid"] && [userDictionary valueForKeyPath:@"uid"] != [NSNull null])
        user.userId = [userDictionary valueForKeyPath:@"uid"];
    
    if ([userDictionary valueForKeyPath:@"email"] && [userDictionary valueForKeyPath:@"email"] != [NSNull null])
        user.email = [userDictionary valueForKeyPath:@"email"];
    
    if ([userDictionary valueForKeyPath:@"password"] && [userDictionary valueForKeyPath:@"password"] != [NSNull null])
        user.password = [userDictionary valueForKeyPath:@"password"];
    
    
    return user;
}




@end
