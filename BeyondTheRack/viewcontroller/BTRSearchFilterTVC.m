//
//  BTRSearchFilterTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchFilterTVC.h"
#import "BTRModalFilterSelectionVC.h"

#import "BTRFilterWithModalTableViewCell.h"


#import "BTRFacetsHandler.h"


@interface BTRSearchFilterTVC () <BTRModalFilterSelectionDelegate> {
    int selectedSortIndex;
}

@property (strong, nonatomic) NSMutableArray *titles;


@end

@implementation BTRSearchFilterTVC

- (NSMutableArray *)selectedBrands {
    
    if (!_selectedBrands) _selectedBrands = [[NSMutableArray alloc] init];
    return _selectedBrands;
}

- (NSMutableArray *)selectedColors {
    
    if (!_selectedColors) _selectedColors = [[NSMutableArray alloc] init];
    return _selectedColors;
}

- (NSMutableArray *)selectedSizes {
    
    if (!_selectedSizes) _selectedSizes = [[NSMutableArray alloc] init];
    return _selectedSizes;
}

- (NSMutableArray *)selectedCategories {
    
    if (!_selectedCategories) _selectedCategories = [[NSMutableArray alloc] init];
    return _selectedCategories;
}



- (NSMutableArray *)selectedPrices {
    
    if (!_selectedPrices) _selectedPrices = [[NSMutableArray alloc] init];
    return _selectedPrices;
}


- (NSMutableArray *)queryRefineArray {
    
    if (!_queryRefineArray) _queryRefineArray = [[NSMutableArray alloc] init];
    return _queryRefineArray;
}

- (NSMutableArray *)colorsArray {
    
    if (!_colorsArray) _colorsArray = [[NSMutableArray alloc] init];
    return _colorsArray;
}

- (NSMutableArray *)brandsArray {
    
    if (!_brandsArray) _brandsArray = [[NSMutableArray alloc] init];
    return _brandsArray;
}

- (NSMutableArray *)sizesArray {
    
    if (!_sizesArray) _sizesArray = [[NSMutableArray alloc] init];
    return _sizesArray;
}


- (NSMutableArray *)categoriesArray {
    
    if (!_categoriesArray) _categoriesArray = [[NSMutableArray alloc] init];
    return _categoriesArray;
}


- (NSMutableArray *)pricesArray {
    
    if (!_pricesArray) _pricesArray = [[NSMutableArray alloc] init];
    return _pricesArray;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];

    selectedSortIndex = 0;
    self.titles = [[NSMutableArray alloc] initWithArray:@[@"SORT ITEMS", PRICE_TITLE, CATEGORY_TITLE, BRAND_TITLE, COLOR_TITLE, SIZE_TITLE]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    // Return the number of sections.
    return 6;
;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == SORT_SECTION)
        return 3;
    
    else if (section == PRICE_FILTER) {
        
        if ([self.selectedPrices count] != 0)
            return [self.selectedPrices count];
        
    } else if (section == CATEGORY_FILTER) {
        
        if ([self.selectedCategories count] != 0)
            return [self.selectedCategories count];
        
    } else if (section == BRAND_FILTER) {
        
        if ([self.selectedBrands count] != 0)
            return [self.selectedBrands count];
        
    } else if (section == COLOR_FILTER) {
        
        if ([self.selectedColors count] != 0)
            return [self.selectedColors count];

    }
    else if (section == SIZE_FILTER) {
        if ([self.selectedSizes count] != 0)
            return [self.selectedSizes count];
    }

    return 1;

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == SORT_SECTION)
        return [NSString stringWithFormat:@"        %@", [self.titles objectAtIndex:section]];
    return [NSString stringWithFormat:@"        FILTER BY %@", [self.titles objectAtIndex:section]];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor blueColor];
    
    UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
    [headerIndexText.textLabel setTextColor:[UIColor colorWithWhite:0 alpha:0.8]];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SORT_SECTION) {
     
        selectedSortIndex = (int)indexPath.row;

        UITableViewCell *sortCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (sortCell.textLabel.textColor != [UIColor whiteColor]) {
            
            sortCell.textLabel.textColor = [UIColor whiteColor];
            sortCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == SORT_SECTION) {
        
        UITableViewCell *sortCell = [tableView dequeueReusableCellWithIdentifier:@"BTRRefineSortCellIdentifier" forIndexPath:indexPath];
        
        if (sortCell == nil)
        {
            sortCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRRefineSortCellIdentifier"];
        }
        
        return  [self configureSortCell:sortCell forIndexPath:indexPath];

    }

    else if (indexPath.section != SORT_SECTION) {
    
        BTRFilterWithModalTableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterByModalCellIdentifier" forIndexPath:indexPath];
        
        if (filterCell == nil) {
            
            filterCell = [[BTRFilterWithModalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterByModalCellIdentifier"];
        }
        
        cell = [self configureFilterModalCell:filterCell forIndexPath:indexPath];
    }

    return cell;
}


- (UITableViewCell *)configureSortCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedSortIndex != indexPath.row) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
    } else if (selectedSortIndex == indexPath.row) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = [BTRFacetsHandler getSortTypeForIndex:indexPath.row];
    
    return  cell;
    
}





- (UITableViewCell *)configureFilterModalCell:(BTRFilterWithModalTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == BRAND_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:BRAND_TITLE
                       withSelectionArray:[self selectedBrands]
                                withIndex:indexPath.row
                          selectionExists:[self.brandsArray count] > 0 ? YES: NO];
        
    } else if (indexPath.section == COLOR_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:COLOR_TITLE
                       withSelectionArray:[self selectedColors]
                                withIndex:indexPath.row
                          selectionExists:[self.colorsArray count] > 0 ? YES: NO];
        
    } else if (indexPath.section == SIZE_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:SIZE_TITLE
                       withSelectionArray:[self selectedSizes]
                                withIndex:indexPath.row
                          selectionExists:[self.sizesArray count] > 0 ? YES: NO];

    } else if (indexPath.section == CATEGORY_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:CATEGORY_TITLE
                       withSelectionArray:[self selectedCategories]
                                withIndex:indexPath.row
                          selectionExists:[self.categoriesArray count] > 0 ? YES: NO];
        
    } else if (indexPath.section == PRICE_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:PRICE_TITLE
                       withSelectionArray:[self selectedPrices]
                                withIndex:indexPath.row
                          selectionExists:[self.pricesArray count] > 0 ? YES: NO];
    }
    

    return cell;
}


- (BTRFilterWithModalTableViewCell *)configureCellForCell:(BTRFilterWithModalTableViewCell *)cell withSectionString:(NSString *)sectionString withSelectionArray:(NSArray *)selectionArray withIndex:(NSUInteger)index selectionExists:(BOOL)selectionExists {
    
    
    cell.rowLabel.textColor = [UIColor colorWithWhite:255.0/255.0 alpha:1.0];
    cell.rowButton.enabled = TRUE;
    
    if (selectionExists) {
        
        if ([selectionArray count] == 0) {
            cell.rowLabel.text = [NSString stringWithFormat:@"All %@s", sectionString];
        }
        else {
            cell.rowLabel.text = [selectionArray objectAtIndex:index];
        }
        
    } else if (!selectionExists) {
        
        cell.rowLabel.text = [NSString stringWithFormat:@"No %@ Selection Available", sectionString];
        cell.rowLabel.textColor = [UIColor lightGrayColor];
        cell.rowButton.enabled = FALSE;
    }
    
    cell.rowButton.titleLabel.text = sectionString;
    cell.rowButton.titleLabel.textColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor colorWithWhite:255.0/255.0 alpha:1.0];

    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   
    if([sender isKindOfClass:[UIButton class]]) {

        if ([segue.identifier isEqualToString:@"ModalSelectionSegueIdentifier"]) {
            
            BTRModalFilterSelectionVC *destModalVC = [segue destinationViewController];
        
            if ([[[(UIButton *)sender titleLabel] text] isEqualToString:BRAND_TITLE]) {
                
                [self prepareModalVC:destModalVC withItemsArray:[self brandsArray] withSelectedItemsArray:[self selectedBrands] andTitle:BRAND_TITLE];
                destModalVC.isMultiSelect = YES;
            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:COLOR_TITLE]) {
             
                [self prepareModalVC:destModalVC withItemsArray:[self colorsArray] withSelectedItemsArray:[self selectedColors] andTitle:COLOR_TITLE];
                destModalVC.isMultiSelect = YES;

            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:SIZE_TITLE]) {
                
                [self prepareModalVC:destModalVC withItemsArray:[self sizesArray] withSelectedItemsArray:[self selectedSizes] andTitle:SIZE_TITLE];
                destModalVC.isMultiSelect = YES;
            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:CATEGORY_TITLE]) {
                
                [self prepareModalVC:destModalVC withItemsArray:[self categoriesArray] withSelectedItemsArray:[self selectedCategories] andTitle:CATEGORY_TITLE];
                destModalVC.isMultiSelect = NO;
            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:PRICE_TITLE]) {
                
                [self prepareModalVC:destModalVC withItemsArray:[self pricesArray] withSelectedItemsArray:[self selectedPrices] andTitle:PRICE_TITLE];
                destModalVC.isMultiSelect = NO;
            }
        
            destModalVC.modalDelegate = self;
        }
    }
    
    
}

- (BTRModalFilterSelectionVC *)prepareModalVC:(BTRModalFilterSelectionVC *)destModalVC withItemsArray:(NSMutableArray *)itemsArray withSelectedItemsArray:(NSMutableArray *)selectedItemArray andTitle:(NSString *)title {
    
    destModalVC.optionsArray = itemsArray;
    destModalVC.selectedOptionsArray = selectedItemArray;
    destModalVC.headerTitle = title;
    destModalVC.searchString = [self searchString];
    
    
    NSMutableArray *facetsArray = [[NSMutableArray alloc] init];
    [facetsArray addObject:[self selectedPrices]];
    [facetsArray addObject:[self selectedCategories]];
    [facetsArray addObject:[self selectedBrands]];
    [facetsArray addObject:[self selectedColors]];
    [facetsArray addObject:[self selectedSizes]];

    destModalVC.chosenFacetsArray = facetsArray;
    
    
    return destModalVC;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    self.queryRefineArray = [BTRFacetsHandler getFacetOptionsFromDisplaySelectedPrices:[self selectedPrices]
                                                                fromSelectedCategories:[self selectedCategories]
                                                                     fromSelectedBrand:[self selectedBrands]
                                                                    fromSelectedColors:[self selectedColors]
                                                                     fromSelectedSizes:[self selectedSizes]];
    
    
    if ([self.delegate respondsToSelector:@selector(searchFilterTableWillDisappearWithResponseDictionary:)]) {
        [self.delegate searchFilterTableWillDisappearWithResponseDictionary:[self responseDictionaryFromFacets]];
    }
    
}


- (IBAction)unwindToBTRSearchFilterTVC:(UIStoryboardSegue *)unwindSegue {
 
    [self.tableView reloadData];
}


#pragma mark - BTRModalFilterSelectionDelegate


- (void)modalFilterSelectionVCDidEnd:(NSMutableArray *)selectedItemsArray  withTitle:(NSString *)titleString withResponseDictionary:(NSDictionary *)responseDictionary{

    self.responseDictionaryFromFacets = responseDictionary;
    
    if ([titleString isEqualToString:BRAND_TITLE])
        self.selectedBrands = selectedItemsArray;
    else if ([titleString isEqualToString:COLOR_TITLE])
        self.selectedColors = selectedItemsArray;
    else if ([titleString isEqualToString:SIZE_TITLE])
        self.selectedSizes = selectedItemsArray;
    else if ([titleString isEqualToString:CATEGORY_TITLE])
        self.selectedCategories = selectedItemsArray;
    else if ([titleString isEqualToString:PRICE_TITLE])
        self.selectedPrices = selectedItemsArray;
   
    [self.tableView reloadData];
}



@end



























