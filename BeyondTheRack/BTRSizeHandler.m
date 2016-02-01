//
//  BTRSizeHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSizeHandler.h"

@implementation BTRSizeHandler


+ (BTRSizeMode) extractSizesfromVarianInventoryDictionary: (NSDictionary *)variantInventoryDictionary
                                                  toSizesArray:(NSMutableArray *)sizesArray
                                             toSizeCodesArray:(NSMutableArray *)sizeCodesArray
                                           toSizeQuantityArray:(NSMutableArray *)sizesQuantityArray {
    
    [sizesArray removeAllObjects];
    [sizeCodesArray removeAllObjects];
    [sizesQuantityArray removeAllObjects];
    
    NSDictionary *reference = @{
                                @"XXXS#XXXS":  @0,
                                @"XXS#XXS":   @1,
                                @"XS#XS":   @2,
                                @"S#S":   @3,
                                @"M#M":  @4,
                                @"L#L": @5,
                                @"XL#XL" : @6,
                                @"XXL#XXL" : @7,
                                @"3XL#3XL" : @8
                                };
    
    if (![variantInventoryDictionary isKindOfClass:[NSDictionary class]])
        return BTRSizeModeNoInfo;
    
    NSArray *sortedKeys = [[variantInventoryDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([(NSString *)obj1 intValue] == 0 && [(NSString *)obj2 intValue]) {
            return [reference[obj1] compare:reference[obj2]];
        }else {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    if ([sortedKeys count] == 0) {
        return BTRSizeModeNoInfo;
    }
    
    NSString *keyString = @"";

    if ([sortedKeys count] > 0) {
        keyString = [sortedKeys objectAtIndex:0];
        if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@"One Size"]) {
            [sizesQuantityArray addObject:variantInventoryDictionary[keyString]];
            return BTRSizeModeSingleSizeShow;
        }
        
        else if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] &&
                 [sortedKeys count] == 1 )  /*  To deal with the follwoing faulty data entry: { "#Z" = 79; "L#L" = 4; "M#M" = 8; }; */
        /*  if #Z and anything else ignore #Z" */
            return BTRSizeModeSingleSizeNoShow;
    }
    
    [sortedKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *keyString = obj;
        if ( ![[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] ) {
            [sizesArray addObject:[keyString componentsSeparatedByString:@"#"][0]];
            [sizeCodesArray addObject:[keyString componentsSeparatedByString:@"#"][1]];
            [sizesQuantityArray addObject:variantInventoryDictionary[obj]];
        }
    }];
    
    return BTRSizeModeMultipleSizes;
}




@end
