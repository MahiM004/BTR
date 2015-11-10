//
//  BTRFreeshipFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-01.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFreeshipFetcher.h"

@implementation BTRFreeshipFetcher

+ (NSURL *)URLforFreeship{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/freeship?html=false", BASEURL]];
}

+ (NSURL *)URLforImage:(NSString *)imageURL withBaseURL:(NSString *)baseURL{
    return [self URLForQuery:[NSString stringWithFormat:@"http:%@%@", [baseURL stringByReplacingOccurrencesOfString:@"\\" withString:@""],[imageURL stringByReplacingOccurrencesOfString:@"\\" withString:@""]]];
}

@end
