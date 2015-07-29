//
//  BTRCheckoutViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCheckoutViewController.h"
#import "BTRPaymentTypesHandler.h"
#import "BTROrderFetcher.h"
#import "Order+AppServer.h"


#define COUNTRY_PICKER          1
#define PROVINCE_PICKER         2
#define STATE_PICKER            3
#define EXPIRY_YEAR_PICKER      4
#define EXPIRY_MONTH_PICKER     5
#define PAYMENT_TYPE_PICKER     6

#define BILLING_ADDRESS         1
#define SHIPPING_ADDRESS        2

@class CTCheckbox;


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
    
    _expiryMonthsArray = @[@"01 - jan", @"02 - feb", @"03 - mar", @"04 - apr", @"05 - may", @"06 - jun", @"07 - jul",
                           @"08 - aug", @"09 - sep", @"10 - oct", @"11 - nov", @"12 - dec"];
    
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

#pragma mark - Shipping & Billing & Card Info

- (NSDictionary *)shippingInfo {
    NSDictionary *info = (@{@"name": [[self recipientNameShippingTF] text],
                                    @"address1": [[self addressLine1ShippingTF] text],
                                    @"address2": [[self addressLine2ShippingTF] text],
                                    @"country": [BTRViewUtility countryCodeforName:[[self countryShippingTF] text]],
                                    @"postal": [[self zipCodeShippingTF] text],
                                    @"state": [BTRViewUtility provinceCodeforName:[[self provinceShippingTF] text]],
                                    @"city": [[self cityShippingTF] text],
                                    @"phone": [[self phoneShippingTF] text] });
    return info;
}

- (NSDictionary *)billingInfo {
    NSDictionary *info = (@{ @"name": [[self nameOnCardPaymentTF] text],
                                    @"address1": [[self addressLine1BillingTF] text],
                                    @"address2": [[self addressLine2BillingTF] text],
                                    @"country": [BTRViewUtility countryCodeforName:[[self countryBillingTF] text]],
                                    @"postal": [[self postalCodeBillingTF] text],
                                    @"state": [BTRViewUtility provinceCodeforName:[[self provinceBillingTF] text]],
                                    @"city": [[self cityBillingTF] text],
                                    @"phone": [[self phoneBillingTF] text] });
    return info;
}

- (NSDictionary *)cardInfo {
    
    BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
    NSString *paymentTypeToPass = [sharedPaymentTypes paymentTypeforCardDisplayName:[[self paymentMethodTF] text]];
    
    NSInteger expMonthInt = [[[[self expiryMonthPaymentTF] text] componentsSeparatedByString:@" -"][0] integerValue];
    NSString *expMonth = [NSString stringWithFormat:@"%ld", (long)expMonthInt];
    
    NSDictionary *info = (@{@"type": paymentTypeToPass,
                                @"name": [[self nameOnCardPaymentTF] text],
                                @"number": [[self cardNumberPaymentTF] text],
                                @"year": [[self expiryYearPaymentTF] text],
                                @"month": expMonth,
                                @"cvv": [[self cardVerificationPaymentTF] text],
                                @"use_token": @false,
                                @"token": @"295219000",
                                @"remember_card": @false });
    return info;
}

#pragma mark - UI


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadOrderData];
    
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
    self.paymentTypesArray = [sharedPaymentTypes creditCardDisplayNameArray];
}


- (void)loadOrderData {
    
    [self.recipientNameShippingTF setText:[self.order shippingRecipientName]];
    [self.addressLine1ShippingTF setText:[self.order shippingAddressLine1]];
    [self.addressLine2ShippingTF setText:[self.order shippingAddressLine2]];
    [self.countryShippingTF setText:[BTRViewUtility countryNameforCode:[self.order shippingCountry]]];
    [self.zipCodeShippingTF setText:[self.order shippingPostalCode]];
    [self.provinceShippingTF setText:[BTRViewUtility provinceNameforCode:[self.order shippingProvince]]];
    [self.cityShippingTF setText:[self.order shippingCity]];
    [self.phoneShippingTF setText:[self.order shippingPhoneNumber]];
    
    [self.addressLine1BillingTF setText:[self.order billingAddressLine1]];
    [self.addressLine2BillingTF setText:[self.order billingAddressLine2]];
    [self.countryBillingTF setText:[BTRViewUtility countryNameforCode:[self.order billingCountry]]];
    [self.postalCodeBillingTF setText:[self.order billingPostalCode]];
    [self.provinceBillingTF setText:[BTRViewUtility provinceNameforCode:[self.order billingProvince]]];
    [self.cityBillingTF setText:[self.order billingCity]];
    [self.phoneBillingTF setText:[self.order billingPhoneNumber]];
    
    [self.vipOptionCheckbox setChecked:[[self.order vipPickup] boolValue]];
    [self.sameAddressCheckbox setChecked:[[self.order billingSameAsShipping] boolValue]];
    [self.orderIsGiftCheckbox setChecked:[[self.order isGift] boolValue]];
    [self.remeberCardInfoCheckbox setChecked:[[self.order rememberCard] boolValue]];
    
    [self.vipOptionCheckbox addTarget:self action:@selector(checkboxVipOptionDidChange:) forControlEvents:UIControlEventValueChanged];
    [self checkboxVipOptionDidChange:self.vipOptionCheckbox];

    [self.sameAddressCheckbox addTarget:self action:@selector(checkboxSameAddressDidChange:) forControlEvents:UIControlEventValueChanged];
    [self checkboxSameAddressDidChange:self.vipOptionCheckbox];
    
    [self.bagTotalDollarLabel setText:[self.order bagTotalPrice]];
    [self.subtotalDollarLabel setText:[self.order subTotalPrice]];
    [self.gstTaxDollarLabel setText:[self.order gstTax]];
    [self.qstTaxDollarLabel setText:[self.order qstTax]];
    [self.orderTotalDollarLabel setText:[self.order orderTotalPrice]];
    [self.totalDueDollarLabel setText:[self.order allTotalPrice]];
    
    NSLog(@"SHOULD load_tax_and_dollars!") ;
    NSLog(@"PickUP UI not available on UI yet!");
    
    if ([[self.order vipPickupEligible] boolValue]) {
        [self.pleaseFillOutTheShippingFormView setHidden:TRUE];
        [self.vipOptionView setHidden:FALSE];
        
    } else if (![[self.order vipPickupEligible] boolValue]) {
        [self.pleaseFillOutTheShippingFormView setHidden:FALSE];
        [self.vipOptionView setHidden:TRUE];
    }
    
    
}

- (void) checkboxVipOptionDidChange:(CTCheckbox *)checkbox {
    
    if ([checkbox checked]) {
        
        [self.addressLine1ShippingTF setText:@"MONTREAL EMPLOYEE PICKUP"];
        [self.addressLine2ShippingTF setText:@"4600 HICKMORE"];
        [self.countryShippingTF setText:@"Canada"];
        [self.zipCodeShippingTF setText:@"H4T 1K2"];
        [self.provinceShippingTF setText:@"Quebec"];
        [self.cityShippingTF setText:@"SAINT-LAURENT"];
        [self.phoneShippingTF setText:@"613-735-0112"];
        
        [self disableShippingAddress];
        
    } else if (![checkbox checked]) {
        [self enableShippingAddress];
    }
}

- (void) disableShippingAddress {
    
    [self.sameAsShippingAddressView setHidden:TRUE];
    [self.sameAddressCheckbox setChecked:FALSE];
    
    [self.shippingCountryButton setEnabled:FALSE];
    [self.shippingStateButton setEnabled:FALSE];
    
    [self.addressLine1ShippingTF setEnabled:FALSE];
    [self.addressLine2ShippingTF setEnabled:FALSE];
    [self.countryShippingTF setEnabled:FALSE];
    [self.zipCodeShippingTF setEnabled:FALSE];
    [self.provinceShippingTF setEnabled:FALSE];
    [self.cityShippingTF setEnabled:FALSE];
    [self.phoneShippingTF setEnabled:FALSE];
    
    [self.addressLine1ShippingTF setAlpha:0.6f];
    [self.addressLine2ShippingTF setAlpha:0.6f];
    [self.countryShippingTF setAlpha:0.6f];
    [self.zipCodeShippingTF setAlpha:0.6f];
    [self.provinceShippingTF setAlpha:0.6f];
    [self.cityShippingTF setAlpha:0.6f];
    [self.phoneShippingTF setAlpha:0.6f];

}

- (void) enableShippingAddress {
    
    [self.sameAsShippingAddressView setHidden:FALSE];
    
    [self.shippingCountryButton setEnabled:TRUE];
    [self.shippingStateButton setEnabled:TRUE];
    
    [self.addressLine1BillingTF setEnabled:TRUE];
    [self.addressLine2BillingTF setEnabled:TRUE];
    [self.countryBillingTF setEnabled:TRUE];
    [self.postalCodeBillingTF setEnabled:TRUE];
    [self.provinceBillingTF setEnabled:TRUE];
    [self.cityBillingTF setEnabled:TRUE];
    [self.phoneBillingTF setEnabled:TRUE];
    
    [self.addressLine1BillingTF setAlpha:1.0f];
    [self.addressLine2BillingTF setAlpha:1.0f];
    [self.countryBillingTF setAlpha:1.0f];
    [self.postalCodeBillingTF setAlpha:1.0f];
    [self.provinceBillingTF setAlpha:1.0f];
    [self.cityBillingTF setAlpha:1.0f];
    [self.phoneBillingTF setAlpha:1.0f];
}

- (void) checkboxSameAddressDidChange:(CTCheckbox *)checkbox {
    
    if ([checkbox checked]) {
        
        [self.addressLine1BillingTF setText:[[self addressLine1ShippingTF] text]];
        [self.addressLine2BillingTF setText:[[self addressLine2ShippingTF] text]];
        [self.countryBillingTF setText:[[self countryShippingTF] text]];
        [self.postalCodeBillingTF setText:[[self zipCodeShippingTF] text]];
        [self.provinceBillingTF setText:[[self provinceShippingTF] text]];
        [self.cityBillingTF setText:[[self cityShippingTF] text]];
        [self.phoneBillingTF setText:[[self phoneShippingTF] text]];

        [self disableBillingAddress];
        
    } else if (![checkbox checked]) {
        [self enableBillingAddress];
    }
}

- (void) disableBillingAddress {
    
    [self.billingAddressView setUserInteractionEnabled:FALSE];
    
    [self.addressLine1BillingTF setEnabled:FALSE];
    [self.addressLine2BillingTF setEnabled:FALSE];
    [self.countryBillingTF setEnabled:FALSE];
    [self.postalCodeBillingTF setEnabled:FALSE];
    [self.provinceBillingTF setEnabled:FALSE];
    [self.cityBillingTF setEnabled:FALSE];
    [self.phoneBillingTF setEnabled:FALSE];
    
    [self.addressLine1BillingTF setAlpha:0.6f];
    [self.addressLine2BillingTF setAlpha:0.6f];
    [self.countryBillingTF setAlpha:0.6f];
    [self.postalCodeBillingTF setAlpha:0.6f];
    [self.provinceBillingTF setAlpha:0.6f];
    [self.cityBillingTF setAlpha:0.6f];
    [self.phoneBillingTF setAlpha:0.6f];
}

- (void) enableBillingAddress {
    
    [self.billingAddressView setUserInteractionEnabled:TRUE];
    
    [self.addressLine1BillingTF setEnabled:TRUE];
    [self.addressLine2BillingTF setEnabled:TRUE];
    [self.countryBillingTF setEnabled:TRUE];
    [self.postalCodeBillingTF setEnabled:TRUE];
    [self.provinceBillingTF setEnabled:TRUE];
    [self.cityBillingTF setEnabled:TRUE];
    [self.phoneBillingTF setEnabled:TRUE];
    
    [self.addressLine1BillingTF setAlpha:1.0f];
    [self.addressLine2BillingTF setAlpha:1.0f];
    [self.countryBillingTF setAlpha:1.0f];
    [self.postalCodeBillingTF setAlpha:1.0f];
    [self.provinceBillingTF setAlpha:1.0f];
    [self.cityBillingTF setAlpha:1.0f];
    [self.phoneBillingTF setAlpha:1.0f];
}

- (void) clearBillingAddress {
    [self.addressLine1BillingTF setText:@""];
    [self.addressLine2BillingTF setText:@""];
    [self.countryBillingTF setText:@""];
    [self.postalCodeBillingTF setText:@""];
    [self.provinceBillingTF setText:@""];
    [self.cityBillingTF setText:@""];
    [self.phoneBillingTF setText:@""];
}

- (void) clearShippingAddress {
    [self.addressLine1ShippingTF setText:@""];
    [self.addressLine2ShippingTF setText:@""];
    [self.countryShippingTF setText:@""];
    [self.zipCodeShippingTF setText:@""];
    [self.provinceShippingTF setText:@""];
    [self.cityShippingTF setText:@""];
    [self.phoneShippingTF setText:@""];
}

#pragma mark - Dissmiss Keyboard

/**
 
 Tap Recognizer conflicts with checkbox inside scrollView
 
 */

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}
- (IBAction)viewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)vipOptionViewTapped:(UIControl *)sender {
[self dismissKeyboard];
}
- (IBAction)shippingDetailsViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)billingAddressViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)sameAsShippingAddressViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)thisIsGiftViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)paymentDetailsViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)rememberCardViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)haveGiftCardView:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)processOrderViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)receiptViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}
- (IBAction)pleaseFillOutShippingFormViewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}




#pragma mark - PickerView Delegates

- (void)loadPickerViewforPickerType:(NSUInteger)pickerType andAddressType:(NSUInteger) addressType{
    
    [self setBillingOrShipping:addressType];
    [self loadPickerViewforPickerType:pickerType];
}

- (void)loadPickerViewforPickerType:(NSUInteger)pickerType {
    
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

    [self loadPickerViewforPickerType:EXPIRY_YEAR_PICKER];
}

- (IBAction)expiryMonthButtonTapped:(UIButton *)sender {
    
    [self loadPickerViewforPickerType:EXPIRY_MONTH_PICKER];
}

- (IBAction)paymentMethodButtonTapped:(UIButton *)sender {
    
    [self loadPickerViewforPickerType:PAYMENT_TYPE_PICKER];
}

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
    
    if ([self pickerType] == EXPIRY_MONTH_PICKER) {
        [self.expiryMonthPaymentTF setText:[[self expiryMonthsArray] objectAtIndex:row]];
    }
    
    if ([self pickerType] == EXPIRY_YEAR_PICKER) {
        [self.expiryYearPaymentTF setText:[[self expiryYearsArray] objectAtIndex:row]];
    }
    
    if ([self pickerType] == PAYMENT_TYPE_PICKER) {
        [self.paymentMethodTF setText:[[self paymentTypesArray] objectAtIndex:row]];
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
    
    if ([self pickerType] == EXPIRY_MONTH_PICKER)
        return [[self expiryMonthsArray] count];
    
    if ([self pickerType] == EXPIRY_YEAR_PICKER)
        return [[self expiryYearsArray] count];
    
    if ([self pickerType] == PAYMENT_TYPE_PICKER)
        return [[self paymentTypesArray] count];
    
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

    if ([self pickerType] == EXPIRY_MONTH_PICKER)
        return [[self expiryMonthsArray] objectAtIndex:row];
    
    if ([self pickerType] == EXPIRY_YEAR_PICKER)
        return [[self expiryYearsArray] objectAtIndex:row];
    
    if ([self pickerType] == PAYMENT_TYPE_PICKER)
        return [[self paymentTypesArray] objectAtIndex:row];
    
    return [[self countryNameArray] objectAtIndex:row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

#pragma mark - Credit Card RESTful Payment

- (void)makePaymentforSessionId:(NSString *)sessionId
                           success:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:[self shippingInfo] forKey:@"shipping"];
    [orderInfo setObject:[self billingInfo] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.sameAddressCheckbox checked]] forKey:@"billto_shipto"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.vipOptionCheckbox checked]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.orderIsGiftCheckbox checked]] forKey:@"is_gift"];
    [orderInfo setObject:@"" forKey:@"recipient_message"];
    //[orderInfo setObject:[NSNumber numberWithBool:[self.pickupAvailable checked]] forKey:@"is_pickup"];

    [params setObject:orderInfo forKey:@"orderInfo"];
    [params setObject:@"creditcard" forKey:@"paymentMethod"];
    [params setObject:[self cardInfo] forKey:@"cardInfo"];
    
    
    NSLog(@"---0-- - %@", params);

    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    [manager POST:[NSString stringWithFormat:@"%@", [BTROrderFetcher URLforCheckoutProcess]]
       parameters:(NSDictionary *)params success:^(AFHTTPRequestOperation *operation, id responseObject) {
           
           NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
           NSLog(@"------0--- ent:  %@", entitiesPropertyList);
           
           [self setOrder:[Order orderWithAppServerInfo:entitiesPropertyList]];
           success(entitiesPropertyList);
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           failure(error);
       }];
}


- (IBAction)processOrderTpped:(UIButton *)sender {
    
    // Validation
    
    if ([self isCompeletedForm]) {
        [self validateAddressViaAPI];
    }
    
    
    
    
    
//    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
//    
//    [self makePaymentforSessionId:[sessionSettings sessionId] success:^(NSString *successString) {
//        
//        //[self performSegueWithIdentifier:@"BTRTrackOrdersSegueIdentifier" sender:self];
//        
//    } failure:^(NSError *error) {
//        
//    }];

     
}


#pragma mark Validation

- (BOOL)isCompeletedForm {
    
    // checking address line
    if (self.addressLine1ShippingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill shipping address field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.addressLine1ShippingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.addressLine1ShippingTF.frame animated:YES];
        return NO;
    }
    if (self.zipCodeShippingTF.text.length < 6) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your shipping postal code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.zipCodeShippingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.zipCodeShippingTF.frame animated:YES];
        return NO;
    }
    if (!self.sameAddressCheckbox.checked && self.addressLine2BillingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill billing address field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.addressLine2BillingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.addressLine2BillingTF.frame animated:YES];
        return NO;
    }
    if (!self.sameAddressCheckbox.checked && self.postalCodeBillingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill billing postal code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.postalCodeBillingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.postalCodeBillingTF.frame animated:YES];
        return NO;
    }
    
    if (self.cardNumberPaymentTF.text.length > 20 || self.cardNumberPaymentTF.text.length < 13) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your Credit Card Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.cardNumberPaymentTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.cardNumberPaymentTF.frame animated:YES];
        return NO;
    }
    // form is completed
    // shoulf validate through webSerive API
    return YES;
}

- (void)validateAddressViaAPI {

    BTRSessionSettings *sessionSettings = [BTRSessionSettings sessionSettings];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[sessionSettings sessionId] forHTTPHeaderField:@"SESSION"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:[self shippingInfo] forKey:@"shipping"];
    [orderInfo setObject:[self billingInfo] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.vipOptionCheckbox checked]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:YES] forKey:@"is_pickup"];
    [params setObject:orderInfo forKey:@"orderInfo"];
    
    [manager POST:[NSString stringWithFormat:@"%@", [BTROrderFetcher URLforAddressValidation]]
       parameters:(NSDictionary *)params success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
           NSLog(@"------0--- ent:  %@", entitiesPropertyList);
           self.order = [Order extractOrderfromJSONDictionary:entitiesPropertyList forOrder:self.order];
           [self loadOrderData];
           
           //           [self setOrder:[Order orderWithAppServerInfo:entitiesPropertyList]]; 
           //           success(entitiesPropertyList);
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@",error);
       }];

}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end



















