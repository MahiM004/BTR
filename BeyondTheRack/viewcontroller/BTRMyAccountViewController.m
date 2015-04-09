//
//  BTRMyAccountViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-29.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRMyAccountViewController.h"

@interface BTRMyAccountViewController ()

@end

@implementation BTRMyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;

}


#pragma mark - Navigation


- (IBAction)unwindToMyAccountViewController:(UIStoryboardSegue *)unwindSegue
{
}



/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
