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
    
    NSLog(@"reccievd size: %lu", (unsigned long)[[self sizesArray] count]);
    
    // Do any additional setup after loading the view.
}




#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self sizesArray] count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(selectSizeWillDisappearWithSelectionIndex:)]) {
        [self.delegate selectSizeWillDisappearWithSelectionIndex:[indexPath row]];
        [self performSegueWithIdentifier:@"unwindFromSelectSizeToProductDetail" sender:self];
     }
     

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = @"BTRSizeSelectionCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self sizesArray] objectAtIndex:[indexPath row]];
    
    return cell;
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
