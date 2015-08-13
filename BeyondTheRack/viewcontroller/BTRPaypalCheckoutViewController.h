//
//  BTRPaypalCheckoutViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface BTRPaypalCheckoutViewController : UIViewController <UIWebViewDelegate>

// new paypal account
@property BOOL isNewAccount;

// paypal URL
@property (nonatomic,strong) NSDictionary *paypal;

//WebView
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
