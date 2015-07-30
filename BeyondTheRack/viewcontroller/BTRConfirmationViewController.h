//
//  BTRConfirmationViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface BTRConfirmationViewController : UIViewController

// Order
@property (nonatomic, strong) Order *order;

// ThanksLabel
@property (weak, nonatomic) IBOutlet UILabel *thanksLabel;

// Billing Information
@property (weak, nonatomic) IBOutlet UILabel *billingLabel;

// Addresses Outlet
@property (weak, nonatomic) IBOutlet UILabel *billingAddress;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddress;

// items of order
@property (weak, nonatomic) IBOutlet UIView *orderView;

// receipt
@property (weak, nonatomic) IBOutlet UILabel *bagTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *gstLabel;
@property (weak, nonatomic) IBOutlet UILabel *qstLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotal;


// scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end
