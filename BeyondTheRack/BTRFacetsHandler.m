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

@property (strong, nonatomic) NSString *facetString;


@end;

@implementation BTRFacetsHandler



static BTRFacetsHandler *_sharedInstance;

+ (BTRFacetsHandler *)sharedFacetHandler
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


/*
 
 */


- (NSArray *)getSortOptionStringsArray {
    
    NSArray *sortOptionsArray =  @[@"Best Match",@"Highest to Lowest Price" ,@"Lowest to Highest Price"];
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



/*
 
 */

- (void)setPriceSelectionWithPriceString:(NSString *)priceString {
    
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    sharedFacetData.selectedPriceString = priceString;
    
}

- (NSString *)getSelectedPriceString {
    
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    return sharedFacetData.selectedPriceString;
}

- (BOOL)hasSelectedPriceOptionString:(NSString *)optionString {
    
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    if ([sharedFacetData.selectedPriceString isEqualToString:optionString])
        return true;
        
    return false;
}

- (void)clearPriceSelection {
    
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];
    sharedFacetData.selectedPriceString = @"";
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

/*
 
 
 */



- (void)setCategorySelectionWithCategoryString:(NSString *)categoryString {

    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    sharedFacetDictionary.selectedCategoryString = categoryString;
}


- (NSString *)getSelectedCategoryString {
    
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    return sharedFacetDictionary.selectedPriceString;

}

- (BOOL)hasSelectedCategoryOptionString:(NSString *)optionString {
    
    
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    if ([sharedFacetDictionary.selectedPriceString isEqualToString:optionString])
        return true;
    
    return false;
}

- (void)clearCategoryString {
    
    
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    sharedFacetDictionary.selectedPriceString = @"";
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



/*
 
 */


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


/*
 
 */


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
 
    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];
    
    NSMutableArray * arrayStringForDisplay = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [sharedFacetDictionary.colorFacetArray count]; i++) {
        
        NSString *priceString = [NSString stringWithFormat:@"%@: (%@)",
                                 [sharedFacetDictionary.colorFacetArray objectAtIndex:i],
                                 [sharedFacetDictionary.colorFacetCountArray objectAtIndex:i]];
        
        [arrayStringForDisplay addObject:priceString];
    }
    
    
    return arrayStringForDisplay;
}


/*

 
 */



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


/*
 
 
 */



- (NSString *)getFacetStringForRESTfulRequest {
    
    BTRFacetData *sharedFacetData = [BTRFacetData sharedFacetData];

    
    NSMutableString *facetsString = [[NSMutableString alloc] init];
    
    NSLog(@"country ignored at getFacetStringForRESTWithChosenFacetsArray");
    
    if ([sharedFacetData.selectedPriceString isEqualToString:@""])
        ((BOOL)[facetsString length])?
        [facetsString appendFormat:@";price_sort_ca:%@", [sharedFacetData selectedPriceString]]:
        [facetsString appendFormat:@"price_sort_ca:%@", [sharedFacetData selectedPriceString]];
    
    if ([sharedFacetData.selectedCategoryString isEqualToString:@""])
        ((BOOL)[facetsString length])?
        [facetsString appendFormat:@";{!tag=cat_1}cat_1:[[%@]]", [sharedFacetData selectedCategoryString]]:
        [facetsString appendFormat:@"{!tag=cat_1}cat_1:[[%@]]", [sharedFacetData selectedCategoryString]];
    
    
    if ([sharedFacetData.selectedBrandsArray count] != 0)
        ((BOOL)[facetsString length]) ?
        [facetsString appendFormat:@";{!tag=brand}brand:[[%@]]", [sharedFacetData.selectedBrandsArray objectAtIndex:0]]:
        [facetsString appendFormat:@"{!tag=brand}brand:[[%@]]", [sharedFacetData.selectedBrandsArray objectAtIndex:0]];
    
    if ([sharedFacetData.selectedBrandsArray count] > 1) {
        for (int i = 1; i < [sharedFacetData.selectedBrandsArray count]; i++)
            [facetsString appendFormat:@" OR brand:[[%@]]",[sharedFacetData.selectedBrandsArray objectAtIndex:i]];
    }
    
    
    if ([sharedFacetData.selectedColorsArray count] != 0)
        ((BOOL)[facetsString length]) ?
        [facetsString appendFormat:@";{!tag=att_color}att_color:[[%@]]", [sharedFacetData.selectedColorsArray objectAtIndex:0]]:
        [facetsString appendFormat:@"{!tag=att_color}att_color:[[%@]]", [sharedFacetData.selectedColorsArray objectAtIndex:0]];
    
    if ([sharedFacetData.selectedColorsArray count] > 1) {
        for (int i = 1; i < [sharedFacetData.selectedColorsArray count]; i++)
            [facetsString appendFormat:@" OR att_color:[[%@]]",[sharedFacetData.selectedColorsArray objectAtIndex:i]];
    }
    
    
    if ([sharedFacetData.selectedSizesArray count] != 0)
        ((BOOL)[facetsString length])?
        [facetsString appendFormat:@";{!tag=variant}variant:[[%@]]", [sharedFacetData.selectedSizesArray objectAtIndex:0]]:
        [facetsString appendFormat:@"{!tag=variant}variant:[[%@]]", [sharedFacetData.selectedSizesArray objectAtIndex:0]];
    
    
    return facetsString;
}


- (void)updateFacetsFromResponseDictionary:(NSDictionary *)responseDictionary {

    BTRFacetData *sharedFacetDictionary = [BTRFacetData sharedFacetData];

    NSLog(@"country ignored at updateFacetsFromResponseDictionary");

    
    NSDictionary *facetsDictionary = responseDictionary[@"facet_counts"];
    NSDictionary *facetQueriesDictionary = facetsDictionary[@"facet_queries"];
    NSDictionary *facetFieldsDictionary =  facetsDictionary[@"facet_fields"];

    NSString *tempString = (NSString *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[0 TO 200]"];
    if (tempString)
    {
        [sharedFacetDictionary.priceFacetArray addObject:@"$0 to $200"];
        [sharedFacetDictionary.priceFacetCountArray addObject:tempString];
    }
    
    tempString = (NSString *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[200 TO 400]"];
    if (tempString)
    {
        [sharedFacetDictionary.priceFacetArray addObject:@"$200 to $400"];
        [sharedFacetDictionary.priceFacetCountArray addObject:tempString];
    }

    tempString = (NSString *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[400 TO 600]"];
    if (tempString)
    {
        [sharedFacetDictionary.priceFacetArray addObject:@"$400 to $600"];
        [sharedFacetDictionary.priceFacetCountArray addObject:tempString];
    }
    
    tempString = (NSString *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[600 TO 800]"];
    if (tempString)
    {
        [sharedFacetDictionary.priceFacetArray addObject:@"$600 to $800"];
        [sharedFacetDictionary.priceFacetCountArray addObject:tempString];
    }

    tempString = (NSString *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[800 TO 1000]"];
    if (tempString)
    {
        [sharedFacetDictionary.priceFacetArray addObject:@"$800 to $1000"];
        [sharedFacetDictionary.priceFacetCountArray addObject:tempString];
    }
    

    tempString = (NSString *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[1000 TO *]"];
    if (tempString)
    {
        [sharedFacetDictionary.priceFacetArray addObject:@"$1000 to *"];
        [sharedFacetDictionary.priceFacetCountArray addObject:tempString];
    }
   
    NSDictionary *brandDictionary = facetFieldsDictionary[@"brand"];
    for (NSString *item in brandDictionary) {

        [sharedFacetDictionary.brandFacetArray addObject:item ];
        [sharedFacetDictionary.brandFacetCountArray addObject:(NSNumber *)brandDictionary[item]];
    }
    
    NSDictionary *categoryDictionary = facetFieldsDictionary[@"cat_1"];
    for (NSString *item in categoryDictionary) {
   
        [sharedFacetDictionary.categoryFacetArray addObject:item ];
        [sharedFacetDictionary.categoryFacetCountArray addObject:(NSNumber *)categoryDictionary[item]];
    }
    
    NSDictionary *colorDictionary = facetFieldsDictionary[@"att_color"];
    for (NSString *item in colorDictionary) {
        
        [sharedFacetDictionary.colorFacetArray addObject:item ];
        [sharedFacetDictionary.colorFacetCountArray addObject:(NSNumber *)colorDictionary[item]];
    }
    
    NSDictionary *sizeDictionary = facetFieldsDictionary[@"variant"];
    for (NSString *item in sizeDictionary) {
        
        [sharedFacetDictionary.sizeFacetArray addObject:item ];
        [sharedFacetDictionary.sizeFacetCountArray addObject:(NSNumber *)sizeDictionary[item]];
    }
}



/*
 
 *
 *
 
 */


+ (BOOL)hasChosenFacetInFacetsArray:(NSMutableArray *)chosenFacetsArray {
    
    for (NSMutableArray *someArray in chosenFacetsArray)
        if ([someArray count] > 0)
            return YES;
    
    return NO;
}


/*
 
 */

+ (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary {
    
    return ((NSDictionary *)responseDictionary[@"facet_counts"]);
}

+ (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary {
    
    NSDictionary *tempDic = responseDictionary[@"response"];    
    return [tempDic valueForKey:@"docs"];
}

+ (NSString *)getSortTypeForIndex:(NSInteger)sortIndex {
    
    BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
    
    NSArray *sortStringArray = [sharedFacetsHandler getSortOptionStringsArray];
    
    if (sortIndex >=0 && sortIndex <= [sortStringArray count] - 1)
        return [sortStringArray objectAtIndex:sortIndex];
    
    return nil;
}


+ (NSString *)priceRangeForAPIReadableFromLabelString:(NSString *)labelString {
    
    
    if ([labelString containsString:@"$0 to $200"]) {
        
        return @"[0 TO 200]";
    }
    else if ([labelString containsString:@"$200 to $400"]) {
        
        return @"[200 TO 400]";
        
    }
    else if ([labelString containsString:@"$400 to $600"]) {
        
        return @"[400 TO 600]";
        
    }
    else if ([labelString containsString:@"$600 to $800"]) {
        
        return @"[600 TO 800]";
        
    }
    else if ([labelString containsString:@"$800 to $1000"]) {
        
        return @"[800 TO 1000]";
        
    }
    else if ([labelString containsString:@"$1000 to *"]) {
        
        return @"[1000 TO *]";
    }
    
    return nil;
    
}

/*
+ (NSMutableArray *)extractFilterFacetsForDisplayFromResponse:(NSDictionary *)facetsDictionary {
    
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    NSDictionary *facetQueriesDictionary = facetsDictionary[@"facet_queries"];
    NSDictionary *facetFieldsDictionary =  facetsDictionary[@"facet_fields"];
    
    NSMutableArray *priceFilter = [[NSMutableArray alloc] init];
    NSMutableArray *categoryFilter = [[NSMutableArray alloc] init];
    NSMutableArray *brandFilter = [[NSMutableArray alloc] init];
    NSMutableArray *colorFilter= [[NSMutableArray alloc] init];
    NSMutableArray *sizeFilter = [[NSMutableArray alloc] init];
    
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    
    NSString *tempString = [NSString stringWithFormat:@"$0 to $200: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[0 TO 200]"] ];
    [priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$200 to $400: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[200 TO 400]"] ];
    [priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$400 to $600: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[400 TO 600]"] ];
    [priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$600 to $800: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[600 TO 800]"] ];
    [priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$800 to $1000: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[800 TO 1000]"] ];
    [priceFilter addObject:tempString];
    tempString = [NSString stringWithFormat:@"$1000 to *: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[1000 TO *]"] ];
    [priceFilter addObject:tempString];
    
    
    NSDictionary *brandDictionary = facetFieldsDictionary[@"brand"];
    for (NSString *item in brandDictionary)
        [brandFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)brandDictionary[item]] ];
    
    NSDictionary *categoryDictionary = facetFieldsDictionary[@"cat_1"];
    for (NSString *item in categoryDictionary)
        [categoryFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)categoryDictionary[item]] ];
    
    NSDictionary *colorDictionary = facetFieldsDictionary[@"att_color"];
    for (NSString *item in colorDictionary)
        [colorFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)colorDictionary[item]] ];
    
    NSDictionary *sizeDictionary = facetFieldsDictionary[@"variant"];
    for (NSString *item in sizeDictionary)
        [sizeFilter addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)sizeDictionary[item]] ];
    
    
    [brandFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [categoryFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [colorFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [sizeFilter sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    
    [resultsArray addObject:priceFilter];
    [resultsArray addObject:categoryFilter];
    [resultsArray addObject:brandFilter];
    [resultsArray addObject:colorFilter];
    [resultsArray addObject:sizeFilter];
    
    
    return resultsArray;
}
*/

+ (NSMutableArray *)getFacetOptionsFromDisplaySelectedPrices:(NSMutableArray *)selectedPrices
                                      fromSelectedCategories:(NSMutableArray *)selectedCategories
                                        fromSelectedBrand:(NSMutableArray *)selectedBrands
                                      fromSelectedColors:(NSMutableArray *)selectedColors
                                       fromSelectedSizes:(NSMutableArray *)selectedSizes
{
    NSMutableArray *facetOptionsArray = [[NSMutableArray alloc] init];
   
    
    NSMutableArray *pricesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [selectedPrices count]; i++)
        [pricesArray addObject:[BTRFacetsHandler priceRangeForAPIReadableFromLabelString:[[selectedPrices objectAtIndex:i] componentsSeparatedByString:@":"][0]]];
    
    NSMutableArray *brandsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [selectedBrands count]; i++)
        [brandsArray addObject:[[selectedBrands objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *colorsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [selectedColors count]; i++)
        [colorsArray addObject:[[selectedColors objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *sizesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [selectedSizes count]; i++)
        [sizesArray addObject:[[selectedSizes objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [selectedCategories count]; i++)
        [categoriesArray addObject:[[selectedCategories objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    
    [facetOptionsArray addObject:pricesArray];
    [facetOptionsArray addObject:categoriesArray];
    [facetOptionsArray addObject:brandsArray];
    [facetOptionsArray addObject:colorsArray];
    [facetOptionsArray addObject:sizesArray];
    
    return facetOptionsArray;
}


+ (NSString *)getFacetStringForRESTWithChosenFacetsArray:(NSMutableArray *)chosenFacetsArray withSortOption:(NSUInteger) sortOption {
    
    NSMutableString *facetsString = [[NSMutableString alloc] init];

    NSMutableArray *priceArray = [chosenFacetsArray objectAtIndex:0];
    NSMutableArray *categoryArray = [chosenFacetsArray objectAtIndex:1];
    NSMutableArray *brandArray = [chosenFacetsArray objectAtIndex:2];
    NSMutableArray *colorArray = [chosenFacetsArray objectAtIndex:3];
    NSMutableArray *sizeArray = [chosenFacetsArray objectAtIndex:4];

    NSLog(@"country ignored at getFacetStringForRESTWithChosenFacetsArray");
    
    if ([priceArray count] != 0)
        ((BOOL)[facetsString length])?
        [facetsString appendFormat:@";price_sort_ca:%@", [priceArray objectAtIndex:0]]:
        [facetsString appendFormat:@"price_sort_ca:%@", [priceArray objectAtIndex:0]];
    
    if ([categoryArray count] != 0)
        ((BOOL)[facetsString length])?
        [facetsString appendFormat:@";{!tag=cat_1}cat_1:[[%@]]", [categoryArray objectAtIndex:0]]:
        [facetsString appendFormat:@"{!tag=cat_1}cat_1:[[%@]]", [categoryArray objectAtIndex:0]];
    
    
    if ([brandArray count] != 0)
        ((BOOL)[facetsString length]) ?
        [facetsString appendFormat:@";{!tag=brand}brand:[[%@]]", [brandArray objectAtIndex:0]]:
        [facetsString appendFormat:@"{!tag=brand}brand:[[%@]]", [brandArray objectAtIndex:0]];
    
    if ([brandArray count] > 1) {
        for (int i = 1; i < [brandArray count]; i++)
            [facetsString appendFormat:@" OR brand:[[%@]]",[brandArray objectAtIndex:i]];
    }
    
    
    if ([colorArray count] != 0)
        ((BOOL)[facetsString length]) ?
        [facetsString appendFormat:@";{!tag=att_color}att_color:[[%@]]", [colorArray objectAtIndex:0]]:
        [facetsString appendFormat:@"{!tag=att_color}att_color:[[%@]]", [colorArray objectAtIndex:0]];
    
    if ([colorArray count] > 1) {
        for (int i = 1; i < [colorArray count]; i++)
            [facetsString appendFormat:@" OR att_color:[[%@]]",[colorArray objectAtIndex:i]];
    }

    
    if ([sizeArray count] != 0)
        ((BOOL)[facetsString length])?
        [facetsString appendFormat:@";{!tag=variant}variant:[[%@]]", [sizeArray objectAtIndex:0]]:
        [facetsString appendFormat:@"{!tag=variant}variant:[[%@]]", [sizeArray objectAtIndex:0]];
    
    
    return facetsString;
}




@end





















