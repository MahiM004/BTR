//
//  BTRFacetsHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRFacetsHandler.h"



@interface BTRFacetsHandler ()


@property (strong, nonatomic) NSString *facetString;

@end;

@implementation BTRFacetsHandler




+ (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary {
    
    return ((NSDictionary *)responseDictionary[@"facet_counts"]);
}

+ (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary {
    
    NSDictionary *tempDic = responseDictionary[@"response"];
    return [tempDic valueForKey:@"docs"];
}

+ (NSString *)getSortTypeForIndex:(NSInteger)sortIndex {
    
    NSArray *sortStringArray = @[@"Best Match",@"Highest to Lowest Price" ,@"Lowest to Highest Price"];
    
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

    NSLog(@"price variations are ignored at getFacetStringForRESTWithChosenFacetsArray");
    
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





















