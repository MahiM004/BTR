//
//  BTRContactFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRContactFetcher.h"

@implementation BTRContactFetcher

+ (NSURL *)URLForContact
{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/content/contact?lang=en_US&render=txt", BASEURL]];
}

@end
