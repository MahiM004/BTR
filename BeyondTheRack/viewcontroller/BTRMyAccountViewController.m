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
    [[BTRRefreshManager sharedInstance]setTopViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"show");
}

-(IBAction)closeAccountVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
