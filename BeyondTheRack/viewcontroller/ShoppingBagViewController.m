//
//  ShoppingBagViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-24.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "ShoppingBagViewController.h"

@interface ShoppingBagViewController ()

@end

@implementation ShoppingBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCellIdentifier"];
    }
    
    cell.backgroundColor = [UIColor blackColor];
    cell.detailTextLabel.text = @"something cool";
    cell.textLabel.text = @"Kewl";
    
    return cell;
}


- (IBAction)tappedClose:(id)sender {

    [self dismissViewControllerAnimated:YES completion: nil];

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
