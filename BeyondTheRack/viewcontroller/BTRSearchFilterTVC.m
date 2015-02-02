//
//  BTRSearchFilterTVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSearchFilterTVC.h"
#import "BTRFilterWithSwitchTableViewCell.h"


@interface BTRSearchFilterTVC () {
    int selectedSortIndex;
}

@end

@implementation BTRSearchFilterTVC



- (void)viewDidLoad {
    
    [super viewDidLoad];

    selectedSortIndex = 0;

}



- (void)slideValueChanged:(RangeSlider *)sender {

   // NSString *report = [NSString stringWithFormat:@"current slider range is %f to %f", sender.min, sender.max];
    //reportLabel.text = report;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (section) {
        case 0:
            return 3;
            break;
        
        case 1:
            return 4;
            break;
        
        case 2:
            return 0;
            break;
        
        case 3:
            return 4;
            break;
            
        case 4:
            return 0;
            break;

        case 5:
            return 0;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return @"        SORT ITEMS";
            break;
            
        case 1:
            return @"        FILTER BY PRICE";
            break;
            
        case 2:
            return @"        FILTER BY CATEGORY";
            break;
            
        case 3:
            return @"        FILTER BY COLOR";
            break;
            
        case 4:
            return @"        FILTER BY BRAND";
            break;
            
        case 5:
            return @"        FILTER BY SIZE";
            break;
            
        default:
            break;
    }
    
    return 0;
    
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
    
    if (indexPath.section == 0)
    {
     
        selectedSortIndex = indexPath.row;

        UITableViewCell *sortCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (sortCell.textLabel.textColor != [UIColor whiteColor]) {
            
            sortCell.textLabel.textColor = [UIColor whiteColor];
            sortCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        
        [self.tableView reloadData];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        UITableViewCell *sortCell = [tableView dequeueReusableCellWithIdentifier:@"BTRRefineSortCellIdentifier" forIndexPath:indexPath];
        
        if (sortCell == nil)
        {
            sortCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRRefineSortCellIdentifier"];
        }
        
        
        
  

        /*
        if ([self isTagSelected:[[self cvsArray] objectAtIndex:indexPath.row]]){
            
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.detailTextLabel.text = @"already tagged";
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.chosenIndexPath = indexPath;
            
        } else {
            
            cell.detailTextLabel.text = @" ";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        */
        
        
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

        
    } else if (indexPath.section == 1) {
    
        BTRFilterWithSwitchTableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterByPriceCellIdentifier" forIndexPath:indexPath];

        if (filterCell == nil) {
            filterCell = [[BTRFilterWithSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterByPriceCellIdentifier"];
        }
        
        filterCell.filterValueLabel.text = [NSString stringWithFormat:@"Just Some Value %d", [indexPath row]];
        cell = filterCell;
    
    } else if (indexPath.section == 3) {
    
        BTRFilterWithSwitchTableViewCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"BTRFilterByPriceCellIdentifier" forIndexPath:indexPath];
        
        if (filterCell == nil) {
            
            filterCell = [[BTRFilterWithSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BTRFilterByPriceCellIdentifier"];
        }
        
        filterCell.filterValueLabel.text = [NSString stringWithFormat:@"Just Some Value %d", [indexPath row]];
        cell = filterCell;
    }
    
    
    

    
    return cell;
}

//- (UITableViewCell *)getCellFor


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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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



