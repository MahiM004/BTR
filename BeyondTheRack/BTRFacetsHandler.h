//
//  BTRFacetsHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface BTRFacetsHandler : NSObject


+ (BTRFacetsHandler *)sharedFacetHandler;


- (NSArray *)getSortOptionStringsArray;
- (void)clearSortSelection;
- (void)setSortChosenOptionString:(NSString *)chosenSortString;
- (NSString *)getSelectedSortString;



- (void)setPriceSelectionWithPriceString:(NSString *)priceString;
- (NSString *)getSelectedPriceString;
- (BOOL)hasSelectedPriceOptionString:(NSString *)optionString;
- (void)clearPriceSelection;
- (NSMutableArray *)getPriceFiltersForDisplay;


- (void)setCategorySelectionWithCategoryString:(NSString *)categoryString;
- (NSString *)getSelectedCategoryString;
- (BOOL)hasSelectedCategoryOptionString:(NSString *)optionString;
- (void)clearCategoryString;
- (NSMutableArray *)getCategoryFiltersForDisplay;


- (void)addBrandSelectionWithBrandString:(NSString *)brandString;
- (void)setSelectedBrandsWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedBrandOptionString:(NSString *)optionString;
- (void)clearBrandSelection;
- (NSMutableArray *)getBrandFiltersForDisplay;


- (void)addColorSelectionWithColorString:(NSString *)colorString;
- (void)setSelectedColorsWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedColorOptionString:(NSString *)optionString;
- (void)clearColorSelection;
- (NSMutableArray *)getColorFiltersForDisplay;


- (void)addSizeSelectionWithSizeString:(NSString *)sizeString;
- (void)setSelectedSizesWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedSizeOptionString:(NSString *)optionString;
- (void)clearSizeSelection;
- (NSMutableArray *)getSizeFiltersForDisplay;


- (NSString *)getFacetStringForRESTfulRequest;
- (void)updateFacetsFromResponseDictionary:(NSDictionary *)responseDictionary;


/*
 
 */

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

























