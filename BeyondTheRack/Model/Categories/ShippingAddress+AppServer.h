//
//  ShippingAddress+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "ShippingAddress.h"

@interface ShippingAddress (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (ShippingAddress *)shippingAddressWithAppServerInfo:(NSDictionary *)shippingAddressDictionary
                             inManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)loadShippingAddressesFromAppServerArray:(NSArray *)shippingAddresses // of AppServer ShippingAddress NSDictionary
                                intoManagedObjectContext:(NSManagedObjectContext *)context;


@end
