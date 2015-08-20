//
//  MasterPassInfo+Appserver.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterPassInfo.h"

@interface MasterPassInfo (AppServer)

+ (MasterPassInfo *)masterPassInfoWithAppServerInfo:(NSDictionary *)dictionary;

@end
