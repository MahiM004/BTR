//
//  BTRSizeHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSizeHandler.h"

@implementation BTRSizeHandler


+ (BTRSizeMode) extractSizesfromVarianInventoryDictionary: (NSArray *)variantInventory
                                                  toSizesArray:(NSMutableArray *)sizesArray
                                             toSizeCodesArray:(NSMutableArray *)sizeCodesArray
                                           toSizeQuantityArray:(NSMutableArray *)sizesQuantityArray {
    
    [sizesArray removeAllObjects];
    [sizeCodesArray removeAllObjects];
    [sizesQuantityArray removeAllObjects];
    
    if (![variantInventory isKindOfClass:[NSArray class]])
        return BTRSizeModeNoInfo;
    
    if ([variantInventory count] == 0) {
        return BTRSizeModeNoInfo;
    }
    
    NSString *keyString = @"";

    if ([variantInventory count] > 0) {
        NSDictionary *dic = [variantInventory objectAtIndex:0];
        keyString = [[dic allKeys]objectAtIndex:0];
        if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@"One Size"]) {
            [sizesQuantityArray addObject:dic[keyString]];
            return BTRSizeModeSingleSizeShow;
        }
        
        else if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] &&
                 [variantInventory count] == 1 )  /*  To deal with the follwoing faulty data entry: { "#Z" = 79; "L#L" = 4; "M#M" = 8; }; */
        /*  if #Z and anything else ignore #Z" */
            return BTRSizeModeSingleSizeNoShow;
    }
    
    for (int i = 0 ; i < [variantInventory count]; i++) {
        NSDictionary *dic = [variantInventory objectAtIndex:i];
        NSString *keyString = [[dic allKeys]objectAtIndex:0];
        if ( ![[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] ) {
            [sizesArray addObject:[keyString componentsSeparatedByString:@"#"][0]];
            [sizeCodesArray addObject:[keyString componentsSeparatedByString:@"#"][1]];
            [sizesQuantityArray addObject:dic[keyString]];
        }

    }
    
    return BTRSizeModeMultipleSizes;
}




@end
