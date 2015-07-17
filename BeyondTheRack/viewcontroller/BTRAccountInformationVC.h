//
//  BTRAccountInformationVC.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTRAccountInformationVC : UIViewController <UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *neuPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *retypePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *maritalStatusTextField;
@property (weak, nonatomic) IBOutlet UITextField *childrenTextField;
@property (weak, nonatomic) IBOutlet UITextField *formalEducationTextField;
@property (weak, nonatomic) IBOutlet UITextField *incomeBracketTextField;
@property (weak, nonatomic) IBOutlet UITextField *occupationTextField;
@property (weak, nonatomic) IBOutlet UITextField *shoppingClubsTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *alternateEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *address1TextField;
@property (weak, nonatomic) IBOutlet UITextField *address2TextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerParentView;

@property (strong, nonatomic) UITextField *currentTextField;

@end
