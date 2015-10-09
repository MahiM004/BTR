//
//  BTRConfirmationViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-07-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "ConfirmationInfo.h"

@interface BTRConfirmationViewController : UIViewController

// confirmation info
@property (nonatomic, strong) ConfirmationInfo *info;

@end
