//
//  BTRMasterPass.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRMasterPass.h"

@implementation BTRMasterPass

+ (NSURL *)URLforStartMasterPass {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/masterpass", BASEURL]];
}

+ (NSURL *)URLforMasterPassInfo {
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/info/masterpass", BASEURL]];
}

+ (NSURL *)URLforMasterPassProcess{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/checkout/process/masterpass", BASEURL]];
}

@end
