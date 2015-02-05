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

    if (section == 0)  // for SORT ITEMS
        
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
    
    if (indexPath.section == 0) {
     
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
        
        
        if (selectedSortIndex != indexPath.row) {
            
            sortCell.accessoryType = UITableViewCellAccessoryNone;
            sortCell.textLabel.textColor = [UIColor lightGrayColor];
            
        } else if (selectedSortIndex == indexPath.row) {
            
            sortCell.accessoryType = UITableViewCellAccessoryCheckmark;
            sortCell.textLabel.textColor = [UIColor whiteColor];
        }
        
        switch (indexPath.row) {
                
            case 0:
                sortCell.textLabel.text = @"Best Match";
                break;
                
            case 1:
                sortCell.textLabel.text = @"Highest to Lowest Price";
                break;
                
                
            case 2:
                sortCell.textLabel.text = @"Lowest to Highest Price";
                break;
                
            default:
                break;
                
        }
     
        cell = sortCell;

        
    } else if (indexPath.section == PRICE_FILTER || indexPath.section == CATEGORY_FILTER) {
    
        BTRFilterWithSwitchTableViewCell *filteSwitchrCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterBySwitchCellIdentifier" forIndexPath:indexPath];

        if (filteSwitchrCell == nil) {
            filteSwitchrCell = [[BTRFilterWithSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterBySwitchCellIdentifier"];
        }
        
        filteSwitchrCell.filterSwitch.enabled = TRUE;

        if (indexPath.section == PRICE_FILTER) {
            
            if ([self.pricesArray count] == 0) {
                
                filteSwitchrCell.filterValueLabel.text = [NSString stringWithFormat:@"No Price Selection Available"];
                filteSwitchrCell.filterSwitch.enabled = FALSE;
                
            } else
                filteSwitchrCell.filterValueLabel.text = [self.pricesArray objectAtIndex:indexPath.row];
            
            filteSwitchrCell.filterSwitch.tag = PRICE_FILTER;
            
        } else if (indexPath.section == CATEGORY_FILTER) {
            
            if ([self.categoriesArray count] == 0) {
                
                filteSwitchrCell.filterValueLabel.text = [NSString stringWithFormat:@"No Category Selection Available"];
                filteSwitchrCell.filterSwitch.enabled = FALSE;
            
            } else
                filteSwitchrCell.filterValueLabel.text = [self.categoriesArray objectAtIndex:indexPath.row];
            
            filteSwitchrCell.filterSwitch.tag = CATEGORY_FILTER;
        }
        
        cell = filteSwitchrCell;
    
    } else if (indexPath.section == BRAND_FILTER || indexPath.section == COLOR_FILTER || indexPath.section == SIZE_FILTER) {
    
        BTRFilterWithModalTableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterByModalCellIdentifier" forIndexPath:indexPath];
        
        if (filterCell == nil) {
            
            filterCell = [[BTRFilterWithModalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterByModalCellIdentifier"];
        }
        
        filterCell.rowLabel.textColor = [UIColor colorWithWhite:255.0/255.0 alpha:1.0];
        filterCell.rowButton.enabled = TRUE;
        
        if (indexPath.section == BRAND_FILTER) {
         
            if ([self.brandsArray count] > 0) {
                
                if ([self.selectedBrands count] == 0) {
                    filterCell.rowLabel.text = [NSString stringWithFormat:@"All Brands"];
                }
                else {
                    filterCell.rowLabel.text = [self.selectedBrands objectAtIndex:indexPath.row];
                }
        
            } else if ([self.brandsArray count] == 0) {
                
                filterCell.rowLabel.text = [NSString stringWithFormat:@"No Brand Selection Available"];
                filterCell.rowLabel.textColor = [UIColor lightGrayColor];
                filterCell.rowButton.enabled = FALSE;
            }
            filterCell.rowButton.tag = BRAND_FILTER;

        } else if (indexPath.section == COLOR_FILTER) {
            
            if ([self.colorsArray count] > 0) {
                
                if ([self.selectedColors count] == 0) {
                    filterCell.rowLabel.text = [NSString stringWithFormat:@"All Colors"];
                }
                else {
                 
                    filterCell.rowLabel.text = [self.selectedColors objectAtIndex:indexPath.row];
                }
                
                
            } else if ([self.colorsArray count] == 0) {
                
                filterCell.rowLabel.text = [NSString stringWithFormat:@"No Color Selection Available"];
                filterCell.rowLabel.textColor = [UIColor lightGrayColor];
                filterCell.rowButton.enabled = FALSE;
            }
            
            filterCell.rowButton.tag = COLOR_FILTER;
            
        } else if (indexPath.section == SIZE_FILTER) {
            
            if ([self.sizesArray count] > 0) {
              
                if ([self.selectedSizes count] == 0) {
                 
                    filterCell.rowLabel.text = [NSString stringWithFormat:@"All Sizes"];
                }
                else {
                    
                    filterCell.rowLabel.text = [self.selectedSizes objectAtIndex:indexPath.row];
                }
                
            } else if([self.sizesArray count] == 0) {
             
                filterCell.rowLabel.text = [NSString stringWithFormat:@"No Size Selection Available"];
                filterCell.rowLabel.textColor = [UIColor lightGrayColor];
                filterCell.rowButton.enabled = FALSE;
            }
            filterCell.rowButton.tag = SIZE_FILTER;
        }
        
        
        filterCell.textLabel.textColor = [UIColor colorWithWhite:255.0/255.0 alpha:1.0];
        
        cell = filterCell;
    }
    
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



























