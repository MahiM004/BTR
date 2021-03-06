//
//  BTRModalFilterSelectionVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRModalFilterSelectionVC.h"
#import "Item+AppServer.h"
#import "BTRItemFetcher.h"
#import "BTRFacetsHandler.h"
#import "BTRSearchFilterTVC.h"
#import "BTRConnectionHelper.h"

@interface BTRModalFilterSelectionVC () {
    int selectedIndex;
}

@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *selectedOptionsArray;

@end

@implementation BTRModalFilterSelectionVC

- (NSMutableArray *)optionsArray {
    if (!_optionsArray) _optionsArray = [[NSMutableArray alloc] init];
    return _optionsArray;
}

- (NSMutableArray *)selectedOptionsArray {
    if (!_selectedOptionsArray) _selectedOptionsArray = [[NSMutableArray alloc] init];
    return _selectedOptionsArray;
}

- (void)initOptionsArray {
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    if ([self.headerTitle isEqualToString:PRICE_TITLE]) {
        if ([sharedFacetHandler getPriceFiltersForDisplay])
            [self.optionsArray setArray:[sharedFacetHandler getPriceFiltersForDisplay]];
        
        if ([sharedFacetHandler getSelectedPriceString])
            [self.selectedOptionsArray setObject:[sharedFacetHandler getSelectedPriceString] atIndexedSubscript:0];
    }
    
    if ([self.headerTitle isEqualToString:CATEGORY_TITLE]) {
        if ([sharedFacetHandler getCategoryFiltersForDisplay])
            [self.optionsArray setArray:[sharedFacetHandler getCategoryFiltersForDisplay]];
        
        if ([sharedFacetHandler getSelectedCategoryString] )
            [self.selectedOptionsArray setObject:[sharedFacetHandler getSelectedCategoryString] atIndexedSubscript:0];
    }
    
    if ([self.headerTitle isEqualToString:BRAND_TITLE]) {
        if ([sharedFacetHandler getBrandFiltersForDisplay])
            [self.optionsArray setArray:[sharedFacetHandler getBrandFiltersForDisplay]];
        
        if ([sharedFacetHandler getSelectedBrandsArray])
            [self.selectedOptionsArray setArray:[sharedFacetHandler getSelectedBrandsArray]];
    }
    
    if ([self.headerTitle isEqualToString:COLOR_TITLE]) {
        if ([sharedFacetHandler getColorFiltersForDisplay])
            [self.optionsArray setArray:[sharedFacetHandler getColorFiltersForDisplay]];
        
        if ([sharedFacetHandler getSelectedColorsArray])
            [self.selectedOptionsArray setArray:[sharedFacetHandler getSelectedColorsArray]];
    }
    
    if ([self.headerTitle isEqualToString:SIZE_TITLE]) {
        if ([sharedFacetHandler getSizeFiltersForDisplay])
            [self.optionsArray setArray:[sharedFacetHandler getSizeFiltersForDisplay]];
        
        if ([sharedFacetHandler getSelectedSizesArray])
            [self.selectedOptionsArray setArray:[sharedFacetHandler getSelectedSizesArray]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self initOptionsArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = -1;
    self.titleLabel.text = [NSString stringWithFormat:@"Select %@", [self headerTitle]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self optionsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ModalFilterSelectionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.optionsArray objectAtIndex:indexPath.row];
    
    if ([self isOptionSelected:[self.optionsArray objectAtIndex:indexPath.row]] >= 0){
        cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([self isMultiSelect]) {
    
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedOptionsArray addObject:[[cell textLabel] text]];
            
        } else {
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedOptionsArray removeObject:[[cell textLabel] text]];
        }
        
    } else if (![self isMultiSelect]) {
        selectedIndex = (int)indexPath.row;
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        [self.selectedOptionsArray removeLastObject];
        [self.selectedOptionsArray addObject:cell.textLabel.text];
        [self.tableView reloadData];
    }
}

#pragma mark - Load Results RESTful

- (void)fetchItemsforSearchQuery:(NSString *)searchQuery
              withFacetsString:(NSString *)facetsString
                       success:(void (^)(id  responseObject)) success
                       failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRItemFetcher URLforSearchQuery:searchQuery withSortString:@"" withFacetString:facetsString andPageNumber:1]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
        BTRFacetsHandler *sharedFacetsHandler = [BTRFacetsHandler sharedFacetHandler];
        [sharedFacetsHandler updateFacetsFromResponseDictionary:response];
        success(response);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Navigation

- (IBAction)clearTapped:(UIButton *)sender {
    /*
     clear filter selections and dismiss vc
     */
    if ([sender isKindOfClass:[UIButton class]]) {
        BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
        
        if ([self.headerTitle isEqualToString:PRICE_TITLE])
            [sharedFacetHandler clearPriceSelection];
        
        if ([self.headerTitle isEqualToString:CATEGORY_TITLE])
            [sharedFacetHandler clearCategoryString];
        
        if ([self.headerTitle isEqualToString:BRAND_TITLE])
            [sharedFacetHandler clearBrandSelection];
        
        if ([self.headerTitle isEqualToString:COLOR_TITLE])
            [sharedFacetHandler clearColorSelection];
        
        if ([self.headerTitle isEqualToString:SIZE_TITLE])
            [sharedFacetHandler clearSizeSelection];
        
        [self.selectedOptionsArray removeAllObjects];
        
        [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                    withFacetsString:[sharedFacetHandler getFacetStringForRESTfulRequest]
                             success:^(NSDictionary *responseDictionary) {
                                 [self performSegueWithIdentifier:@"unwindToBTRSearchFilterTVC" sender:self];
                             } failure:^(NSError *error) {
                                 
                             }];
    }
}

- (IBAction)selectTapped:(UIButton *)sender {
    /*
     
     perform the search REST query with chosen facets and pass back the new filters and the query result
    
     */
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    [self fetchItemsforSearchQuery:[sharedFacetHandler searchString]
                withFacetsString:[self facetsQueryString]
                         success:^(NSDictionary *responseDictionary) {
                             [self dismissViewControllerAnimated:YES completion:NULL];
                         } failure:^(NSError *error) {
                             
                         }];
}

- (NSString *)facetsQueryString {
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    if ([[self selectedOptionsArray] count] != 0) {
        if ([self.headerTitle isEqualToString:PRICE_TITLE])
            [sharedFacetHandler setPriceSelectionWithPriceString:[self.selectedOptionsArray objectAtIndex:0]];
        
        if ([self.headerTitle isEqualToString:CATEGORY_TITLE])
            [sharedFacetHandler setCategorySelectionWithCategoryString:[self.selectedOptionsArray objectAtIndex:0]];
        
        if ([self.headerTitle isEqualToString:BRAND_TITLE])
            [sharedFacetHandler setSelectedBrandsWithArray:[self selectedOptionsArray]];
        
        if ([self.headerTitle isEqualToString:COLOR_TITLE])
            [sharedFacetHandler setSelectedColorsWithArray:[self selectedOptionsArray]];
        
        if ([self.headerTitle isEqualToString:SIZE_TITLE])
            [sharedFacetHandler setSelectedSizesWithArray:[self selectedOptionsArray]];
    }
    return [sharedFacetHandler getFacetStringForRESTfulRequest];
}

@end












