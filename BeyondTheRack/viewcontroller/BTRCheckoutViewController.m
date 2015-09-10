//
//  BTRCheckoutViewController.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-12.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRCheckoutViewController.h"
#import "BTRPaymentTypesHandler.h"
#import "BTRConfirmationViewController.h"
#import "BTRPaypalCheckoutViewController.h"
#import "BTRMasterPassViewController.h"
#import "BTROrderFetcher.h"
#import "BTRPaypalFetcher.h"
#import "MasterPassInfo+Appserver.h"
#import "BTRMasterPassFetcher.h"
#import "Order+AppServer.h"
#import "Item.h"
#import "BTRConnectionHelper.h"

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

@property BOOL isLoading;
@property float totalSave;

@property paymentType currentPaymentType;
@property (strong, nonatomic) NSMutableArray* arrayOfGiftCards;
@property (strong, nonatomic) NSDictionary* paypal;
@property (strong, nonatomic) MasterPassInfo* masterpass;

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
    NSDictionary *info;
    if (self.changePaymentMethodCheckbox.checked == NO && [self.order.useToken boolValue])
        info = (@{
                  @"token" : self.order.cardToken,
                  @"ise_token" : @true,
                  @"remember_card" : [NSNumber numberWithBool:[self.remeberCardInfoCheckbox checked]]
                  });
    else
        info = (@{
                  @"type": paymentTypeToPass,
                  @"name": [[self nameOnCardPaymentTF] text],
                  @"number": [[self cardNumberPaymentTF] text],
                  @"year": [[self expiryYearPaymentTF] text],
                  @"month": expMonth,
                  @"cvv": [[self cardVerificationPaymentTF] text],
                  @"use_token": @false,
                  @"token": @"295219000",
                  @"remember_card": [NSNumber numberWithBool:[self.remeberCardInfoCheckbox checked]]
                  });
    
    return info;
}

#pragma mark FastPayment

- (IBAction)paypalCheckoutTapped:(id)sender {
    if (self.changePaymentMethodCheckbox.checked) {
        [self.changePaymentMethodCheckbox setChecked:NO];
        [self fillPaymentInfoWithCurrentData];
    }
    
    if (!self.changePaymentMethodCheckbox.checked) {
        if (self.currentPaymentType == paypal) {
            [[[UIAlertView alloc]initWithTitle:@"PayPal" message:@"Your current payment method is Paypal, Continue to checkout" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            return;
        }else {
            [self.changePaymentMethodCheckbox setChecked:YES];
            [self checkboxChangePaymentMethodDidChange:self.changePaymentMethodCheckbox];
        }
    }
    [self.paymentMethodTF setText:@"Paypal"];
    [self setCurrentPaymentType:paypal];
    [self changeDetailPaymentFor:paypal];
    [[[UIAlertView alloc]initWithTitle:@"PayPal" message:@"Paypal has been selected as payment method, please fill form" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
}

- (IBAction)masterPassCheckoutTapped:(id)sender {
    if (!self.changePaymentMethodCheckbox.checked && self.currentPaymentType != masterPass) {
        [self.changePaymentMethodCheckbox setChecked:YES];
        [self checkboxChangePaymentMethodDidChange:self.changePaymentMethodCheckbox];
    }
    [self.paymentMethodTF setText:@"MasterPass"];
    [self setCurrentPaymentType:masterPass];
    [self changeDetailPaymentFor:masterPass];
    [[[UIAlertView alloc]initWithTitle:@"MasterPass" message:@"MasterPass has been selected as payment method, please fill form" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // setting default value
    [self setChosenShippingCountryString:@"Canada"];
    [self setChosenBillingCountryString:@"Canada"];
    [self setCurrentPaymentType:creditCard];
    [self.paymentMethodTF setText:@"Visa Credit"];
    [self.changePaymentMethodCheckbox setChecked:NO];
    
    [self resetData];
    [self loadOrderData];
    
    [self fillPaymentInfoWithCurrentData];
    
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger currentYear = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    
    for (NSInteger i = currentYear; i < 21 + currentYear; i++)
        [[self expiryYearsArray] addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    
    self.pickerView.delegate = self;
    [self.pickerParentView setHidden:TRUE];
    
    // setting checkboxes
    [self setCheckboxesTargets];
    
    // hidding gift info
    [self.giftLabel setHidden:YES];
    [self.giftDollarLabel setHidden:YES];
    
    BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
    self.paymentTypesArray = [sharedPaymentTypes creditCardDisplayNameArray];
}

- (void)resetData {
    self.arrayOfGiftCards = [[NSMutableArray alloc]init];
    self.totalSave = 0;
}

- (void)loadOrderData {
    self.isLoading = YES;
    
    // card info
    // check payment method
    
    // shipping
    [self.recipientNameShippingTF setText:[self.order shippingRecipientName]];
    [self.addressLine1ShippingTF setText:[[self.order shippingAddress]addressLine1]];
    [self.addressLine2ShippingTF setText:[[self.order shippingAddress]addressLine2]];
    [self.countryShippingTF setText:[BTRViewUtility countryNameforCode:[[self.order shippingAddress]country]]];
    [self.zipCodeShippingTF setText:[[self.order shippingAddress]postalCode]];
    [self.provinceShippingTF setText:[BTRViewUtility provinceNameforCode:[[self.order shippingAddress]province]]];
    [self.cityShippingTF setText:[[self.order shippingAddress]city]];
    [self.phoneShippingTF setText:[[self.order shippingAddress]phoneNumber]];
    
    // billing
    [self.addressLine1BillingTF setText:[[self.order billingAddress]addressLine1]];
    [self.addressLine2BillingTF setText:[[self.order billingAddress]addressLine2]];
    [self.countryBillingTF setText:[BTRViewUtility countryNameforCode:[[self.order billingAddress]country]]];
    [self.postalCodeBillingTF setText:[[self.order billingAddress]postalCode]];
    [self.provinceBillingTF setText:[BTRViewUtility provinceNameforCode:[[self.order billingAddress]province]]];
    [self.cityBillingTF setText:[[self.order billingAddress]city]];
    [self.phoneBillingTF setText:[[self.order billingAddress]phoneNumber]];
    
    // checkboxes
    [self.vipOptionCheckbox setChecked:[[self.order vipPickup] boolValue]];
    [self.sameAddressCheckbox setChecked:[[self.order billingSameAsShipping] boolValue]];
    [self.orderIsGiftCheckbox setChecked:[[self.order isGift] boolValue]];
    [self.pickupOptionCheckbox setChecked:[[self.order isPickup] boolValue]];
    [self.remeberCardInfoCheckbox setChecked:[[self.order rememberCard] boolValue]];
    
    [self checkboxVipOptionDidChange:self.vipOptionCheckbox];
    [self checkboxSameAddressDidChange:self.sameAddressCheckbox];
    [self checkboxPickupOptionDidChange:self.pickupOptionCheckbox];
    [self checkboxChangePaymentMethodDidChange:self.changePaymentMethodCheckbox];
    
    // prices
    if (self.totalSave == 0)
        for (Item* item  in self.order.items)
            self.totalSave = self.totalSave + (item.retailPrice.floatValue - item.salePrice.floatValue);
    
    [self.bagTotalDollarLabel setText:[self.order bagTotalPrice]];
    [self.subtotalDollarLabel setText:[self.order subTotalPrice]];
    [self.shippingDollarLabel setText:[self.order shippingPrice]];
    
    // calculating taxes
    [self.gstTaxDollarLabel setText:[NSString stringWithFormat:@"%.2f",[self.order gstTax].floatValue]];
    [self.qstTaxDollarLabel setText:[NSString stringWithFormat:@"%.2f",[self.order qstTax].floatValue]];
    if (self.order.gstTax == nil) {
        [self.gstTaxLebl setHidden:YES];
        [self.gstTaxDollarLabel setHidden:YES];
    }
    else {
        [self.gstTaxLebl setHidden:NO];
        [self.gstTaxDollarLabel setHidden:NO];
    }
    if (self.order.qstTax == nil) {
        [self.qstTaxLabel setHidden:YES];
        [self.qstTaxDollarLabel setHidden:YES];
    }
    else {
        [self.qstTaxLabel setHidden:NO];
        [self.qstTaxDollarLabel setHidden:NO];
    }
    
    // Caculating prices
//    [self.orderTotalDollarLabel setText:[NSString stringWithFormat:@"%.2f",self.subtotalDollarLabel.text.floatValue + self.gstTaxDollarLabel.text.floatValue + self.qstTaxDollarLabel.text.floatValue + self.shippingDollarLabel.text.floatValue]];
    
    [self.orderTotalDollarLabel setText:[NSString stringWithFormat:@"%.2f",[self.order.orderTotalPrice floatValue]]];
    [self.youSaveDollarLabel setText:[NSString stringWithFormat:@"%.2f",[self.order.saving floatValue]]];
    [self.totalDueDollarLabel setText:self.orderTotalDollarLabel.text];
    
    
    // pickup
    if ([[self.order vipPickupEligible] boolValue]) {
        [self.pleaseFillOutTheShippingFormView setHidden:TRUE];
        [self.vipOptionView setHidden:FALSE];
        
    } else if (![[self.order vipPickupEligible] boolValue]) {
        [self.pleaseFillOutTheShippingFormView setHidden:FALSE];
        [self.vipOptionView setHidden:TRUE];
        [self.pickupView setHidden:![[self.order eligiblePickup] boolValue]];
    }
    self.isLoading = NO;
}

- (void)setCheckboxesTargets {
    [self.vipOptionCheckbox addTarget:self action:@selector(checkboxVipOptionDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.sameAddressCheckbox addTarget:self action:@selector(checkboxSameAddressDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.pickupOptionCheckbox addTarget:self action:@selector(checkboxPickupOptionDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.changePaymentMethodCheckbox addTarget:self action:@selector(checkboxChangePaymentMethodDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.orderIsGiftCheckbox addTarget:self action:@selector(checkboxIsGiftChange:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)shippingFieldChanged:(id)sender {
    if (self.sameAddressCheckbox.checked)
        [self copyShipingAddressToBillingAddress];
}

-(void)checkboxChangePaymentMethodDidChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    
    if ([checkbox checked]) {
        [self enablePaymentInfo];
        [self clearPaymentInfo];
        [self changeDetailPaymentFor:creditCard];
        [self setCurrentPaymentType:creditCard];
        [self.paymentMethodTF setText:@"Visa Credit"];
    } else {
        [self fillPaymentInfoWithCurrentData];
        [self.cardVerificationPaymentTF setText:@"xxx"];
        [self disablePaymentInfo];
    }
}

- (void)checkboxVipOptionDidChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    
    if ([checkbox checked]) {
        
        [self.addressLine1ShippingTF setText:self.order.pickupAddress.addressLine1];
        [self.addressLine2ShippingTF setText:self.order.pickupAddress.addressLine2];
        [self.countryShippingTF setText:[BTRViewUtility countryNameforCode:self.order.pickupAddress.country]];
        [self.zipCodeShippingTF setText:self.order.pickupAddress.postalCode];
        [self.provinceShippingTF setText:[BTRViewUtility provinceNameforCode:self.order.pickupAddress.province]];
        [self.cityShippingTF setText:self.order.pickupAddress.city];
        [self.recipientNameShippingTF setText:self.order.pickupTitle];
        [self.phoneShippingTF setText:@"613-735-0112"];
        
        [self disableShippingAddress];
        
    } else if (![checkbox checked]) {
        [self clearShippingAddress];
        [self enableShippingAddress];
    }
    [self validateAddressViaAPIAndInCompletion:nil];
}

- (void)checkboxPickupOptionDidChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    
    if ([checkbox checked]) {
        [self.addressLine1ShippingTF setText:self.order.pickupAddress.addressLine1];
        [self.addressLine2ShippingTF setText:self.order.pickupAddress.addressLine2];
        [self.countryShippingTF setText:[BTRViewUtility countryNameforCode:self.order.pickupAddress.country]];
        [self.zipCodeShippingTF setText:self.order.pickupAddress.postalCode];
        [self.provinceShippingTF setText:[BTRViewUtility provinceNameforCode:self.order.pickupAddress.province]];
        [self.cityShippingTF setText:self.order.pickupAddress.city];
        [self.recipientNameShippingTF setText:self.order.pickupTitle];
        [self.phoneShippingTF setText:@"613-735-0112"];
        [self disableShippingAddress];

    } else if (![checkbox checked]) {
        [self clearShippingAddress];
        [self enableShippingAddress];
    }
    [self validateAddressViaAPIAndInCompletion:nil];
}

- (void)disableShippingAddress {
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

- (void)enableShippingAddress {
    [self.sameAsShippingAddressView setHidden:FALSE];
    
    [self.shippingCountryButton setEnabled:TRUE];
    [self.shippingStateButton setEnabled:TRUE];
    
    [self.addressLine1ShippingTF setEnabled:TRUE];
    [self.addressLine2ShippingTF setEnabled:TRUE];
    [self.countryShippingTF setEnabled:TRUE];
    [self.zipCodeShippingTF setEnabled:TRUE];
    [self.provinceShippingTF setEnabled:TRUE];
    [self.cityShippingTF setEnabled:TRUE];
    [self.phoneShippingTF setEnabled:TRUE];
    
    [self.addressLine1ShippingTF setAlpha:1.0f];
    [self.addressLine2ShippingTF setAlpha:1.0f];
    [self.countryShippingTF setAlpha:1.0f];
    [self.zipCodeShippingTF setAlpha:1.0f];
    [self.provinceShippingTF setAlpha:1.0f];
    [self.cityShippingTF setAlpha:1.0f];
    [self.phoneShippingTF setAlpha:1.0f];
}

- (void)checkboxIsGiftChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    
    if (checkbox.checked) {
        self.giftViewHeight.constant = 250;
        self.viewHeight.constant = self.viewHeight.constant + 175;
    }else {
        self.giftCardInfoView.hidden = YES;
        self.giftViewHeight.constant = 75;
        self.viewHeight.constant = self.viewHeight.constant - 175;
    }
    [UIView animateWithDuration:2
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if ([checkbox checked]) {
                             self.giftCardInfoView.hidden = NO;
                         }
                     }];
}

- (void)checkboxSameAddressDidChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    
    if ([checkbox checked]) {
        [self enableBillingAddress];
        [self copyShipingAddressToBillingAddress];
        [self disableBillingAddress];
        if (self.zipCodeShippingTF.text.length > 0)
            [self validateAddressViaAPIAndInCompletion:nil];
    } else if (![checkbox checked]) {
        [self enableBillingAddress];
        [self clearBillingAddress];
    }
}

- (void)copyShipingAddressToBillingAddress {
    [self.addressLine1BillingTF setText:[[self addressLine1ShippingTF] text]];
    [self.addressLine2BillingTF setText:[[self addressLine2ShippingTF] text]];
    [self.countryBillingTF setText:[[self countryShippingTF] text]];
    [self.postalCodeBillingTF setText:[[self zipCodeShippingTF] text]];
    [self.provinceBillingTF setText:[[self provinceShippingTF] text]];
    [self.cityBillingTF setText:[[self cityShippingTF] text]];
    [self.phoneBillingTF setText:[[self phoneShippingTF] text]];
}

- (void)disableBillingAddress {
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

- (void)enableBillingAddress {
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

- (void)clearBillingAddress {
    [self.addressLine1BillingTF setText:@""];
    [self.addressLine2BillingTF setText:@""];
    [self.countryBillingTF setText:@""];
    [self.postalCodeBillingTF setText:@""];
    [self.provinceBillingTF setText:@""];
    [self.cityBillingTF setText:@""];
    [self.phoneBillingTF setText:@""];
}

- (void)clearShippingAddress {
    [self.addressLine1ShippingTF setText:@""];
    [self.addressLine2ShippingTF setText:@""];
    [self.countryShippingTF setText:@""];
    [self.zipCodeShippingTF setText:@""];
    [self.provinceShippingTF setText:@""];
    [self.cityShippingTF setText:@""];
    [self.phoneShippingTF setText:@""];
}

- (void)disablePaymentInfo {
    [self.paymentMethodTF setEnabled:NO];
    [self.cardNumberPaymentTF setEnabled:NO];
    [self.cardVerificationPaymentTF setEnabled:NO];
    [self.nameOnCardPaymentTF setEnabled:NO];
    [self.expiryYearPaymentTF setEnabled:NO];
    [self.expiryMonthPaymentTF setEnabled:NO];
    [self.paypalEmailTF setEnabled:NO];
    [self.paymentMethodButton setEnabled:NO];
    
    [self.paymentMethodTF setAlpha:0.6f];
    [self.cardNumberPaymentTF setAlpha:0.6f];
    [self.cardVerificationPaymentTF setAlpha:0.6f];
    [self.nameOnCardPaymentTF setAlpha:0.6f];
    [self.expiryMonthPaymentTF setAlpha:0.6f];
    [self.expiryYearPaymentTF setAlpha:0.6f];
    [self.paypalEmailTF setAlpha:0.6f];
}

- (void)enablePaymentInfo {
    [self.paymentMethodTF setEnabled:YES];
    [self.cardNumberPaymentTF setEnabled:YES];
    [self.cardVerificationPaymentTF setEnabled:YES];
    [self.nameOnCardPaymentTF setEnabled:YES];
    [self.expiryYearPaymentTF setEnabled:YES];
    [self.expiryMonthPaymentTF setEnabled:YES];
    [self.paymentMethodButton setEnabled:YES];
    [self.paypalEmailTF setEnabled:YES];
    
    [self.paymentMethodTF setAlpha:1.0f];
    [self.cardNumberPaymentTF setAlpha:1.0f];
    [self.cardVerificationPaymentTF setAlpha:1.0f];
    [self.nameOnCardPaymentTF setAlpha:1.0f];
    [self.expiryMonthPaymentTF setAlpha:1.0f];
    [self.expiryYearPaymentTF setAlpha:1.0f];
    [self.paypalEmailTF setAlpha:1.0f];
}

- (void)fillPaymentInfoWithCurrentData {
    if ([self.order.paymentType isEqualToString:@"paypal"]) {
        [self.paymentMethodTF setText:@"Paypal"];
        [self setCurrentPaymentType:paypal];
        if  (self.order.billingName.length > 0)
            self.paypalEmailTF.text = self.order.billingName;
    }
    else {
        if  (self.order.billingName.length > 0)
            self.nameOnCardPaymentTF.text = self.order.billingName;
        if (self.cardNumberPaymentTF.text.length == 0)
            [self.cardNumberPaymentTF setText:self.order.cardNumber];
        if (self.expiryYearPaymentTF.text.length == 0)
            [self.expiryYearPaymentTF setText:[self.order expiryYear]];
        if (self.order.expiryMonth.length > 0)
            [self.expiryMonthPaymentTF setText:[self.expiryMonthsArray objectAtIndex:[[self.order expiryMonth]intValue] - 1]];
        if (self.order.cardType.length > 0 && self.order.cardType.length > 0 )
            [self.paymentMethodTF setText:[[BTRPaymentTypesHandler sharedPaymentTypes]cardDisplayNameForType:self.order.cardType]];
        [self setCurrentPaymentType:creditCard];
    }
    if ([self.order.lockCCFields boolValue] || self.currentPaymentType == paypal) {
        [self.changePaymentMethodView setHidden:NO];
        [self disablePaymentInfo];
        if (self.currentPaymentType == creditCard)
            [self.cardVerificationPaymentTF setText:@"xxx"];
    }
    else
        [self.changePaymentMethodView setHidden:YES];
    
    [self changeDetailPaymentFor:self.currentPaymentType];
}

- (void)clearPaymentInfo {
    [self.paymentMethodTF setText:@""];
    [self.cardNumberPaymentTF setText:@""];
    [self.cardVerificationPaymentTF setText:@""];
    [self.nameOnCardPaymentTF setText:@""];
    [self.expiryYearPaymentTF setText:@""];
    [self.expiryMonthPaymentTF setText:@""];
    [self.paypalEmailTF setText:@""];
}

- (void)changeDetailPaymentFor:(paymentType)type {
    if (type == creditCard) {
        self.creditCardDetailHeight.constant = 310;
        [UIView animateWithDuration:1.0 animations:^{
            self.paypalDetailsView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 animations:^{
                self.paymentDetailsView.alpha = 1;
            }];
            self.paymentDetailsView.hidden = NO;
            self.paypalDetailsView.hidden = YES;
        }];
    }else if (type == paypal) {
        if (self.paypalEmailTF.text.length > 0) {
            self.paypalEmailTF.hidden = NO;
            self.creditCardDetailHeight.constant = 160;
        }
        else {
            self.paypalEmailTF.hidden = YES;
            self.creditCardDetailHeight.constant = 0;
        }
        [UIView animateWithDuration:1.0 animations:^{
            self.paymentDetailsView.alpha = 0;
        }completion:^(BOOL finished) {
            self.paymentDetailsView.hidden = YES;
            self.paypalDetailsView.hidden = NO;
            [UIView animateWithDuration:1.0 animations:^{
                self.paypalDetailsView.alpha = 1;
            }];
        }];
    } else if (type == masterPass) {
        self.paymentDetailsView.hidden = YES;
        self.paypalEmailTF.hidden = YES;
        self.creditCardDetailHeight.constant = 0;
    }
    
    [UIView animateWithDuration:2
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark - Dissmiss Keyboard

/**
 
 Tap Recognizer conflicts with checkbox inside scrollView
 
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

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

- (void)loadPickerViewforPickerType:(NSUInteger)pickerType andAddressType:(NSUInteger) addressType {
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
        if ([self billingOrShipping] == BILLING_ADDRESS)
            [self.provinceBillingTF setText:[[self provincesArray] objectAtIndex:row]];
        else if ([self billingOrShipping] == SHIPPING_ADDRESS)
            [self.provinceShippingTF setText:[[self provincesArray] objectAtIndex:row]];
    }
    
    if ([self pickerType] == STATE_PICKER) {
        if ([self billingOrShipping] == BILLING_ADDRESS)
            [self.provinceBillingTF setText:[[self statesArray] objectAtIndex:row]];
        else if ([self billingOrShipping] == SHIPPING_ADDRESS)
            [self.provinceShippingTF setText:[[self statesArray] objectAtIndex:row]];
    }
    
    if ([self pickerType] == COUNTRY_PICKER) {
        if ([self billingOrShipping] == BILLING_ADDRESS)
            [self.countryBillingTF setText:[[self countryNameArray] objectAtIndex:row]];
        else if ([self billingOrShipping] == SHIPPING_ADDRESS)
            [self.countryShippingTF setText:[[self countryNameArray] objectAtIndex:row]];
    }
    
    if ([self pickerType] == EXPIRY_MONTH_PICKER)
        [self.expiryMonthPaymentTF setText:[[self expiryMonthsArray] objectAtIndex:row]];
    
    if ([self pickerType] == EXPIRY_YEAR_PICKER)
        [self.expiryYearPaymentTF setText:[[self expiryYearsArray] objectAtIndex:row]];
    
    if ([self pickerType] == PAYMENT_TYPE_PICKER) {
        [self.paymentMethodTF setText:[[self paymentTypesArray] objectAtIndex:row]];
        if ([self.paymentMethodTF.text isEqualToString:@"Paypal"]) {
            [self setCurrentPaymentType:paypal];
        }else if ([self.paymentMethodTF.text isEqualToString:@"MasterPass"]) {
            [self setCurrentPaymentType:masterPass];
        }else{
            [self setCurrentPaymentType:creditCard];
        }
        [self changeDetailPaymentFor:self.currentPaymentType];
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
    return 300.0;
}

#pragma mark - Credit Card RESTful Payment

- (void)makePaymentWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforCheckoutProcess]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:[self shippingInfo] forKey:@"shipping"];
    [orderInfo setObject:[self billingInfo] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.sameAddressCheckbox checked]] forKey:@"billto_shipto"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.vipOptionCheckbox checked]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.orderIsGiftCheckbox checked]] forKey:@"is_gift"];
    [orderInfo setObject:[self.giftMessageTF text] forKey:@"recipient_message"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.pickupOptionCheckbox checked]] forKey:@"is_pickup"];
    
    [params setObject:orderInfo forKey:@"orderInfo"];
    [params setObject:[self cardInfo] forKey:@"cardInfo"];
    [params setObject:@"creditcard" forKey:@"paymentMethod"];
    
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [self setOrder:[Order orderWithAppServerInfo:response]];
        success(response);
    } faild:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (IBAction)processOrderTpped:(UIButton *)sender {
    if (![self isShippingAddressCompeleted])
        return;
    if (self.currentPaymentType == creditCard && [self isBillingAddressCompeleted] && [self isCardInfoCompeleted]) {
        [self validateAddressViaAPIAndInCompletion:^() {
            [self makePaymentWithSuccess:^(id responseObject) {
                   [self orderConfirmationWithReceipt:responseObject];
               } failure:^(NSError *error) {
                   NSLog(@"%@",error);
               }];
        }];
    } else if (self.currentPaymentType == paypal) {
        [self validateAddressViaAPIAndInCompletion:^() {
            [self getPaypalInfo];
        }];
    } else if (self.currentPaymentType == masterPass){
        [self validateAddressViaAPIAndInCompletion:^() {
            [self getMasterPassInfo];
        }];
    }
}

#pragma mark Validation

- (IBAction)zipCodeHasBeenEntererd:(id)sender {
    [self validateAddressViaAPIAndInCompletion:nil];
}

- (BOOL)isShippingAddressCompeleted {
    // checking address line
    if (self.addressLine1ShippingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill shipping address field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.addressLine1ShippingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.addressLine1ShippingTF.frame animated:YES];
        return NO;
    }
    if ((self.zipCodeShippingTF.text.length < 5 && [self.countryShippingTF.text isEqualToString:@"USA"]) || (self.zipCodeShippingTF.text.length < 6 && [self.countryShippingTF.text isEqualToString:@"Canada"])) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your shipping postal code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.zipCodeShippingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.zipCodeShippingTF.frame animated:YES];
        return NO;
    }
    return YES;
}

- (BOOL)isBillingAddressCompeleted {
    // Checking billing address
    if (self.addressLine1BillingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill billing address field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.addressLine1BillingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.addressLine1BillingTF.frame animated:YES];
        return NO;
    }
    if ((self.postalCodeBillingTF.text.length < 5 && [self.countryBillingTF.text isEqualToString:@"USA"]) || (self.postalCodeBillingTF.text.length < 6 && [self.countryBillingTF.text isEqualToString:@"Canada"])) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your shipping postal code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.postalCodeBillingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.postalCodeBillingTF.frame animated:YES];
        return NO;
    }
    return YES;
}

- (BOOL)isCardInfoCompeleted {
    if (self.nameOnCardPaymentTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fill name on card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.nameOnCardPaymentTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.nameOnCardPaymentTF.frame animated:YES];
        return NO;
    }
    if (self.cardNumberPaymentTF.isEnabled && (self.cardNumberPaymentTF.text.length > 20 || self.cardNumberPaymentTF.text.length < 13)) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your Credit Card Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.cardNumberPaymentTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.cardNumberPaymentTF.frame animated:YES];
        return NO;
    }
    if (self.cardVerificationPaymentTF.text.length < 3 || self.cardVerificationPaymentTF.text.length > 4) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your Credit Card Verification Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.cardVerificationPaymentTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.cardVerificationPaymentTF.frame animated:YES];
        return NO;
    }
    return YES;
}

- (void)validateAddressViaAPIAndInCompletion:(void(^)())completionBlock; {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:[self shippingInfo] forKey:@"shipping"];
    [orderInfo setObject:[self billingInfo] forKey:@"billing"];
    if (self.currentPaymentType == creditCard)
        [orderInfo setObject:[self cardInfo] forKey:@"cardInfo"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.sameAddressCheckbox checked]] forKey:@"billto_shipto"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.orderIsGiftCheckbox checked]] forKey:@"is_gift"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.vipOptionCheckbox checked]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.pickupOptionCheckbox checked]] forKey:@"is_pickup"];
    [params setObject:orderInfo forKey:@"orderInfo"];

    
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforAddressValidation]];
   [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
       self.order = [Order extractOrderfromJSONDictionary:response forOrder:self.order];
       [self loadOrderData];
       if (completionBlock)
           completionBlock(nil);
   } faild:^(NSError *error) {
       
   }];
}

- (void)orderConfirmationWithReceipt:(NSDictionary *)receipt {
    if (self.order.isAccepted) {
        [self performSegueWithIdentifier:@"BTRConfirmationSegueIdentifier" sender:self];
    } else if ([[[receipt valueForKey:@"orderInfo"]valueForKey:@"errors"] containsString:@"3002"] || [[[receipt valueForKey:@"orderInfo"]valueForKey:@"errors"] containsString:@"3001"]) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your Credit Card Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.cardNumberPaymentTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.cardNumberPaymentTF.frame animated:YES];
    } else if ([[[receipt valueForKey:@"orderInfo"]valueForKey:@"errors"] containsString:@"3006"]) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"You submitted an expired credit card number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
    }
    
}

#pragma mark giftcard adding

- (IBAction)checkAndValidateGiftCard:(id)sender {
    if ([self.arrayOfGiftCards containsObject:self.giftCardCodePaymentTF.text]) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"This gift card is already used" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }
    
    if (self.giftCardCodePaymentTF.text.length < 3) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please re-check your gift card code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        return;
    }
    
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforGiftCardRedeem]];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:self.giftCardCodePaymentTF.text,@"code", nil];
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
            [self validateAddressViaAPIAndInCompletion:^{
                 if ([[response valueForKey:@"success"]boolValue]) {
                    [[[UIAlertView alloc]initWithTitle:@"Gift" message:[NSString stringWithFormat:@"%@$ has been added sucessfully",[response valueForKey:@"amount"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                    
                    // adding text for gift
                    float sumOfGifts = [self.giftDollarLabel.text floatValue] - [[response valueForKey:@"amount"]floatValue];
                    self.giftDollarLabel.text = [NSString stringWithFormat:@"%.2f",sumOfGifts];
                    self.giftDollarLabel.textColor = [UIColor redColor];
                    [self.giftDollarLabel setHidden:NO];
                    [self.giftLabel setHidden:NO];
                    
                    // save used gift cards
                    [self.arrayOfGiftCards addObject:self.giftCardCodePaymentTF.text];
                 } else {
                     [[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"Your Gift Number is Not Vaild"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                 }
            }];
        } faild:^(NSError *error) {
            NSLog(@"%@",error);
        }
     ];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"]) {
        BTRConfirmationViewController* confirm = [segue destinationViewController];
        confirm.order = self.order;
    } else if ([[segue identifier]isEqualToString:@"BTRPaypalCheckoutSegueIdentifier"]) {
        BTRPaypalCheckoutViewController* paypalVC = [segue destinationViewController];
        paypalVC.paypal = self.paypal;
        paypalVC.isNewAccount = self.changePaymentMethodCheckbox.checked;
    } else if ([[segue identifier]isEqualToString:@"BTRMasterPassCheckoutSegueIdentifier"]) {
        BTRMasterPassViewController* mpVC = [segue destinationViewController];
        mpVC.info = self.masterpass;
    }
}

#pragma mark Paypal

- (void)getPaypalInfo {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRPaypalFetcher URLforStartPaypal]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            [self setPaypal:response];
            [self performSegueWithIdentifier:@"BTRPaypalCheckoutSegueIdentifier" sender:self];
        }
    } faild:^(NSError *error) {
        
    }];
}

- (void)getMasterPassInfo {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRMasterPassFetcher URLforStartMasterPass]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            MasterPassInfo* master = [MasterPassInfo masterPassInfoWithAppServerInfo:response];
            self.masterpass= master;
            [self performSegueWithIdentifier:@"BTRMasterPassCheckoutSegueIdentifier" sender:self];
        }
    } faild:^(NSError *error) {
        
    }];
}

@end



















