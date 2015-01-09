//
//  General1+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "General1.h"

@interface General1 (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (General1 *)general1WithAppServerInfo:(NSDictionary *)general1Dictionary
                               inManagedObjectContext:(NSManagedObjectContext *)context;


@end
