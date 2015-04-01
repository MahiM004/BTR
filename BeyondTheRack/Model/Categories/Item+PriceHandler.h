//
//  Item+PriceHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-01.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Item.h"
#import "User.h"

@interface Item (PriceHandler)


+ (NSNumber *)unitPriceOfItem:(Item *)item forUser:(User *)user;


@end
