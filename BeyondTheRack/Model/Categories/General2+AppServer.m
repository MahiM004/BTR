//
//  General2+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "General2+AppServer.h"

@implementation General2 (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    General2 *general2 = nil;
    
    general2 = [NSEntityDescription insertNewObjectForEntityForName:@"General2"
                                             inManagedObjectContext:context];
    
    general2.attribute = @"dummy";
}


+ (General2 *)general2WithAppServerInfo:(NSDictionary *)general2Dictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    General2 *general2 = nil;
    NSString *unique = general2Dictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"General2"];
    request.predicate = [NSPredicate predicateWithFormat:@"attribute == %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        general2 = [matches firstObject];
        
        if ([general2Dictionary valueForKeyPath:@"id"])
            general2.attribute = [general2Dictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        general2 = [NSEntityDescription insertNewObjectForEntityForName:@"General2"
                                                 inManagedObjectContext:context];
        
        if ([[general2Dictionary valueForKeyPath:@"id"] stringValue])
            general2.attribute = [[general2Dictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return general2;
}


@end
