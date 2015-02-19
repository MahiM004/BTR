//
//  BTRFacetsHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFacetsHandler.h"
#import "BTRFacetDictionary.h"


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

+ (void)setPriceSelectionWithPriceString:(NSString *)priceString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    sharedFacetDictionary.selectedPriceString = priceString;
    
}

+ (NSString *)getSelectedPriceString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    return sharedFacetDictionary.selectedPriceString;
}

+ (BOOL)hasSelectedPriceOptionString:(NSString *)optionString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    if ([sharedFacetDictionary.selectedPriceString isEqualToString:optionString])
        return true;
        
    return false;
}

+ (void)clearPriceSelection {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    sharedFacetDictionary.selectedPriceString = @"";
}

+ (NSMutableArray *)getPriceFiltersForDisplay {
    
    
    NSLog(@"getPriceFiltersForDisplay NOT IMPLEMENTED!");
    NSMutableArray * dummy;
    return dummy;
}

/*
 
 
 */



+ (void)setCategorySelectionWithCategoryString:(NSString *)categoryString {

    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    sharedFacetDictionary.selectedCategoryString = categoryString;
}


+ (NSString *)getSelectedCategoryString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    return sharedFacetDictionary.selectedPriceString;

}

+ (BOOL)hasSelectedCategoryOptionString:(NSString *)optionString {
    
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    if ([sharedFacetDictionary.selectedPriceString isEqualToString:optionString])
        return true;
    
    return false;
}

+ (void)clearCategoryString {
    
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    sharedFacetDictionary.selectedPriceString = @"";
}

+ (NSMutableArray *)getCategoryFiltersForDisplay {
    
    NSLog(@"getCategoryFiltersForDisplay NOT IMPLEMENTED!");

    NSMutableArray * dummy;
    return dummy;
}



/*
 
 */


+ (void)addBrandSelectionWithBrandString:(NSString *)brandString {

    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    
    if ( ![sharedFacetDictionary.selectedBrandsArray containsObject:brandString])
        [sharedFacetDictionary.selectedBrandsArray addObject:brandString];
        
}


+ (BOOL)hasSelectedBrandOptionString:(NSString *)optionString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    
    if ([sharedFacetDictionary.selectedBrandsArray containsObject:optionString])
        return true;
    
    return false;
}

+ (void)clearBrandSelection {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    [sharedFacetDictionary.selectedBrandsArray removeAllObjects];
}

+ (NSMutableArray *)getBrandFiltersForDisplay {
    
    NSLog(@"getBrandFiltersForDisplay NOT IMPLEMENTED!");
    NSMutableArray * dummy;
    return dummy;
}


/*
 
 */


+ (void)addColorSelectionWithColorString:(NSString *)colorString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    
    if ( ![sharedFacetDictionary.selectedColorsArray containsObject:colorString])
        [sharedFacetDictionary.selectedColorsArray addObject:colorString];
    
}


+ (BOOL)hasSelectedColorOptionString:(NSString *)optionString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];

    if ([sharedFacetDictionary.selectedColorsArray containsObject:optionString])
        return true;
    
    return false;

}

+ (void)clearColorSelection {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    [sharedFacetDictionary.selectedColorsArray removeAllObjects];
}

+ (NSMutableArray *)getColorFiltersForDisplay {
 
    NSLog(@"getColorFiltersForDisplay NOT IMPLEMENTED!");

    NSMutableArray * dummy;
    return dummy;
}


/*

 
 */



+ (void)addSizeSelectionWithSizeString:(NSString *)sizeString {
 
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    
    if ( ![sharedFacetDictionary.selectedSizesArray containsObject:sizeString])
        [sharedFacetDictionary.selectedSizesArray addObject:sizeString];
    
}


+ (BOOL)hasSelectedSizeOptionString:(NSString *)optionString {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    
    if ([sharedFacetDictionary.selectedSizesArray containsObject:optionString])
        return true;
    
    return false;
}

+ (void)clearSizeSelection {
    
    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];
    [sharedFacetDictionary.selectedBrandsArray removeAllObjects];
}

+ (NSMutableArray *)getSizeFiltersForDisplay {
    
    NSLog(@"getSizeFiltersForDisplay NOT IMPLEMENTED!");

    NSMutableArray * dummy;
    return dummy;
}


/*
 
 
 */


+ (NSArray *)getSortOptionStringsArray {
   
    NSArray *sortOptionsArray =  @[@"Best Match",@"Highest to Lowest Price" ,@"Lowest to Highest Price"];
    return sortOptionsArray;
}

+ (void)clearSortSelection {
    
    BTRFacetDictionary * btrFacetDictionary = [[BTRFacetDictionary alloc] init];
    btrFacetDictionary.selectedSortString = @"";
}

+ (void)setSortChosenOptionString:(NSString *)chosenSortString {
    
    BTRFacetDictionary * btrFacetDictionary = [[BTRFacetDictionary alloc] init];
    btrFacetDictionary.selectedSortString = chosenSortString;
}

+ (NSString *)getSelectedSortString {
    
    BTRFacetDictionary * btrFacetDictionary = [[BTRFacetDictionary alloc] init];
    return [btrFacetDictionary selectedSortString];
}


+ (NSMutableArray *)getFacetRequestString {
    
    NSLog(@"getFacetRequestString NOT IMPLEMENTED!");
    
    NSMutableArray * dummy;
    return dummy;
}


+ (void)updateFacetsFromResponseDictionary:(NSDictionary *)responseDictionary {

    BTRFacetDictionary *sharedFacetDictionary = [BTRFacetDictionary sharedFacetDictionary];

    
    NSDictionary *facetsDictionary = responseDictionary[@"facet_counts"];
    NSDictionary *facetQueriesDictionary = facetsDictionary[@"facet_queries"];
    NSDictionary *facetFieldsDictionary =  facetsDictionary[@"facet_fields"];
    
    
    [sharedFacetDictionary.priceFacetArray addObject:@"$0 to $200"];
    [sharedFacetDictionary.priceFacetCountArray addObject:(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[0 TO 200]"]];

    [sharedFacetDictionary.priceFacetArray addObject:@"$200 to $400"];
    [sharedFacetDictionary.priceFacetCountArray addObject:(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[200 TO 400]"]];

    [sharedFacetDictionary.priceFacetArray addObject:@"$400 to $600"];
    [sharedFacetDictionary.priceFacetCountArray addObject:(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[400 TO 600]"]];

    [sharedFacetDictionary.priceFacetArray addObject:@"$600 to $800"];
    [sharedFacetDictionary.priceFacetCountArray addObject:(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[600 TO 800]"]];

    [sharedFacetDictionary.priceFacetArray addObject:@"$800 to $1000"];
    [sharedFacetDictionary.priceFacetCountArray addObject:(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[800 TO 1000]"]];

    [sharedFacetDictionary.priceFacetArray addObject:@"$1000 to *"];
    [sharedFacetDictionary.priceFacetCountArray addObject:(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[1000 TO *]"]];
    
   
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
    
    
    NSArray *sortStringArray = [BTRFacetsHandler getSortOptionStringsArray];
    
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





















