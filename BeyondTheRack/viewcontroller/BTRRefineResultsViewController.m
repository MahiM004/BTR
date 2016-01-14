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

@interface BTRRefineResultsViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSString * getPreviousSelectedSortType; // for getting tag values for sort tags
}


@property (weak, nonatomic) IBOutlet UITableView *tableFilterType; // table 11
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableFilterTypeWidth;

@property (weak, nonatomic) IBOutlet UITableView *tableFilterSelection; // table 22
@property (strong, nonatomic) NSMutableArray *titles; // Titles table 11

@property (strong, nonatomic) NSMutableArray *optionsArray; // get all Array

@property (strong, nonatomic) NSMutableArray *totalSelectedArray;


@property (nonatomic) int selectedSortIndex; // This is for to identify the last selected Sort Type

@property (weak, nonatomic) NSString * selectSortString; // sort items selected one to set

@property (nonatomic) BOOL isMultiSelect;

@property  NSString * selectedCategory; // temp string

@property  NSString * selectedPrice; // temp string

@property BOOL multipleOrSingleSelectOrDeselect; // to check if multiple selection has a change or not(if add or remove)


@property (weak, nonatomic) IBOutlet UIButton * clearBtn;

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
    _multipleOrSingleSelectOrDeselect = NO;
     self.headerView.backgroundColor = self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([BTRViewUtility isIPAD]) {
        [_tableFilterTypeWidth setConstant:150];
    }
    [self initOptionsArray];
    _tableFilterSelection.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 11)
        return self.titles.count;
    else
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
        
        cell.lblTitle.text = self.optionsArray[indexPath.row];
        
        NSString * brokenString = [self breakStringGetFirst:cell.lblTitle.text];
        
        if (_selectedSortIndex == 0) { // sort type Single Selection
            
            if ([cell.lblTitle.text isEqualToString:_selectSortString])
                cell.accessoryType = 3;
            else
                cell.accessoryType = 0;
            
        }
        else if ([self.titles[_selectedSortIndex] isEqualToString:CATEGORY_TITLE]) {
            
            if ([brokenString isEqualToString:_selectedCategory])
                cell.accessoryType = 3;
            else
                cell.accessoryType = 0;
        
        }
        else if ([self.titles[_selectedSortIndex] isEqualToString:PRICE_TITLE]) { // Price Single
            
            if ([brokenString isEqualToString:_selectedPrice])
                cell.accessoryType = 3;
            else
                cell.accessoryType = 0;
            
        }
        else {
            // Multiple selection
            
            if ([self isOptionSelected:brokenString] >= 0)
                cell.accessoryType = 3;
            else
                cell.accessoryType = 0;
            
        }
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 11) {
        FilterTypeCell * cell = (FilterTypeCell*)[tableView cellForRowAtIndexPath:indexPath];
        
         _selectedSortIndex = (int)indexPath.row; //For Sort Section
        
        if ([cell.lblTitle.text isEqualToString:SORT_TITLE] && _multipleOrSingleSelectOrDeselect == NO) {
            [self loadDataWithSelectedSortType:cell.lblTitle.text];
            getPreviousSelectedSortType = cell.lblTitle.text;
        }
        else if (_multipleOrSingleSelectOrDeselect == YES){
            
            // what ever changes in Single or  Multiple this will call
            /////////
            
            //   ONLY ONE OPERATION   //
            
            ////////
            
            [self addViewWithLoader];
            BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
            [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                          withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]
                                   success:^(NSDictionary *responseDictionary) {
                                       _multipleOrSingleSelectOrDeselect = NO;
                                       [self loadDataWithSelectedSortType:cell.lblTitle.text];
                                       getPreviousSelectedSortType = cell.lblTitle.text;
                                       [self removeViewWithLoader];
                                   } failure:^(NSError *error) {
                                       [BTRViewUtility showAlert:nil msg:@"Unabel to get the Data Please try again"];
                                       [self removeViewWithLoader];
                                   }];
            NSLog(@"%@",[self facetsQueryString:getPreviousSelectedSortType]);
        }
        else {
            [self loadDataWithSelectedSortType:cell.lblTitle.text];
            getPreviousSelectedSortType = cell.lblTitle.text;
        }
    }

    else {
       
        FilterSelectionCell *cell = (FilterSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (_isMultiSelect) {
            //3
            _multipleOrSingleSelectOrDeselect = YES;
            NSString * selected = [self breakStringGetFirst:cell.lblTitle.text];
            if (cell.accessoryType == 0) {
                cell.accessoryType = 3;
                
                if (![self.totalSelectedArray containsObject:selected])
                    [self.totalSelectedArray addObject:selected];
                
            } else {
                cell.accessoryType = 0;
                
                if ([self.totalSelectedArray containsObject:selected])
                    [self.totalSelectedArray removeObject:selected];
                
                [self setMultipleArraysIfObjectRemoved:selected];//Remove object from Facets Handler
            }
        }
        
        else if (![self isMultiSelect]) {
            //3
            if (cell.accessoryType == 0)
                cell.accessoryType = 3;
            else
                cell.accessoryType = 0;
            
        
            NSString * selectedSort = self.titles[_selectedSortIndex];
            BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
            if (_selectedSortIndex != 0) {
                _multipleOrSingleSelectOrDeselect = YES;
                if ([selectedSort isEqualToString:CATEGORY_TITLE]) {
                    if (cell.accessoryType == 3)
                        _selectedCategory = [self breakStringGetFirst:cell.lblTitle.text];
                    else
                        _selectedCategory = nil;
                
                    [sharedFacetHandler setCategorySelectionWithCategoryString:_selectedCategory];
                }
                
                else {
                    if (cell.accessoryType == 3)
                        _selectedPrice = [self breakStringGetFirst:cell.lblTitle.text];
                    
                    else
                        _selectedPrice = nil;
                    
                    [sharedFacetHandler setPriceSelectionWithPriceString:_selectedPrice];
                }
            }
            else {
                _selectSortString = cell.lblTitle.text;
                [sharedFacetHandler setSortChosenOptionString:_selectSortString]; // Sort selection
            }
            [_tableFilterSelection reloadData];
        }
    }
}


- (void)loadDataWithSelectedSortType:(NSString*)title {
    
    [self.totalSelectedArray removeAllObjects];//Remove all objects any way we are adding at bottom
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if ([title isEqualToString:SORT_TITLE]) {
        _isMultiSelect = NO;
        [self.optionsArray setArray:[sharedFacetHandler getSortOptionStringsArray]];
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
            
            if ([sharedFacetHandler getSelectedBrandsArray])
                [self.totalSelectedArray addObjectsFromArray:[sharedFacetHandler getSelectedBrandsArray]];
            
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
            
            if ([sharedFacetHandler getSelectedColorsArray])
                [self.totalSelectedArray addObjectsFromArray:[sharedFacetHandler getSelectedColorsArray]];
            
        } else {
            _selectedSortIndex = 0;
        }
    }
    else if ([title isEqualToString:SIZE_TITLE]) {
        _isMultiSelect = YES;
        if ([[sharedFacetHandler getSizeFiltersForDisplay] count] != 0) {
            [self.optionsArray setArray:[sharedFacetHandler getSizeFiltersForDisplay]];
            
            if ([sharedFacetHandler getSelectedSizesArray])
                [self.totalSelectedArray addObjectsFromArray:[sharedFacetHandler getSelectedSizesArray]];
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
    
    
    
    NSLog(@"%@ : %@",title,self.totalSelectedArray);
    
    if ([[self optionsArray]count] == 0) // if problem with backend data
        [self performSegueWithIdentifier:@"unwindFromRefineResultsCleared" sender:self];
    
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
    if (_multipleOrSingleSelectOrDeselect == YES) {
        [self addViewWithLoader];
        [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                      withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]
                               success:^(NSDictionary *responseDictionary) {
                                   [self removeViewWithLoader];
                               }
                               failure:^(NSError *error) {
                                   [self removeViewWithLoader];
                                   [BTRViewUtility showAlert:nil msg:@"Unabel to get the Data Please try again"];
                                   return;
                               }];
    }
    
    [self addViewWithLoader];

    NSString *facetString = [sharedFacetHandler getFacetStringForRESTfulRequest];
    NSString *sortString = [sharedFacetHandler getSortStringForRESTfulRequest];
    NSLog(@"FACET : %@",facetString);
    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                    withSortString:sortString
                  withFacetsString:facetString
                           success:^(NSDictionary *responseDictionary) {
                             [self removeViewWithLoader];
                             if ([self.delegate respondsToSelector:@selector(refineSceneWillDisappearWithResponseDictionary:)]) {
                                 [self.delegate refineSceneWillDisappearWithResponseDictionary:responseDictionary];
                             }
                             [self performSegueWithIdentifier:@"unwindFromRefineResultsApplied" sender:self];
                         }
                           failure:^(NSError *error) {
                             [self removeViewWithLoader];
                            [BTRViewUtility showAlert:nil msg:@"Unabel to get the Data Please try again"];
                         }];
}


- (IBAction)clearTapped:(UIButton *)sender {
    UIAlertView * showAlert = [[UIAlertView alloc]initWithTitle:@"Clear Filters" message:@"Are you sure you want clear all filters you applied" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"YES", nil];
    showAlert.tag = 555;
    [showAlert show];
}

- (IBAction)closeTapped:(UIButton *)sender {
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

- (void)setMultipleArraysIfObjectRemoved:(NSString*)removesObject {
    NSLog(@"%@",removesObject);
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    NSMutableArray * getSelectedBrand = [sharedFacetHandler getSelectedBrandsArray];
    if ([getSelectedBrand containsObject:removesObject])
        [getSelectedBrand removeObject:removesObject];
    [sharedFacetHandler setSelectedBrandsWithArray:getSelectedBrand];
    
    
    NSMutableArray * getSelectedColor = [sharedFacetHandler getSelectedColorsArray];
    if ([getSelectedColor containsObject:removesObject])
        [getSelectedColor removeObject:removesObject];
    [sharedFacetHandler setSelectedColorsWithArray:getSelectedColor];
    
    
    NSMutableArray * getSelectedSizes = [sharedFacetHandler getSelectedSizesArray];
    if ([getSelectedSizes containsObject:removesObject])
        [getSelectedSizes removeObject:removesObject];
    [sharedFacetHandler setSelectedSizesWithArray:getSelectedSizes];
}



// We should allow user to perform only one operation
- (void)addViewWithLoader {
    UIView * loadView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70)];
    loadView.tag = 555;
    loadView.backgroundColor = [UIColor clearColor];
    [BTRLoader showLoaderInView:loadView];
    [self.view addSubview:loadView];
}

- (void)removeViewWithLoader {
    [BTRLoader hideLoaderFromView:[self.view viewWithTag:555]];
    //When ever we change the Orientation we remove and readd the CollectionView
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag == 555) {
            [v removeFromSuperview];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 555) {
        if (buttonIndex == 1) {
            BTRFacetsHandler * sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
            
            [self.titles removeAllObjects];
            [self.titles addObjectsFromArray:@[SORT_TITLE,CATEGORY_TITLE,PRICE_TITLE, BRAND_TITLE, COLOR_TITLE, SIZE_TITLE]];
            _selectedSortIndex = 0;
            
            _selectedCategory = nil;
            _selectedPrice = nil;
            _selectSortString = BEST_MATCH;
            [sharedFacetHandler setCategorySelectionWithCategoryString:_selectedCategory];
            [sharedFacetHandler setPriceSelectionWithPriceString:_selectedPrice];
            [sharedFacetHandler setSortChosenOptionString:_selectSortString];
            [sharedFacetHandler resetFacets];
            [self addViewWithLoader];
            [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                          withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]
                                   success:^(NSDictionary *responseDictionary) {
                                       [self removeViewWithLoader];
                                       [self loadDataWithSelectedSortType:self.titles[0]];
                                   }
                                   failure:^(NSError *error) {
                                       [self removeViewWithLoader];
                                       [BTRViewUtility showAlert:nil msg:@"Unabel to clear the filters"];
                                       return;
                                   }];
            
        } else {
            
        }
    }
}

@end



















