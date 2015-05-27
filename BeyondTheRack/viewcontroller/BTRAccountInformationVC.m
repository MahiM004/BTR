//
//  BTRAccountInformationVC.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRAccountInformationVC.h"

#define COUNTRY_PICKER     1
#define GENDER_PICKER      2
#define INCOME_PICKER      3
#define CHILDREN_PICKER    4
#define MARITAL_PICKER     5
#define EDUCATION_PICKER   6
#define PROVINCE_PICKER    7

@interface BTRAccountInformationVC ()

@property (nonatomic) NSUInteger pickerType;


@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) NSArray *countryNameArray;
@property (strong, nonatomic) NSArray *incomeBracketArray;
@property (strong, nonatomic) NSArray *childrenArray;
@property (strong, nonatomic) NSArray *maritalStatusArray;
@property (strong, nonatomic) NSArray *formalEducationArray;
@property (strong, nonatomic) NSArray *provincesArray;
@property (strong, nonatomic) NSArray *statesArray;


@property (strong, nonatomic) NSString *chosenCountryCodeString;

@end


@implementation BTRAccountInformationVC


- (NSArray *)genderArray {
    
    _genderArray = @[@"Female", @"Male"];
    return _genderArray;
}

- (NSArray *)countryNameArray {
    
    _countryNameArray = @[@"Canada", @"USA"];
    return _countryNameArray;
}

- (NSArray *)incomeBracketArray {
    
    _incomeBracketArray = @[@"Up to $60,000", @"$60,000 to $100,000", @"$100,000 to $150,000", @"Over $150,000"];
    return _incomeBracketArray;
}

- (NSArray *)childrenArray {
    
    _childrenArray = @[@"Young children", @"Teenage children", @"Adult children"];
    return _childrenArray;
}


- (NSArray *)maritalStatusArray {
    
    _maritalStatusArray = @[@"Single", @"Unmarried", @"Married", @"Divorced", @"Widowed"];
    return _maritalStatusArray;
}


- (NSArray *)formalEducationArray {
    
    _formalEducationArray = @[@"Primary school", @"Secondary school", @"College", @"University", @"Graduate studies"];
    return _formalEducationArray;
}


- (NSArray *)provincesArray {
    
    _provincesArray = @[@"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick",
                        @"New foundland & Labrador", @"Northwest Territories", @"Nova Scotia",
                        @"Nunavut", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan", @"Yukon"];
    
    return _provincesArray;
}


- (NSArray *)statesArray {
    
    _statesArray = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware",
                     @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana",
                     @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana",
                     @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota",
                     @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee",
                     @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    
    return _statesArray;
}




# pragma mark - UI

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
        [self.genderTextField setText:[[self genderArray] objectAtIndex:row]];
    }

    [self.pickerParentView setHidden:TRUE];
    //[self.pickerView setHidden:TRUE];
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] count];
    
    return [[self genderArray] count];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] objectAtIndex:row];
    
    return [[self genderArray] objectAtIndex:row];
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
