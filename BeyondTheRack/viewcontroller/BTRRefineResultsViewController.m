//
//  BTRRefineResultsViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRRefineResultsViewController.h"
#import "BTRSearchFilterTVC.h"
#import "BTRItemFetcher.h"
#import "BTRConnectionHelper.h"
#import "BTRFacetsHandler.h"
#import "FilterTypeCell.h"
#import "FilterSelectionCell.h"
#import "BTRLoader.h"

@interface BTRRefineResultsViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSString * getPreviousSelectedSortType; // for getting tag values for sort tags
}


@property (weak, nonatomic) IBOutlet UITableView *tableFilterType; // table 11
@property (weak, nonatomic) IBOutlet UITableView *tableFilterSelection; // table 22
@property (strong, nonatomic) NSMutableArray *titles; // Titles table 11

@property (strong, nonatomic) NSMutableArray * sortTypeArray;

@property (strong, nonatomic) NSMutableArray *optionsArray; // get all Array

@property (strong, nonatomic) NSMutableArray *totalSelectedArray;

@property (strong, nonatomic) NSMutableArray *getSelectedArray; // make temporary array for multiple selection



@property (nonatomic) int selectedSortIndex; // This is for to identify the last selected Sort Type

@property (weak, nonatomic) NSString * selectSortString; // sort items selected one to set

@property (nonatomic) BOOL isMultiSelect;

@property  NSString * selectedCategory; // temp string

@property  NSString * selectedPrice; // temp string

@property BOOL multipleSelChange; // to check if multiple selection has a change or not(if add or remove)

@end


@implementation BTRRefineResultsViewController

@synthesize backgroundImage;

- (NSMutableArray *)optionsArray {
    if (!_optionsArray) _optionsArray = [[NSMutableArray alloc] init];
    return _optionsArray;
}

- (NSMutableArray *)titles {
    if (!_titles) _titles = [[NSMutableArray alloc] init];
    return _titles;
}

- (NSMutableArray *)sortTypeArray {
    if (!_sortTypeArray) _sortTypeArray = [[NSMutableArray alloc] init];
    return _sortTypeArray;
}

- (NSMutableArray *)getSelectedArray {
    if (!_getSelectedArray) _getSelectedArray = [[NSMutableArray alloc] init];
    return _getSelectedArray;
}

- (NSMutableArray *)totalSelectedArray {
    if (!_totalSelectedArray) _totalSelectedArray = [[NSMutableArray alloc] init];
    return _totalSelectedArray;
}



- (void)initOptionsArray {
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if ([[sharedFacetHandler getSelectedSortString] isEqualToString:BEST_MATCH]) {
        _selectSortString = BEST_MATCH;
    }
    else if ([[sharedFacetHandler getSelectedSortString] isEqualToString:HIGHEST_TO_LOWEST]) {
        _selectSortString = HIGHEST_TO_LOWEST;
    }
    else if ([[sharedFacetHandler getSelectedSortString] isEqualToString:LOWEST_TO_HIGHEST]) {
        _selectSortString = LOWEST_TO_HIGHEST;
    } else {
        [sharedFacetHandler setSortChosenOptionString:BEST_MATCH];
        _selectSortString = BEST_MATCH; // Should be default if not selected
    }
    
    
    // TITLES ARRAY
    [self.titles addObjectsFromArray:@[SORT_TITLE, CATEGORY_TITLE, PRICE_TITLE, BRAND_TITLE, COLOR_TITLE, SIZE_TITLE]];
    
    // SORT TYPES
    [self.sortTypeArray setArray:@[BEST_MATCH, HIGHEST_TO_LOWEST, LOWEST_TO_HIGHEST]];
    
    
    // By default this only SORT_TITLE only needed
    [self loadDataWithSelectedSortType:SORT_TITLE];
    
    if (self.titles.count != 0 && _tableFilterType) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableFilterType selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        _selectedSortIndex = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _multipleSelChange = NO;
     self.headerView.backgroundColor = self.view.backgroundColor = [BTRViewUtility BTRBlack];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initOptionsArray];
    _tableFilterSelection.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 11)
        return self.titles.count;
    if (_selectedSortIndex == 0)
        return self.sortTypeArray.count;
    return self.optionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 11) {
        static NSString *cellIdentifier = @"filterType";
        FilterTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
            cell = [[FilterTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.lblTitle.text = self.titles[indexPath.row];
        if (_selectedSortIndex == (int)indexPath.row) {
            cell.backView.backgroundColor = [UIColor whiteColor];
            cell.lblTitle.textColor = [UIColor blackColor];
        } else {
            cell.backView.backgroundColor = [UIColor clearColor];
            cell.lblTitle.textColor = [UIColor lightGrayColor];
        }
        return cell;
    }
    
    else {
        static NSString *cellIdentifier = @"filterSelection";
        FilterSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
            cell = [[FilterSelectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if (_selectedSortIndex == 0) { // sort type Single Selection
            cell.lblTitle.text = self.sortTypeArray[indexPath.row];
            if ([cell.lblTitle.text isEqualToString:_selectSortString]) {
                cell.accessoryType = 3;
            } else {
                cell.accessoryType = 0;
            }
        }
        else if ([self.titles[_selectedSortIndex] isEqualToString:CATEGORY_TITLE]) { // Category Single selection
            // we are doing this because  for example we select some category "HELLO WORLD: (55)" after aplying some more filters it may become "HELLO WORLD: (22)" difference in number so condition not satisfied same for price also
            
            cell.lblTitle.text = self.optionsArray[indexPath.row];
            
            NSString * selectedSingleC = [self breakStringGetFirst:cell.lblTitle.text];
            
            if ([selectedSingleC isEqualToString:_selectedCategory]) {
                cell.accessoryType = 3;
            } else {
                cell.accessoryType = 0;
            }
        }
        else if ([self.titles[_selectedSortIndex] isEqualToString:PRICE_TITLE]) { // Price Single
            
            cell.lblTitle.text = self.optionsArray[indexPath.row];
            
            NSString * selectedSingleP = [self breakStringGetFirst:cell.lblTitle.text];
            
            if ([selectedSingleP isEqualToString:_selectedPrice]) {
                cell.accessoryType = 3;
            } else {
                cell.accessoryType = 0;
            }
        }
        else {
            // Multiple selection
            cell.lblTitle.text = self.optionsArray[indexPath.row];
            if ([self isOptionSelected:[self.optionsArray objectAtIndex:indexPath.row]] >= 0){
                cell.accessoryType = 3;
            } else {
                cell.accessoryType = 0;
            }
        }
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 11) {
        FilterTypeCell * cell = (FilterTypeCell*)[tableView cellForRowAtIndexPath:indexPath];
        
         _selectedSortIndex = (int)indexPath.row; //For Sort Section
        
        if ([cell.lblTitle.text isEqualToString:SORT_TITLE] && _multipleSelChange == NO) {
            [self loadDataWithSelectedSortType:cell.lblTitle.text];
            getPreviousSelectedSortType = cell.lblTitle.text;
        }
        else if (_multipleSelChange == YES){
            _multipleSelChange = NO;
            // this should only call if any Multiple selection selected
            [self.totalSelectedArray addObjectsFromArray:self.getSelectedArray];
           
            [BTRLoader showLoaderInView:self.view];
            BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
            [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                          withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]
                                   success:^(NSDictionary *responseDictionary) {
                                       [self loadDataWithSelectedSortType:cell.lblTitle.text];
                                       getPreviousSelectedSortType = cell.lblTitle.text;
                                       [self.getSelectedArray removeAllObjects];
                                       [BTRLoader hideLoaderFromView:self.view];
                                   } failure:^(NSError *error) {
                                       [BTRLoader hideLoaderFromView:self.view];
                                   }];
            NSLog(@"%@",[self facetsQueryString:getPreviousSelectedSortType]);
        } else {
            [self loadDataWithSelectedSortType:cell.lblTitle.text];
            getPreviousSelectedSortType = cell.lblTitle.text;
        }
    }

    else {
       
        FilterSelectionCell *cell = (FilterSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (_isMultiSelect) {
            //3
            _multipleSelChange = YES;
            if (cell.accessoryType == 0) {
                cell.accessoryType = 3;
                [self.getSelectedArray addObject:cell.lblTitle.text];
            } else {
                cell.accessoryType = 0;
                [self.getSelectedArray removeObject:cell.lblTitle.text];
            }
        }
        
        else if (![self isMultiSelect]){
            //3
            if (cell.accessoryType == 0) {
                cell.accessoryType = 3;
            }
        
            NSString * selectedSort = self.titles[_selectedSortIndex];
            BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
            if (_selectedSortIndex != 0) {
                if ([selectedSort isEqualToString:CATEGORY_TITLE]) {
                    _selectedCategory = [self breakStringGetFirst:cell.lblTitle.text];
                    [sharedFacetHandler setCategorySelectionWithCategoryString:_selectedCategory];
                    [self.totalSelectedArray addObjectsFromArray:self.getSelectedArray];
                    [BTRLoader showLoaderInView:self.view];
                    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
                    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                                  withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]
                                           success:^(NSDictionary *responseDictionary) {
                                               [self.getSelectedArray removeAllObjects];
                                               [self loadDataWithSelectedSortType:CATEGORY_TITLE];
                                               getPreviousSelectedSortType = cell.lblTitle.text;
                                               [BTRLoader hideLoaderFromView:self.view];
                                           } failure:^(NSError *error) {
                                               [BTRLoader hideLoaderFromView:self.view];
                                           }];
                    NSLog(@"%@",[self facetsQueryString:getPreviousSelectedSortType]);
                } else {
                    _selectedPrice = [self breakStringGetFirst:cell.lblTitle.text];
                    [sharedFacetHandler setPriceSelectionWithPriceString:_selectedPrice];
                    [self.totalSelectedArray addObjectsFromArray:self.getSelectedArray];
                    [BTRLoader showLoaderInView:self.view];
                    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
                    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                                  withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]
                                           success:^(NSDictionary *responseDictionary) {
                                               [self.getSelectedArray removeAllObjects];
                                               [self loadDataWithSelectedSortType:PRICE_TITLE];
                                               getPreviousSelectedSortType = cell.lblTitle.text;
                                               [BTRLoader hideLoaderFromView:self.view];
                                           } failure:^(NSError *error) {
                                               [BTRLoader hideLoaderFromView:self.view];
                                           }];
                    NSLog(@"%@",[self facetsQueryString:getPreviousSelectedSortType]);
                }
            }
            else {
                _selectSortString = cell.lblTitle.text;
                [sharedFacetHandler setSortChosenOptionString:_selectSortString]; // Sort selection
                getPreviousSelectedSortType = cell.lblTitle.text;
                [_tableFilterSelection reloadData];
            }
        }
    }
}


- (void)loadDataWithSelectedSortType:(NSString*)title {
    
    [self.totalSelectedArray removeAllObjects];//Remove all objects any way we are adding at bottom
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if ([title isEqualToString:SORT_TITLE]) {
        _isMultiSelect = NO;
        [self.sortTypeArray setArray:@[BEST_MATCH,HIGHEST_TO_LOWEST,LOWEST_TO_HIGHEST]];//Static
    }
    else if ([title isEqualToString:CATEGORY_TITLE]) {
        _isMultiSelect = NO;
        if ([sharedFacetHandler getCategoryFiltersForDisplay] )
            [self.optionsArray setArray:[sharedFacetHandler getCategoryFiltersForDisplay]];
    }
    else if ([title isEqualToString:PRICE_TITLE]) {
        _isMultiSelect = NO;
        if ([sharedFacetHandler getPriceFiltersForDisplay] )
            [self.optionsArray setArray:[sharedFacetHandler getPriceFiltersForDisplay]];
    }
    else if ([title isEqualToString:BRAND_TITLE]) {
        _isMultiSelect = YES;
        if ([[sharedFacetHandler getBrandFiltersForDisplay] count] != 0 ) {
            [self.optionsArray setArray:[sharedFacetHandler getBrandFiltersForDisplay]];
        } else {
            _selectedSortIndex = 0;
            //this is because if after selecting the row there is no data it shows empty so just make him to go the first
            // we can also make him to go above one but difficult to handle i think
        }
    }
    else if ([title isEqualToString:COLOR_TITLE]) {
        _isMultiSelect = YES;
        if ([[sharedFacetHandler getColorFiltersForDisplay] count] != 0) {
            [self.optionsArray setArray:[sharedFacetHandler getColorFiltersForDisplay]];
        } else {
            _selectedSortIndex = 0;
        }
    }
    else if ([title isEqualToString:SIZE_TITLE]) {
        _isMultiSelect = YES;
        if ([[sharedFacetHandler getSizeFiltersForDisplay] count] != 0) {
            [self.optionsArray setArray:[sharedFacetHandler getSizeFiltersForDisplay]];
        } else {
            _selectedSortIndex = 0;
        }
    }
    
    
    
    
    if (sharedFacetHandler.getCategoryFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:CATEGORY_TITLE];
    }
    
    if (sharedFacetHandler.getPriceFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:PRICE_TITLE];
    }
    
    if (sharedFacetHandler.getBrandFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:BRAND_TITLE];
    }
    
    if (sharedFacetHandler.getColorFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:COLOR_TITLE];
    }
    
    if (sharedFacetHandler.getSizeFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:SIZE_TITLE];
    }
    
    if ([sharedFacetHandler getSelectedCategoryString] )
        _selectedCategory =  [sharedFacetHandler getSelectedCategoryString];

    if ([sharedFacetHandler getSelectedPriceString])
        _selectedPrice = [sharedFacetHandler getSelectedPriceString];
    
    if ([sharedFacetHandler getSelectedBrandsArray])
        [self.totalSelectedArray addObjectsFromArray:[sharedFacetHandler getSelectedBrandsArray]];
    
    if ([sharedFacetHandler getSelectedColorsArray])
        [self.totalSelectedArray addObjectsFromArray:[sharedFacetHandler getSelectedColorsArray]];
    
    if ([sharedFacetHandler getSelectedSizesArray])
        [self.totalSelectedArray addObjectsFromArray:[sharedFacetHandler getSelectedSizesArray]];
    
    
    
    /* Animate the table view reload */
    [UIView transitionWithView:_tableFilterSelection
                      duration:0.35f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void)
     {
         [_tableFilterSelection reloadData];
     }
                    completion:nil];

    [_tableFilterType reloadData];
}

#pragma mark - Navigation
- (IBAction)applyButtonTapped:(UIButton *)sender {
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    //we are making the array empty in didselectrow in case not empty it should perform the below method
    if (self.getSelectedArray.count != 0) {
        [self.totalSelectedArray addObjectsFromArray:self.getSelectedArray];
        [BTRLoader showLoaderInView:self.view];
        
        [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                      withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]
                               success:^(NSDictionary *responseDictionary) {
                                   [BTRLoader hideLoaderFromView:self.view];
                                   [self.getSelectedArray removeAllObjects];
                               }
                               failure:^(NSError *error) {
                                   [BTRLoader hideLoaderFromView:self.view];
                               }];
        
    }
    
    [BTRLoader showLoaderInView:self.view];

    NSString *facetString = [sharedFacetHandler getFacetStringForRESTfulRequest];
    NSString *sortString = [sharedFacetHandler getSortStringForRESTfulRequest];
    
    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                    withSortString:sortString
                  withFacetsString:facetString
                           success:^(NSDictionary *responseDictionary) {
                             [BTRLoader hideLoaderFromView:self.view];
                             if ([self.delegate respondsToSelector:@selector(refineSceneWillDisappearWithResponseDictionary:)]) {
                                 [self.delegate refineSceneWillDisappearWithResponseDictionary:responseDictionary];
                             }
                             [self performSegueWithIdentifier:@"unwindFromRefineResultsApplied" sender:self];
                         }
                           failure:^(NSError *error) {
                             [BTRLoader hideLoaderFromView:self.view];
                         }];
}


- (IBAction)clearTapped:(UIButton *)sender {
    BTRFacetsHandler * sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    [sharedFacetHandler resetFacets];
    [self.totalSelectedArray removeAllObjects];
    [self.titles removeAllObjects];
//    [self.titles addObjectsFromArray:@[CATEGORY_TITLE,PRICE_TITLE, BRAND_TITLE, COLOR_TITLE, SIZE_TITLE]];
//     [self loadDataWithSelectedSortType:self.titles[0]];
    [self performSegueWithIdentifier:@"unwindFromRefineResultsCleared" sender:self];
}


#pragma mark - Load Results RESTful Facets
- (void)fetchItemsforSearchQuery:(NSString *)searchQuery
                withFacetsString:(NSString *)facetsString
                         success:(void (^)(id  responseObject)) success
                         failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withSortString:@"" withFacetString:facetsString andPageNumber:1]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
        [sharedFacetsHandler updateFacetsFromResponseDictionary:response];
        success(response);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Load Results RESTful Sort String
- (void)fetchItemsforSearchQuery:(NSString *)searchQuery
                withSortString:(NSString *)sortString
              withFacetsString:(NSString *)facetsString
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withSortString:sortString withFacetString:facetsString andPageNumber:1]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
            [sharedFacetsHandler updateFacetsFromResponseDictionary:response];
        }
        success(response);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (int)isOptionSelected:(NSString *)optionString {
    if ([self.totalSelectedArray count] == 0)
        return -1;
    
    for(NSString *item in  self.totalSelectedArray) {
        if([optionString isEqualToString:item]) {
            return 1;
            break;
        }
    }
    
    return -1;
}

- (NSString *)facetsQueryString:(NSString *)title {
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    if ([[self totalSelectedArray] count] != 0) {
        
        if ([title isEqualToString:CATEGORY_TITLE])
            [sharedFacetHandler setCategorySelectionWithCategoryString:_selectedCategory];
        
        if ([title isEqualToString:PRICE_TITLE])
            [sharedFacetHandler setPriceSelectionWithPriceString:_selectedPrice];
        
        if ([title isEqualToString:BRAND_TITLE])
            [sharedFacetHandler setSelectedBrandsWithArray:[self totalSelectedArray]];
        
        if ([title isEqualToString:COLOR_TITLE])
            [sharedFacetHandler setSelectedColorsWithArray:[self totalSelectedArray]];
        
        if ([title isEqualToString:SIZE_TITLE])
            [sharedFacetHandler setSelectedSizesWithArray:[self totalSelectedArray]];
    }
    return [sharedFacetHandler getFacetStringForRESTfulRequest];
}

- (NSString*)breakStringGetFirst:(NSString*)string {
    
    NSString * firstString;
    NSArray *stringsP = [string componentsSeparatedByString:@": "];
    
    if (stringsP.count!=0) {
        firstString = stringsP[0];
        return firstString;
    } else {
        return string;
    }
}

@end



















