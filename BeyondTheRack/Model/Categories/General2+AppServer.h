//
//  General2+AppServer.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "General2.h"

@interface General2 (AppServer)


+ (void)initInManagedObjectContext:(NSManagedObjectContext *)context;


+ (General2 *)general2WithAppServerInfo:(NSDictionary *)general2Dictionary
                 inManagedObjectContext:(NSManagedObjectContext *)context;

@end
