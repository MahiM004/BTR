//
//  BTRSizeHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>


enum btrSizeMode
{
    btrSizeModeSoldOut, // == 0 (by default)
    btrSizeModeSingleSizeShow, // == 1 (incremented by 1 from previous)
    btrSizeModeSingleSizeNoShow, // == 2
    btrSizeModeNoInfo,
    btrSizeModeMultipleSizes
};


@interface BTRSizeHandler : NSObject


+ (enum btrSizeMode) extractSizesfromVarianInventoryDictionary: (NSDictionary *)variantInventoryDictionary
                                                  toSizesArray:(NSMutableArray *)sizesArray
                                              toSizeCodesArray:(NSMutableArray *)sizeCodesArray
                                           toSizeQuantityArray:(NSMutableArray *)sizesQuantityArray;
@end
