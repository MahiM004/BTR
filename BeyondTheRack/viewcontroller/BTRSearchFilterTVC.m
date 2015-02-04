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

@interface BTRSearchFilterTVC () <BTRModalFilterSelectionDelegate> {
    int selectedSortIndex;
  //  NSMutableArray *selectedPriceFilters;

}

@property (strong, nonatomic) NSMutableDictionary *facets;
@property (strong, nonatomic) NSMutableArray *titles;


@end

@implementation BTRSearchFilterTVC

@synthesize facets;


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
    
   
    if([sender isKindOfClass:[UIButton class]])

        if ([segue.identifier isEqualToString:@"ModalSelectionSegueIdentifier"]) {
            
            BTRModalFilterSelectionVC *destModalVC = [segue destinationViewController];
        

            if ([(UIButton *)sender tag] == BRAND_FILTER ) {
                
                destModalVC.itemsArray = [[NSMutableArray alloc] initWithArray:@[@"B 1",@"B 2",@"B 3",@"B 4",@"B 5", @"B 6", @"B 7", @"B 8", @"B 9"]];
                
                destModalVC.headerTitle = @"Select Brands";
            }
            else if ([(UIButton *)sender tag] == COLOR_FILTER ) {
             
                destModalVC.itemsArray = [[NSMutableArray alloc] initWithArray:@[@"C 1",@"C 2",@"C 3",@"C 4",@"C 5", @"C 6", @"C 7", @"C 8", @"C 9"]];
                destModalVC.headerTitle = @"Select Colors";
            }
            else if ([(UIButton *)sender tag] == SIZE_FILTER ) {
                
                destModalVC.itemsArray = [[NSMutableArray alloc] initWithArray:@[@"S 1",@"S 2",@"S 3",@"S 4",@"S 5",@"S 6",@"S 7",@"S 8",@"S 9"]];
                destModalVC.headerTitle = @"Select Sizes";

            }
            
            destModalVC.modalDelegate = self;
            
        }
}




- (IBAction)unwindFromModalSelectionTVC:(UIStoryboardSegue *)unwindSegue
{
    
}


#pragma mark - BTRModalFilterSelectionDelegate


- (void)modalFilterSelectionVCDidEnd:(NSMutableArray *)selectedItemsArray
{
    NSLog(@"selected count: %d", [selectedItemsArray count]);
    
}



@end
























//self.sliderView.backgroundColor = [UIColor clearColor];
/*
slider = [[RangeSlider alloc] initWithFrame:CGRectMake(10, 100, 300, 30)]; // the slider enforces a height of 30, although I'm not sure that this is necessary
slider.minimumRangeLength = .03; // this property enforces a minimum range size. By default it is set to 0.0

[slider setMinThumbImage:[UIImage imageNamed:@"rangethumb.png"]]; // the two thumb controls are given custom images
[slider setMaxThumbImage:[UIImage imageNamed:@"rangethumb.png"]];


UIImage *image; // there are two track images, one for the range "track", and one for the filled in region of the track between the slider thumbs

[slider setTrackImage:[[UIImage imageNamed:@"fullrange.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9.0, 9.0, 9.0, 9.0)]];

image = [UIImage imageNamed:@"fillrangeblue.png"];
[slider setInRangeTrackImage:image];


[slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged]; // The slider sends actions when the value of the minimum or maximum changes

*/


// [self.priceRangeCell addSubview:slider];




/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    
    switch (section) {
            
        case 0:
            sectionLabel.text = @"        SORT ITEMS";
            break;
            
        case 1:
            sectionLabel.text = @"        FILTER BY PRICE";
            break;
            
        case 2:
            sectionLabel.text = @"        FILTER BY CATEGORY";
            break;
            
        case 3:
            sectionLabel.text = @"        FILTER BY COLOR";
            break;
            
        case 4:
            sectionLabel.text = @"        FILTER BY BRAND";
            break;
            
        default:
            break;
    }
    
    sectionLabel.textColor = [UIColor colorWithWhite:255.0 alpha:0.5];
    
    [headerView addSubview:sectionLabel];
    
    return headerView;
}*/



/*
 self.sliderView.backgroundColor = [UIColor clearColor];
 NSUInteger margin = 20;
 CGRect sliderFrame = CGRectMake(margin, margin, self.view.frame.size.width - margin * 2, 30);
 _rangeSlider = [[CERangeSlider alloc] initWithFrame:sliderFrame];
 
 [self.sliderView addSubview:_rangeSlider];
 
 [_rangeSlider addTarget:self
 action:@selector(slideValueChanged:)
 forControlEvents:UIControlEventValueChanged];
 
 [self performSelector:@selector(updateState) withObject:nil afterDelay:1.0f];
 */



//reportLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 310, 30)]; // a label to see the values of the slider in this demo
//reportLabel.adjustsFontSizeToFitWidth = YES;
//reportLabel.textAlignment = NSTextAlignmentCenter;
//[self.sliderView addSubview:reportLabel];
//NSString *report = [NSString stringWithFormat:@"current slider range is %f to %f", slider.min, slider.max];
//reportLabel.text = report;






/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


/*
 - (void)slideValueChanged:(RangeSlider *)sender {
 
 // NSString *report = [NSString stringWithFormat:@"current slider range is %f to %f", sender.min, sender.max];
 //reportLabel.text = report;
 }
 */

