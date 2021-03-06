//
//  BTRContactUSViewController.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "DownPicker.h"
#import "BTRPopUpVC.h"

@interface BTRContactUSViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,DropDownPickerDelegate,PopUPDelegate>


// LABELS

@property (weak, nonatomic) IBOutlet UILabel *faqSugesstionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactSupportTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactSupportContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerServiceHoursTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerServiceHoursContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfEnquiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneWidthForAll;

// TEXT FIELDS

@property (weak, nonatomic) IBOutlet UITextField *typeOfInquiryTF;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;
@property (weak, nonatomic) IBOutlet UITextField *itemNumberTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;


// Button
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@property (weak, nonatomic) IBOutlet UIButton *typeOfInquiryBtn;

@property (weak, nonatomic) IBOutlet UIView *parentView;

// Contact Informations

@property (nonatomic, strong) Contact *contactInformaion;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic) DownPicker *faqPicker;
@end
