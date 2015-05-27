//
//  BTRAccountInformationVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountInformationVC.h"

#define COUNTRY_PICKER 1
#define GENDER_PICKER 2


@interface BTRAccountInformationVC ()

@property (nonatomic) NSUInteger pickerType;
@property (strong, nonatomic) NSArray *genderNameArray;
@property (strong, nonatomic) NSArray *countryNameArray;

@property (strong, nonatomic) NSString *chosenCountryCodeString;

@end


@implementation BTRAccountInformationVC


- (NSArray *)genderNameArray {
    
    _genderNameArray = @[@"Female", @"Male"];
    return _genderNameArray;
}

- (NSArray *)countryNameArray {
    
    _countryNameArray = @[@"Canada", @"USA"];
    return _countryNameArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerParentView setHidden:TRUE];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}


- (IBAction)genderTapped:(UIButton *)sender {

    [self setPickerType:GENDER_PICKER];
    [self.pickerView reloadAllComponents];
    [self dismissKeyboard];
    [self.pickerParentView setHidden:FALSE];
    //[self.viewForPicker setHidden:FALSE];
}




- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}


#pragma mark - PickerView Delegates


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    if ([self pickerType] == COUNTRY_PICKER) {
        [self.countryTextField setText:[[self countryNameArray] objectAtIndex:row]];
        
        if ([self.countryTextField.text isEqualToString:@"Canada"]) {
            
            self.chosenCountryCodeString = @"CA";
            
        } else if ([self.countryTextField.text isEqualToString:@"USA"]) {
            
            self.chosenCountryCodeString = @"US";
        }
    }
    
    if ([self pickerType] == GENDER_PICKER) {
        [self.genderTextField setText:[[self genderNameArray] objectAtIndex:row]];
    }

    [self.pickerParentView setHidden:TRUE];
    //[self.pickerView setHidden:TRUE];
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] count];
    
    return [[self genderNameArray] count];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] objectAtIndex:row];
    
    return [[self genderNameArray] objectAtIndex:row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


# pragma mark - Handle update buttons


- (IBAction)updatePasswordTapped:(UIButton *)sender {
}


- (IBAction)updateInfoTapped:(UIButton *)sender {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
