//
//  BTRPaypalCheckoutViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@protocol PayPalInfoDelegate <NSObject>
- (void)payPalInfoDidReceived:(NSDictionary *)info;
@end

@interface BTRPaypalCheckoutViewController : UIViewController <UIWebViewDelegate>

// response from server
@property (nonatomic, strong) NSDictionary *paypalInfo;
@property (nonatomic, strong) NSString *payPalURL;
@property (nonatomic, strong) id <PayPalInfoDelegate> delegate;

@end
