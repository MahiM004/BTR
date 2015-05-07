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


@interface BTRSearchFilterTVC ()


@property (strong, nonatomic) NSMutableArray *selectedBrands;
@property (strong, nonatomic) NSMutableArray *selectedColors;
@property (strong, nonatomic) NSMutableArray *selectedSizes;
@property (strong, nonatomic) NSMutableArray *selectedCategories;
@property (strong, nonatomic) NSMutableArray *selectedPrices;

@property (nonatomic) int selectedSortIndex;

@property (strong, nonatomic) NSMutableArray *titles;


@end

@implementation BTRSearchFilterTVC

@synthesize selectedSortIndex;

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



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    [self.selectedPrices removeAllObjects];
    [self.selectedCategories removeAllObjects];
    [self.selectedBrands removeAllObjects];
    [self.selectedColors removeAllObjects];
    [self.selectedSizes removeAllObjects];
    
    if ([sharedFacetHandler getSelectedPriceString] && ![[sharedFacetHandler getSelectedPriceString] isEqualToString:@""])
        [self.selectedPrices addObject:[sharedFacetHandler getSelectedPriceString]];
    
    if ([sharedFacetHandler getSelectedCategoryString] && ![[sharedFacetHandler getSelectedCategoryString] isEqualToString:@""])
        [self.selectedCategories addObject:[sharedFacetHandler getSelectedCategoryString]];
    
    
    if ([sharedFacetHandler getSelectedBrandsArray])
        [self.selectedBrands setArray:[sharedFacetHandler getSelectedBrandsArray]];
    
    if ([sharedFacetHandler getSelectedColorsArray])
        [self.selectedColors setArray:[sharedFacetHandler getSelectedColorsArray]];
    
    if ([sharedFacetHandler getSelectedSizesArray])
        [self.selectedSizes setArray:[sharedFacetHandler getSelectedSizesArray]];
    
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if ([[sharedFacetHandler getSelectedSortString] isEqualToString:BEST_MATCH])
        selectedSortIndex = 0;
    else if ([[sharedFacetHandler getSelectedSortString] isEqualToString:HIGHEST_TO_LOWEST])
        selectedSortIndex = 1;
    else if ([[sharedFacetHandler getSelectedSortString] isEqualToString:LOWEST_TO_HIGHEST])
        selectedSortIndex = 2;
        
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
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if (indexPath.section == SORT_SECTION) {
        
        selectedSortIndex = (int)indexPath.row;
        UITableViewCell *sortCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (sortCell.textLabel.textColor != [UIColor whiteColor]) {
            
            sortCell.textLabel.textColor = [UIColor whiteColor];
            sortCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [sharedFacetHandler setSortChosenOptionString:[[sortCell textLabel] text]];
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
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    cell.textLabel.text = [sharedFacetHandler getSortTypeForIndex:indexPath.row];
    
    return  cell;
    
}

- (UITableViewCell *)configureFilterModalCell:(BTRFilterWithModalTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    BTRFacetsHandler *sharedFacetHandler = [BTRFacetsHandler sharedFacetHandler];
    
    if (indexPath.section == BRAND_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:BRAND_TITLE
                       withSelectionArray:[self selectedBrands]
                                withIndex:indexPath.row
                          isSelectable:[sharedFacetHandler.getBrandFiltersForDisplay count] > 0 ? YES: NO];
        
    } else if (indexPath.section == COLOR_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:COLOR_TITLE
                       withSelectionArray:[self selectedColors]
                                withIndex:indexPath.row
                          isSelectable:[sharedFacetHandler.getColorFiltersForDisplay count] > 0 ? YES: NO];
        
    } else if (indexPath.section == SIZE_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:SIZE_TITLE
                       withSelectionArray:[self selectedSizes]
                                withIndex:indexPath.row
                          isSelectable:[sharedFacetHandler.getSizeFiltersForDisplay count] > 0 ? YES: NO];

    } else if (indexPath.section == CATEGORY_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:CATEGORY_TITLE
                       withSelectionArray:[self selectedCategories]
                                withIndex:indexPath.row
                          isSelectable:[sharedFacetHandler.getCategoryFiltersForDisplay count] &&
                ![sharedFacetHandler hasChosenFacetExceptCategories] > 0 ? YES: NO];
        
    } else if (indexPath.section == PRICE_FILTER) {
        
        cell = [self configureCellForCell:cell
                        withSectionString:PRICE_TITLE
                       withSelectionArray:[self selectedPrices]
                                withIndex:indexPath.row
                          isSelectable:[sharedFacetHandler.getPriceFiltersForDisplay count] > 0 ? YES: NO];
    }
    

    return cell;
}


- (BTRFilterWithModalTableViewCell *)configureCellForCell:(BTRFilterWithModalTableViewCell *)cell withSectionString:(NSString *)sectionString withSelectionArray:(NSArray *)selectionArray withIndex:(NSUInteger)index isSelectable:(BOOL)isSelectable {
    
    cell.rowLabel.textColor = [UIColor colorWithWhite:255.0/255.0 alpha:1.0];
    cell.rowButton.enabled = TRUE;
    
    if (isSelectable) {
        
        if ([selectionArray count] == 0) {
            cell.rowLabel.text = [NSString stringWithFormat:@"All %@s", sectionString];
        }
        else {
            cell.rowLabel.text = [selectionArray objectAtIndex:index];
        }
        
    } else if (!isSelectable) {
        
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
                
                destModalVC.headerTitle = BRAND_TITLE;
                destModalVC.isMultiSelect = YES;
            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:COLOR_TITLE]) {
             
                destModalVC.headerTitle = COLOR_TITLE;
                destModalVC.isMultiSelect = YES;

            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:SIZE_TITLE]) {
                
                destModalVC.headerTitle = SIZE_TITLE;
                destModalVC.isMultiSelect = YES;
            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:CATEGORY_TITLE]) {
                
                destModalVC.headerTitle = CATEGORY_TITLE;
                destModalVC.isMultiSelect = NO;
            }
            else if ([[[(UIButton *)sender titleLabel] text] isEqualToString:PRICE_TITLE]) {
                
                destModalVC.headerTitle = PRICE_TITLE;
                destModalVC.isMultiSelect = NO;
            }
            
        }
    }
}


- (IBAction)unwindToBTRSearchFilterTVC:(UIStoryboardSegue *)unwindSegue {
 

    [self.tableView reloadData];
}






@end



























