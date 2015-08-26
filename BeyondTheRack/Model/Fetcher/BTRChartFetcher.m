//
//  BTRChartFetcher.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-26.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRChartFetcher.h"

@implementation BTRChartFetcher

+ (NSURL *)URLforImagesOfChartsWithName:(NSString *)imageName{
    return [self URLForQuery:[NSString stringWithFormat:@"%@/images/mobileimages/%@", STATICURL,imageName]];
}

@end
