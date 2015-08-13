//
//  BTRContactUSViewController.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRContactUSViewController.h"

@interface BTRContactUSViewController ()

@property (strong, nonatomic) NSArray *inquiryArray;

@end



@implementation BTRContactUSViewController


- (NSArray *)inquiryArray {
    
    _inquiryArray = @[@"I can not sign in my account", @"I have a quiestion about a recent order", @"I have a question about a return or refund", @"I need some product information",
                        @"I have a different question or topic"];
    
    return _inquiryArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// selecting type of enquiry
- (IBAction)typeOfInquirySelecting:(id)sender {
    [self dismissKeyboard];
    [self.pickerParentView setHidden:FALSE];
}


// sending email
- (IBAction)sendMessage:(id)sender {
    
    
    
    
    
}

// keyboard Management

- (IBAction)viewTapped:(id)sender {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark PickerView Delegate & DataSource

// PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    [self.typeOfInquiryTF setText:[[self inquiryArray] objectAtIndex:row]];
    [self.pickerParentView setHidden:TRUE];
}


// PickerView DataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return  [[self inquiryArray] count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat sectionWidth = 300;
    return sectionWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.adjustsFontSizeToFitWidth = YES;
    }
    tView.text = [[self inquiryArray] objectAtIndex:row];
    return tView;
}

@end
