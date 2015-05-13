//
//  BTRSizeHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSizeHandler.h"

@implementation BTRSizeHandler


+ (enum btrSizeMode) extractSizesfromVarianInventoryDictionary: (NSDictionary *)variantInventoryDictionary
                                                  toSizesArray:(NSMutableArray *)sizesArray
                                             toSizeCodesArray:(NSMutableArray *)sizeCodesArray
                                           toSizeQuantityArray:(NSMutableArray *)sizesQuantityArray {
    
    NSString *keyString = @"";
    NSArray *allKeys = [variantInventoryDictionary allKeys];
    
    if ([allKeys count] == 0) {
        return btrSizeModeNoInfo;
    }
    
    if ([allKeys count] > 0) {
        
        keyString = [allKeys objectAtIndex:0];
        
        if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@"One Size"])
            return btrSizeModeSingleSizeShow;
        
        else if ([[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] &&
                 [allKeys count] == 1 )  /*  To deal with the follwoing faulty data entry: { "#Z" = 79; "L#L" = 4; "M#M" = 8; }; */
        /*  if #Z and anything else ignore #Z" */
            return btrSizeModeSingleSizeNoShow;
    }
    
    [variantInventoryDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *keyString = key;
        
        if ( ![[keyString componentsSeparatedByString:@"#"][0] isEqualToString:@""] ) {
            
            [sizesArray addObject:[keyString componentsSeparatedByString:@"#"][0]];
            [sizeCodesArray addObject:[keyString componentsSeparatedByString:@"#"][1]];
            [sizesQuantityArray addObject:variantInventoryDictionary[key]];
        }
    }];
    
    return btrSizeModeMultipleSizes;
}




@end
