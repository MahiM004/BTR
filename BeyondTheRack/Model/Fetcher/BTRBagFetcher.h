//
//  BTRBagFetcher.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-23.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFetcher.h"
#import "BagItem.h"
#import "Item.h"

@interface BTRBagFetcher : BTRFetcher


+ (NSURL *)URLforBag;
+ (NSURL *)URLforBagCount;
+ (NSURL *)URLforAddtoBag;
+ (NSURL *)URLforRemovefromBag;
+ (NSURL *)URLforSetBag;
+ (NSURL *)URLforClearBag;
+ (NSURL *)URLforRereserveBag;

@end
