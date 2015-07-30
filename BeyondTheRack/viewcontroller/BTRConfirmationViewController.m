//
//  BTRConfirmationViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRConfirmationViewController.h"

@interface BTRConfirmationViewController ()

@end

@implementation BTRConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    
    //chaning thanks label
    self.thanksLabel.text = [NSString stringWithFormat:@"THANK YOU FOR YOUR ORDER NO. %@",self.order.orderId];
    
    // adding last 4 digits of card
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:self.billingLabel.attributedText];
    [[text mutableString] replaceOccurrencesOfString:@"1111" withString:self.order.cardNumber options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.string.length)];
    
    //address
    NSString* shippingAddressString = [NSString stringWithFormat:@"%@%@\n%@\n%@\n",self.order.shippingAddressLine1,self.order.shippingAddressLine2,self.order.shippingCity,self.order.shippingCountry];
    self.shippingAddress.text = shippingAddressString;
    
    NSString* billingAddressString = [NSString stringWithFormat:@"%@%@\n%@\n%@\n",self.order.billingAddressLine1,self.order.billingAddressLine2,self.order.billingCity,self.order.billingCountry];
    self.billingAddress.text = billingAddressString;
    
    // order Items
    
    
    
    // Prices
    self.bagTotalLabel.text = [NSString stringWithFormat:@"%@",self.order.bagTotalPrice];
    self.qstLabel.text = [NSString stringWithFormat:@"%@",self.order.qstTax];
    self.gstLabel.text = [NSString stringWithFormat:@"%@",self.order.gstTax];
    self.orderTotal.text = [NSString stringWithFormat:@"%@",self.order.orderTotalPrice];
    self.shippingPriceLabel.text = [NSString stringWithFormat:@"%@",self.order.shippingPrice];
    
    
}

- (IBAction)viewTapped:(id)sender {
    
}



@end
