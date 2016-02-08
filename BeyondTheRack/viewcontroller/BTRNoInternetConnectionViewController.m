//
//  BTRNoInternetConnectionViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2016-02-08.
//  Copyright © 2016 Hadi Kheyruri. All rights reserved.
//

#import "BTRNoInternetConnectionViewController.h"

@interface BTRNoInternetConnectionViewController ()

@end

@implementation BTRNoInternetConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)reload:(id)sender {
    BTRAppDelegate *appdel = (BTRAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdel backToInitialViewControllerFrom:self];
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
