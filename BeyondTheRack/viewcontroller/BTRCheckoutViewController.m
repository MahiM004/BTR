//
//  BTRCheckoutViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCheckoutViewController.h"

#import "BTRPaymentTypesHandler.h"


@interface BTRCheckoutViewController ()

@end

@implementation BTRCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
    for (NSString *someString in [sharedPaymentTypes paymentTypesArray]) {
        NSLog(@"-- %@", someString);
    }
    
    for (NSString *someString in [sharedPaymentTypes creditCardTypeArray]) {
        NSLog(@"++ %@", someString);
    }
    
    for (NSString *someString in [sharedPaymentTypes creditCardDisplayNameArray]) {
        NSLog(@"** %@", someString);
    }
    
    
}


- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
