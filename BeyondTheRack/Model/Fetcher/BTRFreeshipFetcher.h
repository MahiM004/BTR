//
//  BTRFreeshipFetcher.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-01.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"

@interface BTRFreeshipFetcher : BTRFetcher

+ (NSURL *)URLforFreeship;
+ (NSURL *)URLforImage:(NSString *)imageURL withBaseURL:(NSString *)baseURL;

@end
