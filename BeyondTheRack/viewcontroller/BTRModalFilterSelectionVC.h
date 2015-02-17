//
//  BTRModalFilterSelectionVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTRModalFilterSelectionDelegate;


@interface BTRModalFilterSelectionVC : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) id<BTRModalFilterSelectionDelegate> modalDelegate;


@property (strong, nonatomic) NSString *headerTitle;
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *selectedOptionsArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSMutableArray *chosenFacetsArray;
@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSString *facetString;

@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSDictionary *freshFacetsDictionary;


@property (nonatomic) BOOL isMultiSelect;

@end



@protocol BTRModalFilterSelectionDelegate <NSObject>

@optional

- (void)modalFilterSelectionVCDidEnd:(NSMutableArray *)selectedOptionsArray  withTitle:(NSString *)titleString withResponseDictionary:(NSDictionary *)responseDictionary;


@end