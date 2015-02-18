//
//  BTRFacetsHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

/*
 
 NOTE:

 Only one layer of Facets are considered on the iOS App
 
 */


#import <Foundation/Foundation.h>

@interface BTRFacetsHandler : NSObject


+ (BOOL)hasChosenFacetInFacetsArray:(NSMutableArray *)chosenFacetsArray;


/*
 
 From Response
 
 */

+ (NSString *)getSortTypeForIndex:(NSInteger)sortIndex;
+ (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary;
+ (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary;
+ (NSMutableArray *)extractFilterFacetsForDisplayFromResponse:(NSDictionary *)facetsDictionary;



/*
 
    For REST
 
 */

+ (NSString *)priceRangeForAPIReadableFromLabelString:(NSString *)labelString;

+ (NSString *)getFacetStringForRESTWithChosenFacetsArray:(NSMutableArray *)chosenFacetsArray withSortOption:(NSUInteger) sortOption;

+ (NSMutableArray *)getFacetOptionsFromDisplaySelectedPrices:(NSMutableArray *)selectedPrices
                                      fromSelectedCategories:(NSMutableArray *)selectedCategories
                                           fromSelectedBrand:(NSMutableArray *)selectedBrands
                                          fromSelectedColors:(NSMutableArray *)selectedColors
                                           fromSelectedSizes:(NSMutableArray *)selectedSizes;

@end

























