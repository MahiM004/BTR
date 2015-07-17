//
//  BTRSignUpEmbeddedTVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-17.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface BTRSignUpEmbeddedTVC : UITableViewController <UIPickerViewDelegate, FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbButton;

@end
