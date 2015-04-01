//
//  Item+PriceHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-01.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Item+PriceHandler.h"

@implementation Item (PriceHandler)

+ (NSNumber *)unitPriceOfItem:(Item *)item forUser:(User *)user {
    
    if ([[user isEmployee] boolValue])
        return [item employeePrice];
    
    return [item salePrice];
}



@end
