//
//  ShoppingBagViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-24.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "ShoppingBagViewController.h"
#import "ApprovePurchaseViewController.h"

@interface ShoppingBagViewController ()

@end

@implementation ShoppingBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingBagCellIdentifier" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShoppingBagCellIdentifier"];
    }
    
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 150)];
    imv.image=[UIImage imageNamed:@"itemInBag.png"];
    [cell.contentView addSubview:imv];
    
    return cell;
}

- (IBAction)tappedCheckout:(UIButton *)sender {
    
    
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ApprovePurchaseViewController"];
    [self presentViewController:vc animated:YES completion:nil];

}



- (IBAction)tappedClose:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (IBAction)unwindToShoppingBagScene:(UIStoryboardSegue *)unwindSegue
{
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
