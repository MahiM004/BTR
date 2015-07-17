//
//  BTRSelectSizeVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-30.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRSelectSizeVC.h"

@interface BTRSelectSizeVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BTRSelectSizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}


- (IBAction)tappedCancel:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self sizesArray] count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(selectSizeWillDisappearWithSelectionIndex:)]) {
        [self.delegate selectSizeWillDisappearWithSelectionIndex:[indexPath row]];
        [self dismissViewControllerAnimated:YES completion:nil];
     }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = @"BTRSizeSelectionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self sizesArray] objectAtIndex:[indexPath row]];
    
    
    if ([[self sizesArray] count] > 0) {

        cell.detailTextLabel.text = [self getQuantityStringforQuantity:[[self.sizeQuantityArray objectAtIndex:indexPath.row] integerValue]];
        if ([[[cell detailTextLabel] text]  isEqualToString:@"SOLD OUT"])
            cell.userInteractionEnabled = FALSE;
        
        if ([[self.sizeQuantityArray objectAtIndex:indexPath.row] integerValue] == 0)
            cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}


- (NSString *)getQuantityStringforQuantity:(NSUInteger)quantity {
    
    NSString *quantityString = @"";
    
    if (quantity <= 0) {
        quantityString = @"SOLD OUT";
    
    } else if (quantity < 7) {
        quantityString = [NSString stringWithFormat:@"%lu left", (unsigned long)quantity];
    
    } else if (quantity >= 7) {
        quantityString = [NSString stringWithFormat:@"%lu", (unsigned long)quantity];
    }
    
    return quantityString;
}







@end












