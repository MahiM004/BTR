//
//  BTRGAHelper.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-04.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRGAHelper : NSObject

+ (void)setupGA;
+ (void)logScreenWithName:(NSString *)name;
+ (void)logScreenWithName:(NSString *)name WithAdditionalDimensions:(NSArray *)dimensions;
+ (void)logEventWithCatrgory:(NSString *)category action:(NSString *)action label:(NSString *)label;

@end
