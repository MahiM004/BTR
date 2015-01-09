//
//  General3+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "General3+AppServer.h"

@implementation General3 (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    General3 *general3 = nil;
    
    general3 = [NSEntityDescription insertNewObjectForEntityForName:@"General3"
                                             inManagedObjectContext:context];
    
    general3.attribute = @"dummy";
}


+ (General3 *)general3WithAppServerInfo:(NSDictionary *)general3Dictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    General3 *general3 = nil;
    NSString *unique = general3Dictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"General3"];
    request.predicate = [NSPredicate predicateWithFormat:@"attribute = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        general3 = [matches firstObject];
        
        if ([general3Dictionary valueForKeyPath:@"id"])
            general3.attribute = [general3Dictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        general3 = [NSEntityDescription insertNewObjectForEntityForName:@"General3"
                                                 inManagedObjectContext:context];
        
        if ([[general3Dictionary valueForKeyPath:@"id"] stringValue])
            general3.attribute = [[general3Dictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return general3;
}



@end
