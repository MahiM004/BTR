//
//  Freeship+AppServer.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-01.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Freeship.h"

@interface Freeship (AppServer)

+ (Freeship *)extractFreeshipInfofromJSONDictionary:(NSDictionary *)dictionary forFreeship:(Freeship *)freeship;

@end
