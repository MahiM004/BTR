//
//  BTRSearchFilterTVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BTRSearchFilterTableDelegate;


@interface BTRSearchFilterTVC : UITableViewController


@property (nonatomic, weak) id<BTRSearchFilterTableDelegate> delegate;


@property (strong, nonatomic) NSMutableArray *pricesArray;
@property (strong, nonatomic) NSMutableArray *brandsArray;
@property (strong, nonatomic) NSMutableArray *colorsArray;
@property (strong, nonatomic) NSMutableArray *sizesArray;
@property (strong, nonatomic) NSMutableArray *categoriesArray;

@property (strong, nonatomic) NSMutableArray *selectedBrands;
@property (strong, nonatomic) NSMutableArray *selectedColors;
@property (strong, nonatomic) NSMutableArray *selectedSizes;
@property (strong, nonatomic) NSMutableArray *selectedCategories;
@property (strong, nonatomic) NSMutableArray *selectedPrices;


@property (strong, nonatomic) NSMutableArray *queryRefineArray;

@end


@protocol BTRSearchFilterTableDelegate <NSObject>

@optional

- (void)searchRefineOptionChosen:(NSMutableArray *)searchRefineArray;

@end