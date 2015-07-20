//
//  Order+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Order.h"

/**
 *
 *  This category is used to reading the JSON object into its corresponding model
 *
 */

@interface Order (AppServer)


+ (Order *)orderWithAppServerInfo:(NSDictionary *)orderDictionary;


@end
