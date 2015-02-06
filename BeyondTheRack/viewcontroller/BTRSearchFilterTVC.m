//
//  BTRSearchFilterTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchFilterTVC.h"
#import "BTRModalFilterSelectionVC.h"

#import "BTRFilterWithSwitchTableViewCell.h"
#import "BTRFilterWithModalTableViewCell.h"

#define SORT_SECTION 0
#define PRICE_FILTER 1
#define CATEGORY_FILTER 2
#define BRAND_FILTER 3
#define COLOR_FILTER 4
#define SIZE_FILTER 5


#define BRAND_TITLE @"Brand"
#define COLOR_TITLE @"Color"
#define SIZE_TITLE @"Size"

@interface BTRSearchFilterTVC () <BTRModalFilterSelectionDelegate> {
    int selectedSortIndex;
}

@property (strong, nonatomic) NSMutableArray *titles;


@end

@implementation BTRSearchFilterTVC

@synthesize selectedBrands;
@synthesize selectedColors;
@synthesize selectedSizes;

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



- (void)viewDidLoad {
    
    [super viewDidLoad];

    selectedSortIndex = 0;
    self.titles = [[NSMutableArray alloc] initWithArray:@[@"SORT ITEMS", @"FILTER BY PRICE", @"FILTER BY CATEGORY", @"FILTER BY BRANDS", @"FILTER BY COLORS", @"FILTER BY SIZES"]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    // Return the number of sections.
    return [self.titles count];//[self.facets count] + 1;
;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == SORT_SECTION)  // for SORT ITEMS
        
        return 3;
    
    else if (section == PRICE_FILTER) {
        
        if ([self.pricesArray count] != 0)
            return [self.pricesArray count];
        else
            return 1;
        
    } else if (section == CATEGORY_FILTER) {
        
        if ([self.categoriesArray count] != 0)
            return [self.categoriesArray count];
        else
            return 1;
        
    } else if (section == BRAND_FILTER) {
        
        if ([self.selectedBrands count] != 0)
            return [self.selectedBrands count];
        else
            return 1;
        
    } else if (section == COLOR_FILTER) {
        
        if ([self.selectedColors count] != 0)
            return [self.selectedColors count];
        else
            return 1;
        
    } else if (section == SIZE_FILTER) {
        
        if ([self.selectedSizes count] != 0)
            return [self.selectedSizes count];
        else
            return 1;
    }
    
    return 1;

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return [NSString stringWithFormat:@"        %@", [self.titles objectAtIndex:section]];
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
    
    if (indexPath.section == 0) {
        
        UITableViewCell *sortCell = [tableView dequeueReusableCellWithIdentifier:@"BTRRefineSortCellIdentifier" forIndexPath:indexPath];
        
        if (sortCell == nil)
        {
            sortCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRRefineSortCellIdentifier"];
        }
        
        cell = [self configureSortCell:sortCell forIndexPath:indexPath];

    } else if (indexPath.section == PRICE_FILTER || indexPath.section == CATEGORY_FILTER) {
    
        BTRFilterWithSwitchTableViewCell *filteSwitchrCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterBySwitchCellIdentifier" forIndexPath:indexPath];

        if (filteSwitchrCell == nil) {
            
            filteSwitchrCell = [[BTRFilterWithSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterBySwitchCellIdentifier"];
        }
        
        cell =  [self configureFilterSwitchCell:filteSwitchrCell forIndexPath:indexPath];
    
        
    } else if (indexPath.section == BRAND_FILTER || indexPath.section == COLOR_FILTER || indexPath.section == SIZE_FILTER) {
    
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
    
    switch (indexPath.row) {
            
        case 0:
            cell.textLabel.text = @"Best Match";
            break;
            
        case 1:
            cell.textLabel.text = @"Highest to Lowest Price";
            break;
            
            
        case 2:
            cell.textLabel.text = @"Lowest to Highest Price";
            break;
            
        default:
            break;
            
    }
    
    return  cell;
    
}

- (UITableViewCell *)configureFilterSwitchCell:(BTRFilterWithSwitchTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    cell.filterSwitch.enabled = TRUE;
    [cell.filterSwitch addTarget:self action:@selector(toggleCustomSwitch:) forControlEvents:UIControlEventValueChanged];
    
    
    if (indexPath.section == PRICE_FILTER) {
        
        if ([self.pricesArray count] == 0) {
            
            cell.filterValueLabel.text = [NSString stringWithFormat:@"No Price Selection Available"];
            cell.filterSwitch.enabled = FALSE;
            
        } else {
            cell.filterValueLabel.text = [self.pricesArray objectAtIndex:indexPath.row];
            cell.filterSwitch.stringValue = [self.pricesArray objectAtIndex:indexPath.row];
        }
        
        cell.filterSwitch.tag = PRICE_FILTER;
        
    } else if (indexPath.section == CATEGORY_FILTER) {
        
        if ([self.categoriesArray count] == 0) {
            
            cell.filterValueLabel.text = [NSString stringWithFormat:@"No Category Selection Available"];
            cell.filterSwitch.enabled = FALSE;
            
        } else {
            cell.filterValueLabel.text = [self.categoriesArray objectAtIndex:indexPath.row];
            cell.filterSwitch.stringValue = [self.categoriesArray objectAtIndex:indexPath.row];
        }
        
        cell.filterSwitch.tag = CATEGORY_FILTER;
    }
    
    return cell;
}


- (void)toggleCustomSwitch:(id)sender {
    
    BTRFilterSwitch *tempSwitch = (BTRFilterSwitch *)sender;
    
    if (tempSwitch.on) {

        NSLog(@"switched on: %@", [tempSwitch stringValue]);
    }
    
}

- (UITableViewCell *)configureFilterModalCell:(BTRFilterWithModalTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {

    
    cell.rowLabel.textColor = [UIColor colorWithWhite:255.0/255.0 alpha:1.0];
    cell.rowButton.enabled = TRUE;
    
    if (indexPath.section == BRAND_FILTER) {
        
        if ([self.brandsArray count] > 0) {
            
            if ([self.selectedBrands count] == 0) {
                cell.rowLabel.text = [NSString stringWithFormat:@"All Brands"];
            }
            else {
                cell.rowLabel.text = [self.selectedBrands objectAtIndex:indexPath.row];
            }
            
        } else if ([self.brandsArray count] == 0) {
            
            cell.rowLabel.text = [NSString stringWithFormat:@"No Brand Selection Available"];
            cell.rowLabel.textColor = [UIColor lightGrayColor];
            cell.rowButton.enabled = FALSE;
        }
        cell.rowButton.tag = BRAND_FILTER;
        
    } else if (indexPath.section == COLOR_FILTER) {
        
        if ([self.colorsArray count] > 0) {
            
            if ([self.selectedColors count] == 0) {
                cell.rowLabel.text = [NSString stringWithFormat:@"All Colors"];
            }
            else {
                
                cell.rowLabel.text = [self.selectedColors objectAtIndex:indexPath.row];
            }
            
        } else if ([self.colorsArray count] == 0) {
            
            cell.rowLabel.text = [NSString stringWithFormat:@"No Color Selection Available"];
            cell.rowLabel.textColor = [UIColor lightGrayColor];
            cell.rowButton.enabled = FALSE;
        }
        
        cell.rowButton.tag = COLOR_FILTER;
        
    } else if (indexPath.section == SIZE_FILTER) {
        
        if ([self.sizesArray count] > 0) {
            
            if ([self.selectedSizes count] == 0) {
                
                cell.rowLabel.text = [NSString stringWithFormat:@"All Sizes"];
            }
            else {
                
                cell.rowLabel.text = [self.selectedSizes objectAtIndex:indexPath.row];
            }
            
        } else if([self.sizesArray count] == 0) {
            
            cell.rowLabel.text = [NSString stringWithFormat:@"No Size Selection Available"];
            cell.rowLabel.textColor = [UIColor lightGrayColor];
            cell.rowButton.enabled = FALSE;
        }
        
        cell.rowButton.tag = SIZE_FILTER;
    }
    
    
    cell.textLabel.textColor = [UIColor colorWithWhite:255.0/255.0 alpha:1.0];


    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   
    if([sender isKindOfClass:[UIButton class]]) {

        if ([segue.identifier isEqualToString:@"ModalSelectionSegueIdentifier"]) {
            
            BTRModalFilterSelectionVC *destModalVC = [segue destinationViewController];
        
            if ([(UIButton *)sender tag] == BRAND_FILTER ) {
                
                destModalVC.itemsArray = [self brandsArray];
                destModalVC.selectedItemsArray = [self selectedBrands];
                destModalVC.headerTitle = BRAND_TITLE;
            }
            else if ([(UIButton *)sender tag] == COLOR_FILTER ) {
             
                destModalVC.itemsArray = [self colorsArray];
                destModalVC.selectedItemsArray = [self selectedColors];
                destModalVC.headerTitle = COLOR_TITLE;
            }
            else if ([(UIButton *)sender tag] == SIZE_FILTER ) {
                
                destModalVC.itemsArray = [self sizesArray];
                destModalVC.selectedItemsArray = [self selectedSizes];
                destModalVC.headerTitle = SIZE_TITLE;
            }
            
            destModalVC.modalDelegate = self;
        }
    }
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    
    // 1. construct the string 2. setup delegates 3. perform the request
    
    NSMutableArray *brandsArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < [self.selectedBrands count]; i++)
        [brandsArray addObject:[[self.selectedBrands objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *colorsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.selectedColors count]; i++)
        [colorsArray addObject:[[self.selectedColors objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *sizesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.selectedSizes count]; i++)
        [sizesArray addObject:[[self.selectedSizes objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *categoriesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.selectedCategories count]; i++)
        [categoriesArray addObject:[[self.selectedCategories objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *pricesArray = [[NSMutableArray alloc] init];
  
    for (int i = 0; i < [self.selectedPrices count]; i++)
        [pricesArray addObject:[[self.selectedPrices objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    NSMutableArray *sortArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.selectedBrands count]; i++)
        [sortArray addObject:[[self.selectedBrands objectAtIndex:i] componentsSeparatedByString:@":"][0]];
    
    
    [self.queryRefineArray addObject:pricesArray];
    [self.queryRefineArray addObject:categoriesArray];
    [self.queryRefineArray addObject:brandsArray];
    [self.queryRefineArray addObject:colorsArray];
    [self.queryRefineArray addObject:sizesArray];
    
}


- (IBAction)unwindFromModalSelectionTVC:(UIStoryboardSegue *)unwindSegue {
    
}


#pragma mark - BTRModalFilterSelectionDelegate


- (void)modalFilterSelectionVCDidEnd:(NSMutableArray *)selectedItemsArray  withTitle:(NSString *)titleString{

    
    if ([titleString isEqualToString:BRAND_TITLE])
        self.selectedBrands = selectedItemsArray;
    else if ([titleString isEqualToString:COLOR_TITLE])
        self.selectedColors = selectedItemsArray;
    else if ([titleString isEqualToString:SIZE_TITLE])
        self.selectedSizes = selectedItemsArray;
    

    [self.tableView reloadData];
}



@end



























