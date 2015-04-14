//
//  BTRBagFetcher.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRBagFetcher.h"

@implementation BTRBagFetcher



+ (NSURL *)URLforBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag", BASEURL]];
}

+ (NSURL *)URLforSetBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag", BASEURL]];
}

+ (NSURL *)URLforAddtoBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/add", BASEURL]];
}


+ (NSURL *)URLforRemovefromBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/remove", BASEURL]];
}


+ (NSURL *)URLforClearBag {
    
    return [self URLForQuery:[NSString stringWithFormat:@"%@/bag/clear", BASEURL]];
}




@end








