//
//  General3+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "General3.h"

@interface General3 (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;

+ (General3 *)general3WithAppServerInfo:(NSDictionary *)general3Dictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context;

@end
