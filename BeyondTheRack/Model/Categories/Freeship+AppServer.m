//
//  Freeship+AppServer.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-01.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Freeship+AppServer.h"

@implementation Freeship (AppServer)

+ (Freeship *)extractFreeshipInfofromJSONDictionary:(NSDictionary *)dictionary forFreeship:(Freeship *)freeship {
    
    if ([dictionary valueForKeyPath:@"checkout"] && [dictionary valueForKeyPath:@"checkout"] != [NSNull null])
        freeship.checkout = [dictionary valueForKey:@"checkout"];
    
    if ([dictionary valueForKeyPath:@"endTimestamp"] && [dictionary valueForKeyPath:@"endTimestamp"] != [NSNull null])
        freeship.endTimestamp = [dictionary valueForKey:@"endTimestamp"];
    
    if ([dictionary valueForKeyPath:@"confirmation"] && [dictionary valueForKeyPath:@"confirmation"] != [NSNull null])
        freeship.confirmation = [dictionary valueForKey:@"confirmation"];
    
    if ([dictionary valueForKeyPath:@"banner"] && [dictionary valueForKeyPath:@"banner"] != [NSNull null])
        freeship.banner = [dictionary valueForKey:@"banner"];
    
    return freeship;
}

@end
