//
//  BTRChartFetcher.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-26.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"

@interface BTRChartFetcher : BTRFetcher

+ (NSURL *)URLforImagesOfChartsWithName:(NSString *)imageName;

@end
