//
//  BTRModalFilterSelectionVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-02-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRModalFilterSelectionVC.h"


@interface BTRModalFilterSelectionVC ()

@end

@implementation BTRModalFilterSelectionVC

- (NSMutableArray *)selectedItemsArray {
    
    if (!_selectedItemsArray) _selectedItemsArray = [[NSMutableArray alloc] init];
    return _selectedItemsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.selectedItemsArray = [[NSMutableArray alloc] init];
    self.titleLabel.text = [self headerTitle];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [[self itemsArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModalFilterSelectionCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.itemsArray objectAtIndex:indexPath.row];
    
    if ([self isItemSelected:[self.itemsArray objectAtIndex:indexPath.row]] >= 0){
        
        cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {

        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}



- (int)isItemSelected:(NSString *)itemString
{
    if ([self.selectedItemsArray count] == 0)
        return -1;
    
    for(NSString *item in  self.selectedItemsArray) {
        
        if([itemString isEqualToString:item]) {
            
            return 1;
            break;
        }
    }
    
    return -1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.selectedItemsArray addObject:[[cell textLabel] text]];
        
    } else {
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;

        [self.selectedItemsArray removeObject:[[cell textLabel] text]];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end












