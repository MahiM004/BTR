//
//  BTRCategoryData.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCategoryData.h"

@implementation BTRCategoryData

static BTRCategoryData *_sharedInstance;

+ (BTRCategoryData *)sharedCategoryData
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


- (NSMutableArray *)categoryNameArray {
    
    if (!_categoryNameArray) _categoryNameArray = [[NSMutableArray alloc] init];
    return _categoryNameArray;
}


- (NSMutableArray *)categoryUrlArray {
    
    if (!_categoryUrlArray) _categoryUrlArray = [[NSMutableArray alloc] init];
    return _categoryUrlArray;
}


@end
