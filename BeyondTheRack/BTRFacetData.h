//
//  BTRFacetData.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-19.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRFacetData : NSObject

+ (BTRFacetData *)sharedFacetData;

@property (strong, nonatomic) NSString *selectedSortString;

@property (strong, nonatomic) NSMutableArray *priceFacetArray;
@property (strong, nonatomic) NSMutableArray *priceFacetCountArray;
@property (strong, nonatomic) NSString *selectedPriceString;


@property (strong, nonatomic) NSMutableArray *categoryFacetArray;
@property (strong, nonatomic) NSMutableArray *categoryFacetCountArray;
@property (strong, nonatomic) NSString *selectedCategoryString;


@property (strong, nonatomic) NSMutableArray *brandFacetArray;
@property (strong, nonatomic) NSMutableArray *brandFacetCountArray;
@property (strong, nonatomic) NSMutableArray *selectedBrandsArray;


@property (strong, nonatomic) NSMutableArray *colorFacetArray;
@property (strong, nonatomic) NSMutableArray *colorFacetCountArray;
@property (strong, nonatomic) NSMutableArray *selectedColorsArray;


@property (strong, nonatomic) NSMutableArray *sizeFacetArray;
@property (strong, nonatomic) NSMutableArray *sizeFacetCountArray;
@property (strong, nonatomic) NSMutableArray *selectedSizesArray;

@end
