//
//  BTRContactUSViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRContactUSViewController : UIViewController <UITextFieldDelegate>


// TEXT FIELDS

@property (weak, nonatomic) IBOutlet UITextField *typeOfInquiryTF;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;
@property (weak, nonatomic) IBOutlet UITextField *itemNumberTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;

// PICKERVIEW

@property (weak, nonatomic) IBOutlet UIView *pickerParentView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;



@end
