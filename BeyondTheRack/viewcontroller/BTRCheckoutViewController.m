//
//  BTRCheckoutViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCheckoutViewController.h"

#import "BTRPaymentTypesHandler.h"

#define COUNTRY_PICKER          1
#define PROVINCE_PICKER         2
#define STATE_PICKER            3
#define EXPIRY_YEAR_PICKER      4
#define EXPIRY_MONTH_PICKER     5
#define PAYMENT_TYPE_PICKER     6

#define BILLING_ADDRESS         1
#define SHIPPING_ADDRESS        2

@interface BTRCheckoutViewController ()

@property (assign, nonatomic) NSUInteger pickerType;
@property (assign, nonatomic) NSUInteger billingOrShipping;

@property (strong, nonatomic) NSArray *statesArray;
@property (strong, nonatomic) NSArray *provincesArray;
@property (strong, nonatomic) NSArray *countryNameArray;

@property (strong, nonatomic) NSArray *expiryMonthsArray;
@property (strong, nonatomic) NSMutableArray *expiryYearsArray;
@property (strong, nonatomic) NSMutableArray *paymentTypesArray;

@property (strong, nonatomic) NSString *chosenShippingCountryString;
@property (strong, nonatomic) NSString *chosenBillingCountryString;


@end

@implementation BTRCheckoutViewController


- (NSArray *)countryNameArray {
    
    _countryNameArray = @[@"Canada", @"USA"];
    return _countryNameArray;
}


- (NSArray *)provincesArray {
    
    _provincesArray = @[@"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick",
                        @"New foundland & Labrador", @"Northwest Territories", @"Nova Scotia",
                        @"Nunavut", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan", @"Yukon"];
    
    
    return _provincesArray;
}


- (NSArray *)statesArray {
    
    _statesArray = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut",
                     @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa",
                     @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan",
                     @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire",
                     @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma",
                     @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee",
                     @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
    
    return _statesArray;
}

- (NSArray *)expiryMonthsArray {
    
    _expiryMonthsArray = @[@"01 January", @"02 February", @"03 March", @"04 April", @"05 May", @"06 June", @"07 July",
                           @"08 August", @"09 September", @"10 October", @"11 November", @"12 December"];
    
    return _expiryMonthsArray;
}


- (NSMutableArray *)expiryYearsArray {
    
    if (!_expiryYearsArray) _expiryYearsArray = [[NSMutableArray alloc] init];
    return _expiryYearsArray;
}


- (NSMutableArray *)paymentTypesArray {
    
    if (!_paymentTypesArray) _paymentTypesArray = [[NSMutableArray alloc] init];
    return _paymentTypesArray;
}


#pragma mark - UI


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger currentYear = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    
    for (NSInteger i = currentYear; i < 21 + currentYear; i++) {
        [[self expiryYearsArray] addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    self.pickerView.delegate = self;
    [self.pickerParentView setHidden:TRUE];

    // setting default value
    [self setChosenShippingCountryString:@"Canada"];
    [self setChosenBillingCountryString:@"Canada"];
    
    BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
    [[self paymentTypesArray] addObjectsFromArray:[sharedPaymentTypes creditCardDisplayNameArray]];
 
 }


- (void)checkboxDidChange:(CTCheckbox *)checkbox
{
    if (checkbox.checked) {
        NSLog(@"--0-0 Checked");
    } else {
        NSLog(@"--00 Not checked");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}


- (IBAction)viewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}

- (void)loadPickerViewforPickerType:(NSUInteger)pickerType andAddressType:(NSUInteger) adressType{

    [self setBillingOrShipping:adressType];
    [self setPickerType:pickerType];
    [self.pickerView reloadAllComponents];
    [self dismissKeyboard];
    [self.pickerParentView setHidden:FALSE];
    [self.pickerView becomeFirstResponder];
}


- (IBAction)shippingCountryButtonTapped:(UIButton *)sender {
    
    [self loadPickerViewforPickerType:COUNTRY_PICKER andAddressType:SHIPPING_ADDRESS];
}


- (IBAction)shippingStateButtonTapped:(UIButton *)sender {
    
    if ([[[self countryShippingTF] text] isEqualToString:@"USA"])
        [self loadPickerViewforPickerType:STATE_PICKER andAddressType:SHIPPING_ADDRESS];
    else
        [self loadPickerViewforPickerType:PROVINCE_PICKER andAddressType:SHIPPING_ADDRESS];
}


- (IBAction)billingCountryButtonTapped:(UIButton *)sender {
    
    [self loadPickerViewforPickerType:COUNTRY_PICKER andAddressType:BILLING_ADDRESS];
}


- (IBAction)billingStateButtonTapped:(UIButton *)sender {
    
    if ([[[self countryBillingTF] text] isEqualToString:@"USA"])
        [self loadPickerViewforPickerType:STATE_PICKER andAddressType:BILLING_ADDRESS];
    else
        [self loadPickerViewforPickerType:PROVINCE_PICKER andAddressType:BILLING_ADDRESS];
}


- (IBAction)expiryYearButtonTapped:(UIButton *)sender {

}


- (IBAction)expiryMonthButtonTapped:(UIButton *)sender {

}


- (IBAction)paymentMethodButtonTapped:(UIButton *)sender {

}



#pragma mark - PickerView Delegates


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    if ([self pickerType] == PROVINCE_PICKER) {
        
        if ([self billingOrShipping] == BILLING_ADDRESS) {
            [self.provinceBillingTF setText:[[self provincesArray] objectAtIndex:row]];
        } else if ([self billingOrShipping] == SHIPPING_ADDRESS) {
            [self.provinceShippingTF setText:[[self provincesArray] objectAtIndex:row]];
        }
    }
    
    if ([self pickerType] == STATE_PICKER) {
        
        if ([self billingOrShipping] == BILLING_ADDRESS) {
            [self.provinceBillingTF setText:[[self statesArray] objectAtIndex:row]];
        } else if ([self billingOrShipping] == SHIPPING_ADDRESS) {
            [self.provinceShippingTF setText:[[self statesArray] objectAtIndex:row]];
        }
    }
    
    if ([self pickerType] == COUNTRY_PICKER) {
        
        if ([self billingOrShipping] == BILLING_ADDRESS) {
            [self.countryBillingTF setText:[[self countryNameArray] objectAtIndex:row]];
        } else if ([self billingOrShipping] == SHIPPING_ADDRESS) {
            [self.countryShippingTF setText:[[self countryNameArray] objectAtIndex:row]];
        }
    }
    
    [self.pickerParentView setHidden:TRUE];
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] count];
    
    if ([self pickerType] == PROVINCE_PICKER)
        return [[self provincesArray] count];
    
    if ([self pickerType] == STATE_PICKER)
        return [[self statesArray] count];
    
    return  [[self countryNameArray] count];
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([self pickerType] == COUNTRY_PICKER)
        return [[self countryNameArray] objectAtIndex:row];
    
    if ([self pickerType] == PROVINCE_PICKER)
        return [[self provincesArray] objectAtIndex:row];
    
    if ([self pickerType] == STATE_PICKER)
        return [[self statesArray] objectAtIndex:row];
    
    return [[self countryNameArray] objectAtIndex:row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}





#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end



















