//
//  BTRUserFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRUserFetcher.h"

@implementation BTRUserFetcher


+ (NSURL *)URLforUserAuthentication {

    return [self URLForQuery:[NSString stringWithFormat:@"%@/user/authenticate", BASEURL]];
}



@end
