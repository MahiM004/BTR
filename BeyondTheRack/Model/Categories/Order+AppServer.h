//
//  Order+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Order.h"

@interface Order (AppServer)


+ (Order *)orderWithAppServerInfo:(NSDictionary *)orderDictionary;


@end
