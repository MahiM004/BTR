//
//  BTRPaymentTypesHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRPaymentTypesHandler.h"

@implementation BTRPaymentTypesHandler

static BTRPaymentTypesHandler *_sharedInstance;

+ (BTRPaymentTypesHandler *)sharedPaymentTypes
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


- (NSMutableArray *)paymentTypesArray {
    
    if (!_paymentTypesArray) _paymentTypesArray = [[NSMutableArray alloc] init];
    return _paymentTypesArray;
}

- (NSMutableArray *)creditCardTypeArray {
    
    if (!_creditCardTypeArray) _creditCardTypeArray = [[NSMutableArray alloc] init];
    return _creditCardTypeArray;
}

- (NSMutableArray *)creditCardDisplayNameArray {
    
    if (!_creditCardDisplayNameArray) _creditCardDisplayNameArray = [[NSMutableArray alloc] init];
    return _creditCardDisplayNameArray;
}



- (void)clearData {
    
    [[self paymentTypesArray] removeAllObjects];
    [[self creditCardTypeArray] removeAllObjects];
    [[self creditCardDisplayNameArray] removeAllObjects];
}


@end




















