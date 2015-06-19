//
//  BTRCardHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCardHandler.h"

@implementation BTRCardHandler

static BTRCardHandler *_sharedInstance;

+ (BTRCardHandler *)sharedCardData
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


- (NSMutableArray *)cardDisplayNameArray {
    
    if (!_cardDisplayNameArray) _cardDisplayNameArray = [[NSMutableArray alloc] init];
    return _cardDisplayNameArray;
}


- (NSMutableArray *)cardTypeArray {
    
    if (!_cardTypeArray) _cardTypeArray = [[NSMutableArray alloc] init];
    return _cardTypeArray;
}



@end
