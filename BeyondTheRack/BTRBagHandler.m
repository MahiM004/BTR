//
//  BTRBagHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-31.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRBagHandler.h"


@interface BTRBagHandler ()

@property (strong, nonatomic) NSMutableArray *bagArray;

@end;



@implementation BTRBagHandler


static BTRBagHandler *_sharedInstance;

+ (BTRBagHandler *)sharedShoppingBag {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.bagCount = 0;
    }
    return self;
}

- (NSMutableArray *)bagArray {
    if (!_bagArray) _bagArray = [[NSMutableArray alloc] init];
    return _bagArray;
}

- (void)addBagItem:(BagItem *)bagItem {
    if ([self bagContainsBagItem:bagItem]) {
        [self incrementQuantityForBagItem:bagItem];
    } else {
        [[self bagArray] addObject:bagItem];
    }
}

- (void)removeBagItem:(BagItem *)bagItem {
    if ([self bagContainsBagItem:bagItem]) {
        [[self bagArray]  removeObject:bagItem];
    }
}

- (BOOL)bagContainsBagItem:(BagItem *)bagItem {
    return [[self bagArray] containsObject:bagItem];
}

- (NSUInteger)totalBagCount {
    NSUInteger answer = 0;
    for (BagItem *bagItem in [self bagArray]) {
        NSUInteger tempInt = 1;
        tempInt *= [[bagItem quantity] integerValue];
        answer += tempInt;
    }
    return answer;
}

- (NSString *)totalBagCountString {
    NSString *stringAnswer = [NSString stringWithFormat:@"%lu", (unsigned long)[self totalBagCount]];
    return stringAnswer;
}

- (NSUInteger)setBagItems:(NSArray *)bagItemsArray {
    [self.bagArray removeAllObjects];
    [[self bagArray] addObjectsFromArray:bagItemsArray];
    [self setBagCount:self.totalBagCount];
    return [self totalBagCount];
}

- (NSUInteger)incrementQuantityForBagItem:(BagItem *)bagItem {
    if ([self bagContainsBagItem:bagItem]) {
        NSUInteger index = [[self bagArray] indexOfObject:bagItem];
        NSString  *quantString =  [NSString stringWithFormat:@"%d",[[[self.bagArray objectAtIndex:index]  quantity]  intValue] + 1];
        [[self.bagArray objectAtIndex:index] setQuantity:quantString];
        return [[[self.bagArray objectAtIndex:index]  quantity]  integerValue];
    }
    return -1;
}

- (NSUInteger)decrementQuantityForBagItem:(BagItem *)bagItem {
    if ([self bagContainsBagItem:bagItem]) {
        NSUInteger index = [[self bagArray] indexOfObject:bagItem];
        NSString  *quantString =  [NSString stringWithFormat:@"%d",[[[self.bagArray objectAtIndex:index]  quantity]  intValue] - 1];
        [[self.bagArray objectAtIndex:index] setQuantity:quantString];
        return [[[self.bagArray objectAtIndex:index]  quantity]  integerValue];
    }
    return -1;
}

@end
























