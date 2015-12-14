//
//  BTRForgotPasswordVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-25.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRLoadingButton.h"
@interface BTRForgotPasswordVC : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet BTRLoadingButton *loadingBtn;

@end
