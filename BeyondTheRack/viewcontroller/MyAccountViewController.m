//
//  MyAccountViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-29.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "MyAccountViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





//#pragma mark - Table view data source

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCellIdentifier" forIndexPath:indexPath];
    
    return cell;
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
