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
    NSString * getPreviousSelectedSortType;
}
@property (weak, nonatomic) IBOutlet UITableView *tableFilterType;
@property (weak, nonatomic) IBOutlet UITableView *tableFilterSelection;
@property (strong, nonatomic) NSMutableArray *titles;

@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *selectedOptionsArray;

@property NSIndexPath * selectedIndexPath;

@property NSInteger numberOfSections;

@property (nonatomic) BOOL isMultiSelect;

@end


@implementation BTRRefineResultsViewController

@synthesize backgroundImage;

- (NSMutableArray *)optionsArray {
    if (!_optionsArray) _optionsArray = [[NSMutableArray alloc] init];
    return _optionsArray;
}

- (NSMutableArray *)selectedOptionsArray {
    if (!_selectedOptionsArray) _selectedOptionsArray = [[NSMutableArray alloc] init];
    return _selectedOptionsArray;
}

- (void)initOptionsArray {
    
    [self.titles addObjectsFromArray:@[CATEGORY_TITLE,PRICE_TITLE, BRAND_TITLE, COLOR_TITLE, SIZE_TITLE]];
    
    //For testing make it temporarily
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    [sharedFacetHandler setSortChosenOptionString:@"Best Match"];
    
    
    // Here we need to set only one array so we use ELSE IF Condition
    if ([[sharedFacetHandler getCategoryFiltersForDisplay] count] != 0) {
        _isMultiSelect = NO;
        getPreviousSelectedSortType = CATEGORY_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getCategoryFiltersForDisplay]];
    }
    else if ([[sharedFacetHandler getPriceFiltersForDisplay] count] != 0) {
        _isMultiSelect = NO;
        getPreviousSelectedSortType = PRICE_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getPriceFiltersForDisplay]];
    }
    else if ([[sharedFacetHandler getBrandFiltersForDisplay] count] != 0) {
        _isMultiSelect = YES;
        getPreviousSelectedSortType = BRAND_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getBrandFiltersForDisplay]];
    }
    else if ([[sharedFacetHandler getColorFiltersForDisplay] count] != 0) {
        _isMultiSelect = YES;
        getPreviousSelectedSortType = COLOR_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getColorFiltersForDisplay]];
    }
    else if ([[sharedFacetHandler getSizeFiltersForDisplay] count] != 0) {
        _isMultiSelect = YES;
        getPreviousSelectedSortType = SIZE_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getSizeFiltersForDisplay]];
    }
    
    
    if (sharedFacetHandler.getCategoryFiltersForDisplay.count == 0) {
        [self.titles removeObject:CATEGORY_TITLE];
    }
    if (sharedFacetHandler.getPriceFiltersForDisplay.count == 0) {
        [self.titles removeObject:PRICE_TITLE];
    }
    if (sharedFacetHandler.getBrandFiltersForDisplay.count == 0) {
        [self.titles removeObject:BRAND_TITLE];
    }
    if (sharedFacetHandler.getColorFiltersForDisplay.count == 0) {
        [self.titles removeObject:COLOR_TITLE];
    }
    if (sharedFacetHandler.getSizeFiltersForDisplay.count == 0) {
        [self.titles removeObject:SIZE_TITLE];
    }
    
    
    if (self.titles.count != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableFilterType selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        _selectedIndexPath = indexPath;
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = [[NSMutableArray alloc]init];
    self.optionsArray = [[NSMutableArray alloc]init];
    self.selectedOptionsArray = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initOptionsArray];
    
    _tableFilterSelection.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 11)
        return self.titles.count;
    return self.optionsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 11) {
        static NSString *cellIdentifier = @"filterType";
        FilterTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[FilterTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.lblTitle.text = self.titles[indexPath.row];
        if (_selectedIndexPath == indexPath) {
            cell.lblTitle.backgroundColor = [UIColor lightGrayColor];
            cell.lblTitle.textColor = [UIColor whiteColor];
        } else {
            cell.lblTitle.backgroundColor = [UIColor clearColor];
            cell.lblTitle.textColor = [UIColor darkGrayColor];
        }
        return cell;
    }
    
    else {
        //// Better to show two sections one is for selected one other is for non selected one so if selected one is empty make it number of sections  to 1 else to 2
        
        
        static NSString *cellIdentifier = @"filterSelection";
        FilterSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[FilterSelectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        
        if ([self isOptionSelected:[self.optionsArray objectAtIndex:indexPath.row]] >= 0){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.lblTitle.text = self.optionsArray[indexPath.row];
        return cell;
    }
    
    return nil;
}

- (int)isOptionSelected:(NSString *)optionString {
    if ([self.selectedOptionsArray count] == 0)
        return -1;
    
    for(NSString *item in  self.selectedOptionsArray) {
        if([optionString isEqualToString:item]) {
            return 1;
            break;
        }
    }
    return -1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 11) {
        
        FilterTypeCell * cell = (FilterTypeCell*)[tableView cellForRowAtIndexPath:indexPath];
        //// When every Sort type is changing we have to call the server and have to update the data so after we have to call the below method for updating the table
        
        
        NSLog(@"%@",[self facetsQueryString:getPreviousSelectedSortType]);
        
        
        [BTRLoader showLoaderInView:self.view];
        BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
        [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                      withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]                               success:^(NSDictionary *responseDictionary) {
                          [self loadDataWithSelectedSortType:cell.lblTitle.text];
                          _selectedIndexPath = indexPath;
                          
                          getPreviousSelectedSortType = cell.lblTitle.text;
                          [self.selectedOptionsArray removeAllObjects];
                          
                          [BTRLoader hideLoaderFromView:self.view];
                      } failure:^(NSError *error) {
                          [BTRLoader hideLoaderFromView:self.view];
                      }];
        
    }
    else {
        FilterSelectionCell *cell = (FilterSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (_isMultiSelect) {
            
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.selectedOptionsArray addObject:[[cell lblTitle] text]];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self.selectedOptionsArray removeObject:[[cell lblTitle] text]];
            }
        } else if (![self isMultiSelect]){
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            [self.selectedOptionsArray removeLastObject];
            [self.selectedOptionsArray addObject:cell.lblTitle.text];
            [_tableFilterSelection reloadData];
        }
       
    }
   
}

-(void)loadDataWithSelectedSortType:(NSString*)title {
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if ([title isEqualToString:CATEGORY_TITLE]) {
        _isMultiSelect = NO;
        getPreviousSelectedSortType = CATEGORY_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getCategoryFiltersForDisplay]];
    }
    
    
    else if ([title isEqualToString:PRICE_TITLE]) {
        _isMultiSelect = NO;
        getPreviousSelectedSortType = PRICE_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getPriceFiltersForDisplay]];
    }
    
    
    else if ([title isEqualToString:BRAND_TITLE]) {
        _isMultiSelect = YES;
        getPreviousSelectedSortType = BRAND_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getBrandFiltersForDisplay]];
    }
    
    
    else if ([title isEqualToString:COLOR_TITLE]) {
        _isMultiSelect = YES;
        getPreviousSelectedSortType = COLOR_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getColorFiltersForDisplay]];
    }
    
    
    else if ([title isEqualToString:SIZE_TITLE]) {
        _isMultiSelect = YES;
        getPreviousSelectedSortType = SIZE_TITLE;
        [self.optionsArray setArray:[sharedFacetHandler getSizeFiltersForDisplay]];
    }

    
    [_tableFilterSelection reloadData];
    
    if (sharedFacetHandler.getCategoryFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:CATEGORY_TITLE];
    }
    else if (sharedFacetHandler.getPriceFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:PRICE_TITLE];
    }
    else if (sharedFacetHandler.getBrandFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:BRAND_TITLE];
    }
    else  if (sharedFacetHandler.getColorFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:COLOR_TITLE];
    }
    else if (sharedFacetHandler.getSizeFiltersForDisplay.count == 0) {
        if ([self.titles containsObject:title])
            [self.titles removeObject:SIZE_TITLE];
    }
    
    
    
    [_tableFilterType reloadData];
    
    
}




- (NSString *)facetsQueryString:(NSString *)title {
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    if ([[self selectedOptionsArray] count] != 0) {
        if ([title isEqualToString:PRICE_TITLE])
            [sharedFacetHandler setPriceSelectionWithPriceString:[self.selectedOptionsArray objectAtIndex:0]];
        
        if ([title isEqualToString:CATEGORY_TITLE])
            [sharedFacetHandler setCategorySelectionWithCategoryString:[self.selectedOptionsArray objectAtIndex:0]];
        
        if ([title isEqualToString:BRAND_TITLE])
            [sharedFacetHandler setSelectedBrandsWithArray:[self selectedOptionsArray]];
        
        if ([title isEqualToString:COLOR_TITLE])
            [sharedFacetHandler setSelectedColorsWithArray:[self selectedOptionsArray]];
        
        if ([title isEqualToString:SIZE_TITLE])
            [sharedFacetHandler setSelectedSizesWithArray:[self selectedOptionsArray]];
    }
    return [sharedFacetHandler getFacetStringForRESTfulRequest];
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

#pragma mark - Navigation

- (IBAction)clearTapped:(UIButton *)sender {
    BTRFacetsHandler * sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    [sharedFacetHandler resetFacets];
    [self.titles removeAllObjects];
//    [self.titles addObjectsFromArray:@[CATEGORY_TITLE,PRICE_TITLE, BRAND_TITLE, COLOR_TITLE, SIZE_TITLE]];
//     [self loadDataWithSelectedSortType:self.titles[0]];
    [self performSegueWithIdentifier:@"unwindFromRefineResultsCleared" sender:self];
}

- (IBAction)applyButtonTapped:(UIButton *)sender {
    
    //if user comes and select some row and with out changing the sort section if he click the APPLY Button we should call the below method
    [BTRLoader showLoaderInView:self.view];
    BTRFacetsHandler *sharedFacetHandler1 = [BTRFacetsHandler sharedFacetHandler];
    [self fetchItemsforSearchQuery:[sharedFacetHandler1 searchString]
                  withFacetsString:[self facetsQueryString:getPreviousSelectedSortType]                               success:^(NSDictionary *responseDictionary) {
                      [BTRLoader hideLoaderFromView:self.view];
                  } failure:^(NSError *error) {
                      [BTRLoader hideLoaderFromView:self.view];
                  }];

    [BTRLoader showLoaderInView:self.view];
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
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
                         } failure:^(NSError *error) {
                             [BTRLoader hideLoaderFromView:self.view];
                         }];
    
}

@end



















