//
//  BTRBagHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-31.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BagItem.h"


@interface BTRBagHandler : NSObject

+ (BTRBagHandler *)sharedShoppingBag;

- (NSUInteger)setBagItems:(NSArray *)bagItemsArray;

- (void)addBagItem:(BagItem *)bagItem;
- (void)removeBagItem:(BagItem *)bagItem;
- (BOOL)bagContainsBagItem:(BagItem *)bagItem;

- (NSUInteger)totalBagCount;
- (NSString *)totalBagCountString;

@property (nonatomic) NSUInteger bagCount;

/*
 
 if bagItem is not present returns -1;
 
 if increment or decrement is successful returns the current quantity of the bagItem
 
 */

- (NSUInteger)incrementQuantityForBagItem:(BagItem *)bagItem;
- (NSUInteger)decrementQuantityForBagItem:(BagItem *)bagItem;


@end
