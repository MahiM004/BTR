//
//  BTRProductDetailViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRProductDetailViewController.h"

@interface BTRProductDetailViewController ()

@end

@implementation BTRProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.someDummyLabel.text = [self someString];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (IBAction)backArrowTapped:(UIButton *)sender {

    
    NSLog(@"back arrow!");
    [self dismissViewControllerAnimated:YES completion:nil];

}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
