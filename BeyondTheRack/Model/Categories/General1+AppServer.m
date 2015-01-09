//
//  General1+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "General1+AppServer.h"

@implementation General1 (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    General1 *general1 = nil;
    
    general1 = [NSEntityDescription insertNewObjectForEntityForName:@"General1"
                                                    inManagedObjectContext:context];
    
    general1.attribute = @"dummy";
}


+ (General1 *)general1WithAppServerInfo:(NSDictionary *)general1Dictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    General1 *general1 = nil;
    NSString *unique = general1Dictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"General1"];
    request.predicate = [NSPredicate predicateWithFormat:@"attribute = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        general1 = [matches firstObject];
        
        if ([general1Dictionary valueForKeyPath:@"id"])
            general1.attribute = [general1Dictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        general1 = [NSEntityDescription insertNewObjectForEntityForName:@"General1"
                                                        inManagedObjectContext:context];
        
        if ([[general1Dictionary valueForKeyPath:@"id"] stringValue])
            general1.attribute = [[general1Dictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return general1;
}





@end
