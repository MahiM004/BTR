//
//  Event+AppServer.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Event+AppServer.h"

@implementation Event (AppServer)



+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    ShippingAddress *shippingAddress = nil;
    
    shippingAddress = [NSEntityDescription insertNewObjectForEntityForName:@"ShippingAddress"
                                                    inManagedObjectContext:context];
    
    shippingAddress.city = @"dummy";
}


+ (ShippingAddress *)shippingAddressWithAppServerInfo:(NSDictionary *)shippingAddressDictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context
{
    ShippingAddress *shippingAddress = nil;
    NSString *unique = shippingAddressDictionary[@"id"];
    
    if(!unique)
        return nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ShippingAddress"];
    request.predicate = [NSPredicate predicateWithFormat:@"shippingAddressId = %@", unique];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // if there is one matching record, update the record
    // if there is a duplicate records, delete all duplicate record and replace with the fresh record from the server
    // if there are no matching records create one
    
    if (error) {
        
        return nil;
        
    } else if ([matches count] == 1) {
        
        shippingAddress = [matches firstObject];
        
        if ([ShippingAddress valueForKeyPath:@"id"])
            shippingAddress.shippingAddressId = [shippingAddressDictionary valueForKeyPath:@"id"];
        
        
    } else if ([matches count] == 0 || [matches count] > 1 ) {
        
        if([matches count] > 1) {
            
            for (NSManagedObject *someObject in matches) {
                [context deleteObject:someObject];
            }
        }
        
        shippingAddress = [NSEntityDescription insertNewObjectForEntityForName:@"ShippingAddress"
                                                        inManagedObjectContext:context];
        
        if ([[shippingAddressDictionary valueForKeyPath:@"id"] stringValue])
            shippingAddress.shippingAddressId = [[shippingAddressDictionary valueForKeyPath:@"id"] stringValue];
    }
    
    return shippingAddress;
}

+ (NSMutableArray *)loadShippingAddressesFromAppServerArray:(NSArray *)shippingAddresses // of AppServer ShippingAddress NSDictionary
                                   intoManagedObjectContext:(NSManagedObjectContext *)context
{
    
    NSMutableArray *addressArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *shippingAddress in shippingAddresses) {
        
        NSObject *someObject = [self shippingAddressWithAppServerInfo:shippingAddress inManagedObjectContext:context];
        if (someObject)
            [addressArray addObject:someObject];
        
    }
    
    return addressArray;
}


@end
