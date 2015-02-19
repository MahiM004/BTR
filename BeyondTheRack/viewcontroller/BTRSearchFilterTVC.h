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



@property (strong, nonatomic) NSMutableArray *queryRefineArray;

@property (strong, nonatomic) NSDictionary *facetsDictionary;
@property (strong, nonatomic) NSDictionary *responseDictionaryFromSearch;


@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSMutableArray *oldChosenFacets;
@property (strong, nonatomic) NSDictionary *oldFacetsDictionary;



@end


@protocol BTRSearchFilterTableDelegate <NSObject>


@optional


- (void)searchFilterTableWillDisappearWithChosenFacetsArray:(NSMutableArray *)chosenFacetsArray;


@end





















