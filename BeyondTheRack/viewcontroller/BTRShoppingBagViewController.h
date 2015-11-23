//
//  BTRShoppingBagViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-24.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRMasterPassViewController.h"
#import "BTRPaypalCheckoutViewController.h"
#import "ApplePayManager.h"

@interface BTRShoppingBagViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MasterPassInfoDelegate,PayPalInfoDelegate,UIAlertViewDelegate,ApplePayDelegate>


@end



