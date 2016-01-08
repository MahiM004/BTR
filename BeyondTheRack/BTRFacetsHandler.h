//
//  BTRFacetsHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//
#define SORT_TITLE @"SORT ITEMS"
#define BRAND_TITLE @"BRAND"
#define COLOR_TITLE @"COLOR"
#define SIZE_TITLE @"SIZE"
#define CATEGORY_TITLE @"CATEGORY"
#define PRICE_TITLE @"PRICE"

#define BEST_MATCH @"Best Match"
#define HIGHEST_TO_LOWEST @"Highest to Lowest Price"
#define LOWEST_TO_HIGHEST @"Lowest to Highest Price"


#import <Foundation/Foundation.h>

@interface BTRFacetsHandler : NSObject


+ (BTRFacetsHandler *)sharedFacetHandler;


@property (strong, nonatomic) NSString *searchString;


- (NSArray *)getSortOptionStringsArray;
- (void)clearSortSelection;
- (void)setSortChosenOptionString:(NSString *)chosenSortString;
- (NSString *)getSelectedSortString;


- (void)setPriceSelectionWithPriceString:(NSString *)priceString;
- (NSString *)getSelectedPriceString;
- (BOOL)hasSelectedAnyPrice;
- (BOOL)hasSelectedPriceOptionString:(NSString *)optionString;
- (void)clearPriceSelection;
- (NSMutableArray *)getPriceFiltersForDisplay;


- (void)setCategorySelectionWithCategoryString:(NSString *)categoryString;
- (NSString *)getSelectedCategoryString;
- (BOOL)hasSelectedCategory;
- (BOOL)hasSelectedCategoryOptionString:(NSString *)optionString;
- (void)clearCategoryString;
- (NSMutableArray *)getCategoryFiltersForDisplay;


- (void)addBrandSelectionWithBrandString:(NSString *)brandString;
- (void)setSelectedBrandsWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedAnyBrand;
- (BOOL)hasSelectedBrandOptionString:(NSString *)optionString;
- (void)clearBrandSelection;
- (NSMutableArray *)getBrandFiltersForDisplay;
- (NSMutableArray *)getSelectedBrandsArray;


- (void)addColorSelectionWithColorString:(NSString *)colorString;
- (void)setSelectedColorsWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedAnyColor;
- (BOOL)hasSelectedColorOptionString:(NSString *)optionString;
- (void)clearColorSelection;
- (NSMutableArray *)getColorFiltersForDisplay;
- (NSMutableArray *)getSelectedColorsArray;


- (void)addSizeSelectionWithSizeString:(NSString *)sizeString;
- (void)setSelectedSizesWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedAnySize;
- (BOOL)hasSelectedSizeOptionString:(NSString *)optionString;
- (void)clearSizeSelection;
- (NSMutableArray *)getSizeFiltersForDisplay;
- (NSMutableArray *)getSelectedSizesArray;


- (NSString *)getFacetStringForRESTfulRequest;
- (NSString *)getSortStringForRESTfulRequest;
- (void)updateFacetsFromResponseDictionary:(NSDictionary *)responseDictionary;
- (void)setFacetsFromResponseDictionary:(NSDictionary *)responseDictionary;


- (BOOL)hasChosenAtLeastOneFacet;
- (BOOL)hasChosenFacetExceptCategories;


- (NSString *)getSelectionFromLabelString:(NSString *)labelString;
- (NSString *)getPriceSelectionFromLabelString:(NSString *)labelString;


- (void)resetFacets;
- (void)clearAllSelections;
- (void)clearAllFacets;




/*

 From Response
 
 */

- (NSString *)getSortTypeForIndex:(NSInteger)sortIndex;
- (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary;
- (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary;






@end

























