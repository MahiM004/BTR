//
//  BTRSearchFilterTVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SORT_SECTION 0
#define PRICE_FILTER 1
#define CATEGORY_FILTER 2
#define BRAND_FILTER 3
#define COLOR_FILTER 4
#define SIZE_FILTER 5

#define BRAND_TITLE @"Brand"
#define COLOR_TITLE @"Color"
#define SIZE_TITLE @"Size"
#define CATEGORY_TITLE @"Type"
#define PRICE_TITLE @"Price"


@protocol BTRSearchFilterTableDelegate;

@interface BTRSearchFilterTVC : UITableViewController



@property (nonatomic, weak) id<BTRSearchFilterTableDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *brandsArray;
@property (strong, nonatomic) NSMutableArray *colorsArray;
@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@property (strong, nonatomic) NSMutableArray *pricesArray;

@property (strong, nonatomic) NSMutableArray *selectedBrands;
@property (strong, nonatomic) NSMutableArray *selectedColors;
@property (strong, nonatomic) NSMutableArray *selectedSizes;
@property (strong, nonatomic) NSMutableArray *selectedCategories;
@property (strong, nonatomic) NSMutableArray *selectedPrices;


@property (strong, nonatomic) NSMutableArray *queryRefineArray;

@property (strong, nonatomic) NSDictionary *responseDictionaryFromFacets;
@property (strong, nonatomic) NSString *searchString;

@end


@protocol BTRSearchFilterTableDelegate <NSObject>


@optional


- (void)searchFilterTableWillDisappearWithResponseDictionary:(NSDictionary *)responseDictionary;


@end





















