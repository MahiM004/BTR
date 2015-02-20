//
//  BTRFacetData.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFacetData.h"

@implementation BTRFacetData


static BTRFacetData *_sharedInstance;

+ (BTRFacetData *)sharedFacetData
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


- (NSMutableArray *)priceFacetArray {
    
    if (!_priceFacetArray) _priceFacetArray = [[NSMutableArray alloc] init];
    return _priceFacetArray;
}

- (NSMutableArray *)priceFacetCountArray {
    
    if (!_priceFacetCountArray) _priceFacetCountArray = [[NSMutableArray alloc] init];
    return _priceFacetCountArray;
}


- (NSMutableArray *)categoryFacetArray {
    
    if (!_categoryFacetArray) _categoryFacetArray = [[NSMutableArray alloc] init];
    return _categoryFacetArray;
}

- (NSMutableArray *)categoryFacetCountArray {
    
    if (!_categoryFacetCountArray) _categoryFacetCountArray = [[NSMutableArray alloc] init];
    return _categoryFacetCountArray;
}

- (NSMutableArray *)brandFacetArray {
    
    if (!_brandFacetArray) _brandFacetArray = [[NSMutableArray alloc] init];
    return _brandFacetArray;
}

- (NSMutableArray *)brandFacetCountArray {
    
    if (!_brandFacetCountArray) _brandFacetCountArray = [[NSMutableArray alloc] init];
    return _brandFacetCountArray;
}

- (NSMutableArray *)selectedBrandsArray {
    
    if (!_selectedBrandsArray) _selectedBrandsArray = [[NSMutableArray alloc] init];
    return _selectedBrandsArray;
}

- (NSMutableArray *)colorFacetArray {
    
    if (!_colorFacetArray) _colorFacetArray = [[NSMutableArray alloc] init];
    return _colorFacetArray;
}

- (NSMutableArray *)colorFacetCountArray {
    
    if (!_colorFacetCountArray) _colorFacetCountArray = [[NSMutableArray alloc] init];
    return _colorFacetCountArray;
}

- (NSMutableArray *)selectedColorsArray {
    
    if (!_selectedColorsArray) _selectedColorsArray = [[NSMutableArray alloc] init];
    return _selectedColorsArray;
}

- (NSMutableArray *)sizeFacetArray {
    
    if (!_sizeFacetArray) _sizeFacetArray = [[NSMutableArray alloc] init];
    return _sizeFacetArray;
}

- (NSMutableArray *)sizeFacetCountArray {
    
    if (!_sizeFacetCountArray) _sizeFacetCountArray = [[NSMutableArray alloc] init];
    return _sizeFacetCountArray;
}

- (NSMutableArray *)selectedSizesArray {
    
    if (!_selectedSizesArray) _selectedSizesArray = [[NSMutableArray alloc] init];
    return _selectedSizesArray;
}



@end
