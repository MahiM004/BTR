//
//  BTRSizeHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, BTRSizeMode) {
    
    BTRSizeModeSoldOut, // == 0 (by default)
    BTRSizeModeSingleSizeShow, // == 1 (incremented by 1 from previous)
    BTRSizeModeSingleSizeNoShow, // == 2
    BTRSizeModeNoInfo,
    BTRSizeModeMultipleSizes
};


@interface BTRSizeHandler : NSObject


+ (BTRSizeMode) extractSizesfromVarianInventoryDictionary: (NSArray *)variantInventory
                                                  toSizesArray:(NSMutableArray *)sizesArray
                                              toSizeCodesArray:(NSMutableArray *)sizeCodesArray
                                           toSizeQuantityArray:(NSMutableArray *)sizesQuantityArray;

@end
