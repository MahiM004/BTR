//
//  BTRFacetsHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFacetsHandler.h"
#import "BTRFacetData.h"


@interface BTRFacetsHandler ()
@property (strong, nonatomic) NSMutableDictionary *originalResponseDictionary;
@end;

@implementation BTRFacetsHandler

static BTRFacetsHandler *_sharedInstance;

+ (BTRFacetsHandler *)sharedFacetHandler {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSMutableDictionary *)originalResponseDictionary {
    if (!_originalResponseDictionary) _originalResponseDictionary = [[NSMutableDictionary alloc] init];
    return _originalResponseDictionary;
}

- (BOOL)hasChosenAtLeastOneFacet {
    if ([self hasSelectedSortOption])
        return YES;
    if ([self hasSelectedCategory])
        return YES;
    return [self hasChosenFacetExceptCategories];
}

- (BOOL)hasSelectedSortOption {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([[sharedFacetData selectedSortString] isEqualToString:HIGHEST_TO_LOWEST] || [[sharedFacetData selectedSortString] isEqualToString:LOWEST_TO_HIGHEST])
        return YES;
    return NO;
}

- (BOOL)hasChosenFacetExceptCategories {
    if ([self hasSelectedAnyPrice])
        return YES;
    if ([self hasSelectedAnyBrand])
        return YES;
    if ([self hasSelectedAnyColor])
        return YES;
    if ([self hasSelectedAnySize])
        return YES;
    return NO;
}

- (NSArray *)getSortOptionStringsArray {
    NSArray *sortOptionsArray =  @[BEST_MATCH, HIGHEST_TO_LOWEST, LOWEST_TO_HIGHEST];
    return sortOptionsArray;
}

- (void)clearSortSelection {
    BTRFacetData * sharedFacetData = [BTRFacetData sharedFacetData];
    sharedFacetData.selectedSortString = @"";
}

- (void)setSortChosenOptionString:(NSString *)chosenSortString {
    BTRFacetData * sharedFacetData = [BTRFacetData sharedFacetData];
    sharedFacetData.selectedSortString = chosenSortString;
}

- (NSString *)getSelectedSortString {
    BTRFacetData * sharedFacetData = [BTRFacetData sharedFacetData];
    return [sharedFacetData selectedSortString];
}

- (void)setPriceSelectionWithPriceString:(NSString *)priceString {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    sharedFacetData.selectedPriceString = priceString;
    
}

- (NSString *)getSelectedPriceString {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    return sharedFacetData.selectedPriceString;
}

- (BOOL)hasSelectedAnyPrice {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData selectedPriceString] && [[sharedFacetData selectedPriceString] length] > 0)
        return YES;
    
    return NO;
}

- (BOOL)hasSelectedPriceOptionString:(NSString *)optionString {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData.selectedPriceString isEqualToString:optionString])
        return true;
        
    return false;
}

- (void)clearPriceSelection {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    sharedFacetData.selectedPriceString = nil;
}

- (NSMutableArray *)getPriceFiltersForDisplay {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    NSMutableArray * arrayStringForDisplay = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sharedFacetData.priceFacetArray count]; i++) {
        NSString *priceString = [NSString stringWithFormat:@"%@: (%@)",
                                 [sharedFacetData.priceFacetArray objectAtIndex:i],
                                 [sharedFacetData.priceFacetCountArray objectAtIndex:i]];
        
        [arrayStringForDisplay addObject:priceString];
    }
    return arrayStringForDisplay;
}

- (void)setCategorySelectionWithCategoryString:(NSString *)categoryString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    sharedFacetDictionary.selectedCategoryString = categoryString;
}

- (NSString *)getSelectedCategoryString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    return sharedFacetDictionary.selectedCategoryString;
}

- (BOOL)hasSelectedCategory {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData selectedCategoryString] && [[sharedFacetData selectedCategoryString] length] > 0)
        return YES;
    return NO;
}

- (BOOL)hasSelectedCategoryOptionString:(NSString *)optionString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ([sharedFacetDictionary.selectedCategoryString isEqualToString:optionString])
        return true;
    
    return false;
}

- (void)clearCategoryString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    sharedFacetDictionary.selectedCategoryString = nil;
}

- (NSMutableArray *)getCategoryFiltersForDisplay {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    NSMutableArray * arrayStringForDisplay = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sharedFacetDictionary.categoryFacetArray count]; i++) {
        NSString *priceString = [NSString stringWithFormat:@"%@: (%@)",
                                 [sharedFacetDictionary.categoryFacetArray objectAtIndex:i],
                                 [sharedFacetDictionary.categoryFacetCountArray objectAtIndex:i]];
        [arrayStringForDisplay addObject:priceString];
    }
    return arrayStringForDisplay;
}

- (void)addBrandSelectionWithBrandString:(NSString *)brandString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ( ![sharedFacetDictionary.selectedBrandsArray containsObject:brandString])
        [sharedFacetDictionary.selectedBrandsArray addObject:brandString];
}

- (void)setSelectedBrandsWithArray:(NSMutableArray *)selectedArray {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    [sharedFacetData.selectedBrandsArray removeAllObjects];
    [sharedFacetData.selectedBrandsArray addObjectsFromArray:selectedArray];
}

- (BOOL)hasSelectedAnyBrand {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData selectedBrandsArray] && [[sharedFacetData selectedBrandsArray] count] > 0)
        return YES;
    return NO;
}

- (BOOL)hasSelectedBrandOptionString:(NSString *)optionString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ([sharedFacetDictionary.selectedBrandsArray containsObject:optionString])
        return true;
    
    return false;
}

- (void)clearBrandSelection {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    [sharedFacetDictionary.selectedBrandsArray removeAllObjects];
}

- (NSMutableArray *)getBrandFiltersForDisplay {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    NSMutableArray * arrayStringForDisplay = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sharedFacetDictionary.brandFacetArray count]; i++) {
        NSString *priceString = [NSString stringWithFormat:@"%@: (%@)",
                                 [sharedFacetDictionary.brandFacetArray objectAtIndex:i],
                                 [sharedFacetDictionary.brandFacetCountArray objectAtIndex:i]];
        [arrayStringForDisplay addObject:priceString];
    }
    return arrayStringForDisplay;
}


- (NSMutableArray *)getSelectedBrandsArray {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    return [sharedFacetData selectedBrandsArray];
}

- (void)addColorSelectionWithColorString:(NSString *)colorString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ( ![sharedFacetDictionary.selectedColorsArray containsObject:colorString])
        [sharedFacetDictionary.selectedColorsArray addObject:colorString];
}

- (void)setSelectedColorsWithArray:(NSMutableArray *)selectedArray {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    [sharedFacetData.selectedColorsArray removeAllObjects];
    [sharedFacetData.selectedColorsArray addObjectsFromArray:selectedArray];
}


- (BOOL)hasSelectedAnyColor {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData selectedColorsArray] && [[sharedFacetData selectedColorsArray] count] > 0)
        return YES;
    return NO;
}

- (BOOL)hasSelectedColorOptionString:(NSString *)optionString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ([sharedFacetDictionary.selectedColorsArray containsObject:optionString])
        return true;
    return false;
}

- (void)clearColorSelection {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    [sharedFacetDictionary.selectedColorsArray removeAllObjects];
}

- (NSMutableArray *)getColorFiltersForDisplay {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    NSMutableArray * arrayStringForDisplay = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sharedFacetData.colorFacetArray count]; i++) {
        NSString *priceString = [NSString stringWithFormat:@"%@: (%@)",
                                 [sharedFacetData.colorFacetArray objectAtIndex:i],
                                 [sharedFacetData.colorFacetCountArray objectAtIndex:i]];
        [arrayStringForDisplay addObject:priceString];
    }
    return arrayStringForDisplay;
}

- (NSMutableArray *)getSelectedColorsArray {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    return [sharedFacetData selectedColorsArray];
}


- (void)addSizeSelectionWithSizeString:(NSString *)sizeString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ( ![sharedFacetDictionary.selectedSizesArray containsObject:sizeString])
        [sharedFacetDictionary.selectedSizesArray addObject:sizeString];
}

- (void)setSelectedSizesWithArray:(NSMutableArray *)selectedArray {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    [sharedFacetData.selectedSizesArray removeAllObjects];
    [sharedFacetData.selectedSizesArray addObjectsFromArray:selectedArray];
}

- (BOOL)hasSelectedAnySize {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData selectedSizesArray] && [[sharedFacetData selectedSizesArray] count] > 0)
        return YES;
    return NO;
}


- (BOOL)hasSelectedSizeOptionString:(NSString *)optionString {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ([sharedFacetDictionary.selectedSizesArray containsObject:optionString])
        return true;
    return false;
}

- (void)clearSizeSelection {
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    [sharedFacetDictionary.selectedBrandsArray removeAllObjects];
}

- (NSMutableArray *)getSizeFiltersForDisplay {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    NSMutableArray * arrayStringForDisplay = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sharedFacetData.sizeFacetArray count]; i++) {
        NSString *priceString = [NSString stringWithFormat:@"%@: (%@)",
                                 [sharedFacetData.sizeFacetArray objectAtIndex:i],
                                 [sharedFacetData.sizeFacetCountArray objectAtIndex:i]];
        
        [arrayStringForDisplay addObject:priceString];
    }
    return arrayStringForDisplay;
}

- (NSMutableArray *)getSelectedSizesArray {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    return [sharedFacetData selectedSizesArray];
}


- (NSString *)getSelectionFromLabelString:(NSString *)labelString {
    return [labelString componentsSeparatedByString:@":"][0];
}

- (NSString *)getPriceSelectionFromLabelString:(NSString *)labelString {
    if ([labelString containsString:@"$0 to $200"])
        return @"[0 TO 200]";
    else if ([labelString containsString:@"$200 to $400"])
        return @"[200 TO 400]";
    else if ([labelString containsString:@"$400 to $600"])
        return @"[400 TO 600]";
    else if ([labelString containsString:@"$600 to $800"])
        return @"[600 TO 800]";
    else if ([labelString containsString:@"$800 to $1000"])
        return @"[800 TO 1000]";
    else if ([labelString containsString:@"$1000 to *"])
        return @"[1000 TO *]";
    return nil;
}

- (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary {
    return ((NSDictionary *)responseDictionary[@"facet_counts"]);
}

- (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary {
    NSDictionary *tempDic = responseDictionary[@"response"];
    return [tempDic valueForKey:@"docs"];
}

- (NSString *)getSortTypeForIndex:(NSInteger)sortIndex {
    BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
    NSArray *sortStringArray = [sharedFacetsHandler getSortOptionStringsArray];
    if (sortIndex >=0 && sortIndex <= [sortStringArray count] - 1)
        return [sortStringArray objectAtIndex:sortIndex];
    return nil;
}

- (NSString *)getFacetStringForRESTfulRequest {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    NSMutableString *filtersString = [[NSMutableString alloc] init];
    
    if ([sharedFacetData selectedPriceString] && ![sharedFacetData.selectedPriceString isEqual:[NSNull null]])
        ((BOOL)[filtersString length])?
        [filtersString appendFormat:@";%@:%@", [sharedFacetData pricePrefix], [self getPriceSelectionFromLabelString:[sharedFacetData selectedPriceString]]]:
        [filtersString appendFormat:@"%@:%@", [sharedFacetData pricePrefix],[self getPriceSelectionFromLabelString:[sharedFacetData selectedPriceString]]];
    
    if ([sharedFacetData selectedCategoryString] && ![sharedFacetData .selectedCategoryString isEqual:[NSNull null]])
        ((BOOL)[filtersString length])?
        [filtersString appendFormat:@";{!tag=cat_1}cat_1:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData selectedCategoryString]]]:
        [filtersString appendFormat:@"{!tag=cat_1}cat_1:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData selectedCategoryString]]];
    
    if ([sharedFacetData.selectedBrandsArray count] != 0)
        ((BOOL)[filtersString length]) ?
        [filtersString appendFormat:@";{!tag=brand}brand:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedBrandsArray objectAtIndex:0]]]:
        [filtersString appendFormat:@"{!tag=brand}brand:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedBrandsArray objectAtIndex:0]]];
    
    if ([sharedFacetData.selectedBrandsArray count] > 1) {
        for (int i = 1; i < [sharedFacetData.selectedBrandsArray count]; i++)
            [filtersString appendFormat:@" OR brand:[[%@]]",[self getSelectionFromLabelString:[sharedFacetData.selectedBrandsArray objectAtIndex:i]]];
    }
    
    if ([sharedFacetData.selectedColorsArray count] != 0)
        ((BOOL)[filtersString length]) ?
        [filtersString appendFormat:@";{!tag=att_color}att_color:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedColorsArray objectAtIndex:0]]]:
        [filtersString appendFormat:@"{!tag=att_color}att_color:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedColorsArray objectAtIndex:0]]];
    
    if ([sharedFacetData.selectedColorsArray count] > 1) {
        for (int i = 1; i < [sharedFacetData.selectedColorsArray count]; i++)
            [filtersString appendFormat:@" OR att_color:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedColorsArray objectAtIndex:i]]];
    }
    
    if ([sharedFacetData.selectedSizesArray count] != 0)
        ((BOOL)[filtersString length])?
        [filtersString appendFormat:@";{!tag=variant}variant:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedSizesArray objectAtIndex:0]]]:
        [filtersString appendFormat:@"{!tag=variant}variant:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedSizesArray objectAtIndex:0]]];
    
    if ([sharedFacetData.selectedSizesArray count] > 1) {
        for (int i = 1; i < [sharedFacetData.selectedSizesArray count]; i++)
            [filtersString appendFormat:@" OR variant:[[%@]]", [self getSelectionFromLabelString:[sharedFacetData.selectedSizesArray objectAtIndex:i]]];
    }
    
    return filtersString;
}


- (NSString *)getSortStringForRESTfulRequest {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData.selectedSortString isEqualToString:HIGHEST_TO_LOWEST]) {
        return @"&sortby=price&sortdir=desc";
    } else if ([sharedFacetData.selectedSortString isEqualToString:LOWEST_TO_HIGHEST]) {
        return @"&sortby=price&sortdir=asc";
    }
    return @"";
}

- (void)setFacetsFromResponseDictionary:(NSDictionary *)responseDictionary {
    [self.originalResponseDictionary removeAllObjects];
    [self.originalResponseDictionary setDictionary:responseDictionary];
    [self updateFacetsFromResponseDictionary:responseDictionary];
}

- (void)updateFacetsFromResponseDictionary:(NSDictionary *)responseDictionary {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    [self clearAllFacets];
    
    NSDictionary *facetsDictionary = responseDictionary[@"facet_counts"];
    NSDictionary *facetFieldsDictionary =  facetsDictionary[@"facet_fields"];
    NSDictionary *facetQueriesDictionary = facetsDictionary[@"facet_queries"];
    [self initPriceFacetWithFacetQueriesDictionary:facetQueriesDictionary];
    NSDictionary *brandDictionary = facetFieldsDictionary[@"brand"];
    for (NSString *item in brandDictionary) {
        [sharedFacetData.brandFacetArray addObject:item ];
        [sharedFacetData.brandFacetCountArray addObject:(NSNumber *)brandDictionary[item]];
    }
    NSDictionary *categoryDictionary = facetFieldsDictionary[@"cat_1"];
    for (NSString *item in categoryDictionary) {
        [sharedFacetData.categoryFacetArray addObject:item ];
        [sharedFacetData.categoryFacetCountArray addObject:(NSNumber *)categoryDictionary[item]];
    }
    NSDictionary *colorDictionary = facetFieldsDictionary[@"att_color"];
    for (NSString *item in colorDictionary) {
        [sharedFacetData.colorFacetArray addObject:item ];
        [sharedFacetData.colorFacetCountArray addObject:(NSNumber *)colorDictionary[item]];
    }
    NSDictionary *sizeDictionary = facetFieldsDictionary[@"variant"];
    for (NSString *item in sizeDictionary) {
        [sharedFacetData.sizeFacetArray addObject:item ];
        [sharedFacetData.sizeFacetCountArray addObject:(NSNumber *)sizeDictionary[item]];
    }
}

- (NSString *)getHumanReadablePricefromPriceBracket:(NSString *)priceBracket {
    NSRange toRange = [priceBracket rangeOfString:@"TO"];
    NSRange fromPriceRange = NSMakeRange(1, toRange.location - 2);
    NSString *fromPriceString = [priceBracket substringWithRange:fromPriceRange];
    NSRange toPriceRange = NSMakeRange(toRange.location+3, priceBracket.length - toRange.location - toRange.length -2);
    NSString *toPriceString = [priceBracket substringWithRange:toPriceRange];
    return [NSString stringWithFormat:@"$%@ to $%@", fromPriceString ,toPriceString];
}

- (void)initPriceFacetWithFacetQueriesDictionary:(NSDictionary *)facetQueriesDictionary {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    NSArray *allKeysArray = facetQueriesDictionary.allKeys;
    NSString *pricePrefix = @"";
    if ([allKeysArray count] != 0)
        pricePrefix = [[allKeysArray objectAtIndex:0]  componentsSeparatedByString:@":"][0];
    
    if ([pricePrefix length] != 0)
        sharedFacetData.pricePrefix = pricePrefix;
 
    for (NSString *key in allKeysArray) {
        
        NSString *tempBracket = [key componentsSeparatedByString:@":"][1];
        [[sharedFacetData priceBracketsArray] addObject:tempBracket];
        
        NSString *tempString = [[facetQueriesDictionary valueForKey:key] stringValue];
        if (tempString && ![tempString isEqualToString:@"0"]) {
            
            [sharedFacetData.priceFacetArray addObject:[self getHumanReadablePricefromPriceBracket:tempBracket]];
            [sharedFacetData.priceFacetCountArray addObject:tempString];
        }
    }
}


- (void)resetFacets {
    [self clearAllSelections];
    [self updateFacetsFromResponseDictionary:[self originalResponseDictionary]];
}

- (void)clearAllSelections {
    [self clearSortSelection];
    [self clearPriceSelection];
    [self clearCategoryString];
    [self clearBrandSelection];
    [self clearColorSelection];
    [self clearSizeSelection];
}

- (void)clearAllFacets {
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];

    [sharedFacetData.priceFacetArray removeAllObjects];
    [sharedFacetData.priceFacetCountArray removeAllObjects];
    
    [sharedFacetData.categoryFacetArray removeAllObjects];
    [sharedFacetData.categoryFacetCountArray removeAllObjects];
    
    [sharedFacetData.brandFacetArray removeAllObjects];
    [sharedFacetData.brandFacetCountArray removeAllObjects];
    
    [sharedFacetData.colorFacetArray removeAllObjects];
    [sharedFacetData.colorFacetCountArray removeAllObjects];
    
    [sharedFacetData.sizeFacetArray removeAllObjects];
    [sharedFacetData.sizeFacetCountArray removeAllObjects];
}

@end





















