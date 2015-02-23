//
//  BTRFacetsHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#define BRAND_TITLE @"Brand"
#define COLOR_TITLE @"Color"
#define SIZE_TITLE @"Size"
#define CATEGORY_TITLE @"Type"
#define PRICE_TITLE @"Price"

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
- (NSMutableArray *)getSelectedBrandsArray;


- (void)addColorSelectionWithColorString:(NSString *)colorString;
- (void)setSelectedColorsWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedColorOptionString:(NSString *)optionString;
- (void)clearColorSelection;
- (NSMutableArray *)getColorFiltersForDisplay;
- (NSMutableArray *)getSelectedColorsArray;


- (void)addSizeSelectionWithSizeString:(NSString *)sizeString;
- (void)setSelectedSizesWithArray:(NSMutableArray *)selectedArray;
- (BOOL)hasSelectedSizeOptionString:(NSString *)optionString;
- (void)clearSizeSelection;
- (NSMutableArray *)getSizeFiltersForDisplay;
- (NSMutableArray *)getSelectedSizesArray;


- (NSString *)getFacetStringForRESTfulRequest;
- (void)updateFacetsFromResponseDictionary:(NSDictionary *)responseDictionary;
- (void)setFacetsFromResponseDictionary:(NSDictionary *)responseDictionary;



- (NSString *)getSelectionFromLabelString:(NSString *)labelString;
- (NSString *)getPriceSelectionFromLabelString:(NSString *)labelString;



/*

 From Response
 
 */

- (NSString *)getSortTypeForIndex:(NSInteger)sortIndex;
- (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary;
- (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary;






@end

























