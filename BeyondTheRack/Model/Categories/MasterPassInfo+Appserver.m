//
//  MasterPassInfo+Appserver.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "MasterPassInfo+Appserver.h"

@implementation MasterPassInfo (AppServer)

+ (MasterPassInfo *)orderItemWithAppServerInfo:(NSDictionary *)masterPassDictionary {
    
    MasterPassInfo *masterPassInfo = [[MasterPassInfo alloc] init];
    
    masterPassInfo = [self extractMasterPassInfofromJSONDictionary:masterPassDictionary forMasterPass:masterPassInfo];
    
    return masterPassInfo;
}

+ (MasterPassInfo *)extractMasterPassInfofromJSONDictionary:(NSDictionary *)masterPassDictionary forMasterPass:(MasterPassInfo *)masterPassInfo {

    
    return masterPassInfo;
}
@end
