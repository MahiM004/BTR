//
//  BTRCheckoutViewController.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTCheckbox.h"


@interface BTRCheckoutViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet CTCheckbox *vipOptionCheckbox;
@property (weak, nonatomic) IBOutlet CTCheckbox *sameAddressCheckbox;

@end
