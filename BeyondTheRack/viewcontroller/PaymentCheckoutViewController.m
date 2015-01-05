//
//  PaymentCheckoutViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-02.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "PaymentCheckoutViewController.h"

#import "ApprovePurchaseViewController.h"

@interface PaymentCheckoutViewController ()

@end

@implementation PaymentCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (IBAction)tappedContinueToCheckout:(UIButton *)sender {
    
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ApprovePurchaseViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}



- (IBAction)unwindToPaymentCheckoutScene:(UIStoryboardSegue *)unwindSegue
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