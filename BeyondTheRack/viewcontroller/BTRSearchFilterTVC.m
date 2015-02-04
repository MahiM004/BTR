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


#define BRAND_FILTER 3
#define COLOR_FILTER 4
#define SIZE_FILTER 5


#define BRAND_TITLE @"Brand"
#define COLOR_TITLE @"Color"
#define SIZE_TITLE @"Size"

@interface BTRSearchFilterTVC () <BTRModalFilterSelectionDelegate> {
    int selectedSortIndex;
  //  NSMutableArray *selectedPriceFilters;

}

@property (strong, nonatomic) NSMutableDictionary *facets;
@property (strong, nonatomic) NSMutableArray *titles;


@end

@implementation BTRSearchFilterTVC

@synthesize facets;
@synthesize selectedBrands;
@synthesize selectedColors;
@synthesize selectedSizes;


- (void)viewDidLoad {
    
    [super viewDidLoad];

    //self.selectedColors = [[NSMutableArray alloc] initWithArray:@[@"RED", @"GREEN"]];

    selectedSortIndex = 0;
    self.facets = [NSMutableDictionary dictionary];
    self.titles = [[NSMutableArray alloc] initWithArray:@[@"SORT ITEMS", @"FILTER BY PRICE", @"FILTER BY CATEGORY", @"FILTER BY BRANDS", @"FILTER BY COLORS", @"FILTER BY SIZES"]];

    NSMutableArray *threeStrings = [[NSMutableArray alloc] initWithArray:@[@"Some Value 1", @"Some Other Value 2", @"Last Value 3"]];
    
    for (int i = 0; i < [self.titles count]; i++)
    {
        [self.facets setObject:threeStrings forKey:[self.titles objectAtIndex:i]];
    }

  

    

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
    // Return the number of rows in the section.
    
    
    if (section == 0 || section == BRAND_FILTER || section == COLOR_FILTER || section == SIZE_FILTER)
        return [self numberOfRowsInSection:section];

    NSArray *someFacet = [self.facets objectForKey:[self.titles objectAtIndex:section]];
    return [someFacet count];
}


- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)  // for SORT ITEMS

        return 3;

    else if (section == BRAND_FILTER)
    {
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

        
    } else if (indexPath.section == 1 || indexPath.section == 2) {
    
        BTRFilterWithSwitchTableViewCell *filteSwitchrCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterBySwitchCellIdentifier" forIndexPath:indexPath];

        if (filteSwitchrCell == nil) {
            filteSwitchrCell = [[BTRFilterWithSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterBySwitchCellIdentifier"];
        }
        
        NSArray *someFacet = [self.facets objectForKey:[self.titles objectAtIndex:indexPath.section]];
        filteSwitchrCell.filterValueLabel.text = [someFacet objectAtIndex:indexPath.row];//[NSString stringWithFormat:@"Just Some Value %ld", (long)[indexPath row]];
        
        cell = filteSwitchrCell;
    
    } else if (indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5) {
    
        BTRFilterWithModalTableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterByModalCellIdentifier" forIndexPath:indexPath];
        
        if (filterCell == nil) {
            
            filterCell = [[BTRFilterWithModalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterByModalCellIdentifier"];
        }
        
        if (indexPath.section == BRAND_FILTER) {
            
            if ([self.selectedBrands count] == 0)
                filterCell.rowLabel.text = [NSString stringWithFormat:@"All Brands"];
            else
                filterCell.rowLabel.text = [self.selectedBrands objectAtIndex:indexPath.row];
            
            filterCell.rowButton.tag = BRAND_FILTER;
            
        } else if (indexPath.section == COLOR_FILTER) {
            
            if ([self.selectedColors count] == 0)
                filterCell.rowLabel.text = [NSString stringWithFormat:@"All Colors"];
            else
                filterCell.rowLabel.text = [self.selectedColors objectAtIndex:indexPath.row];
        
            filterCell.rowButton.tag = COLOR_FILTER;
            
        } else if (indexPath.section == SIZE_FILTER) {
            
            if ([self.selectedSizes count] == 0)
                filterCell.rowLabel.text = [NSString stringWithFormat:@"All Sizes"];
            else
                filterCell.rowLabel.text = [self.selectedSizes objectAtIndex:indexPath.row];
            
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
                
                destModalVC.itemsArray = [[NSMutableArray alloc] initWithArray:@[@"B 1",@"B 2",@"B 3",@"B 4",@"B 5", @"B 6", @"B 7", @"B 8", @"B 9"]];
                destModalVC.selectedItemsArray = [self selectedBrands];
                destModalVC.headerTitle = BRAND_TITLE;
            }
            else if ([(UIButton *)sender tag] == COLOR_FILTER ) {
             
                destModalVC.itemsArray = [[NSMutableArray alloc] initWithArray:@[@"C 1",@"C 2",@"C 3",@"C 4",@"C 5", @"C 6", @"C 7", @"C 8", @"C 9"]];
                destModalVC.selectedItemsArray = [self selectedColors];
                destModalVC.headerTitle = COLOR_TITLE;
            }
            else if ([(UIButton *)sender tag] == SIZE_FILTER ) {
                
                destModalVC.itemsArray = [[NSMutableArray alloc] initWithArray:@[@"S 1",@"S 2",@"S 3",@"S 4",@"S 5",@"S 6",@"S 7",@"S 8",@"S 9"]];
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



























