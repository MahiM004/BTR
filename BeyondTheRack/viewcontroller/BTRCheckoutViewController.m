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
#import "BTROrderFetcher.h"
#import "BTRPaypalFetcher.h"
#import "BTRUserFetcher.h"
#import "MasterPassInfo+Appserver.h"
#import "BTRMasterPassFetcher.h"
#import "Order+AppServer.h"
#import "Item.h"
#import "BTRConnectionHelper.h"
#import "BTRLoadingButton.h"
#import "HTMLAttributedString.h"
#import "ConfirmationInfo+AppServer.h"
#import "Freeship+appServer.h"
#import "BTRFreeshipFetcher.h"
#import "BTRLoader.h"

#import "BTRHelpViewController.h"
#import "BTRFAQFetcher.h"
#import "FAQ.h"
#import "FAQ+AppServer.h"

#define COUNTRY_PICKER          1
#define PROVINCE_PICKER         2
#define STATE_PICKER            3
#define EXPIRY_YEAR_PICKER      4
#define EXPIRY_MONTH_PICKER     5
#define PAYMENT_TYPE_PICKER     6

#define BILLING_ADDRESS         1
#define SHIPPING_ADDRESS        2

#define BILLING_ADDRESS_HEIGHT 685.0
#define BILLING_ADDRESS_HEIGHT_IPAD 552.0
#define CARD_PAYMENT_HEIGHT 310.0
#define PAYPAL_PAYMENT_HEIGHT 160.0
#define PAYPAL_PAYMENT_HEIGHT_IPAD 150.0
#define CARD_PAYMENT_TIP_HEIGHT 65.0
#define SAMPLE_GIFT_HEIGHT 120.0
#define FASTPAYMENT_HEIGHT 110.0
#define CHECKBOXES_HEIGHT 45.0
#define FILL_SHIPPING_HEIGHT 50.0
#define GIFT_MAX_HEIGHT 175.0
#define GIFT_CARD_HEIGHT 40.0
#define REMEBER_CARD_INFO_HEIGHT 75.0

#define DEFAULT_VIEW_HEIGHT_IPHONE 3250
#define DEFAULT_VIEW_HEIGHT_IPAD 1850


@class CTCheckbox;


@interface BTRCheckoutViewController () {
    BOOL shouldCallOnceInLaunch;
}
@property (nonatomic, strong) UIPopoverController *userDataPopover;
@property (strong, nonatomic) Freeship* freeshipInfo;

@property BOOL isLoading;
@property BOOL comeFromMasterPass;
@property BOOL isVisible;
@property float totalSave;

@property (nonatomic, strong) NSArray *faqArray;

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

@property paymentType currentPaymentType;

@property (strong, nonatomic) NSMutableArray *arrayOfGiftCards;
@property (strong, nonatomic) NSMutableArray *arrayOfVanityCodes;

@property (strong, nonatomic) MasterPassInfo *masterpass;
@property (strong, nonatomic) ApplePayManager *applePayManager;

@property (strong, nonatomic) NSMutableArray *selectedGift;
@property (strong, nonatomic) NSMutableArray *deSelectedGift;
@property (strong, nonatomic) ConfirmationInfo *confirmationInfo;

@property (strong, nonatomic) Address *savedShippingAddress;

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
    NSString *paymentTypeToPass;
    if (self.currentPaymentType == paypal)
        paymentTypeToPass = @"";
    else
        paymentTypeToPass = [sharedPaymentTypes paymentTypeforCardDisplayName:[[self paymentMethodTF] text]];
    
    NSInteger expMonthInt = [[[[self expiryMonthPaymentTF] text] componentsSeparatedByString:@" -"][0] integerValue];
    NSString *expMonth = [NSString stringWithFormat:@"%ld", (long)expMonthInt];
    NSDictionary *info;
    if (self.changePaymentMethodCheckbox.checked == NO && [self.order.useToken boolValue])
        info = (@{
                  @"token" : self.order.cardToken,
                  @"use_token" : [NSNumber numberWithBool:YES],
                  @"payment_type" : @""
                  });
    else
        info = (@{
                  @"type": paymentTypeToPass,
                  @"name": [[self nameOnCardPaymentTF] text],
                  @"number": [[self cardNumberPaymentTF] text],
                  @"year": [[self expiryYearPaymentTF] text],
                  @"month": expMonth,
                  @"cvv": [[self cardVerificationPaymentTF] text],
                  @"use_token": [NSNumber numberWithBool:NO],
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
    [self getMasterPassInfo];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [CardIOUtilities preload];
    [self resetData];
    [self setCheckboxesTargets];
    [self getImage];
    shouldCallOnceInLaunch = YES;
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentYear = [components year];
    
    for (NSInteger i = currentYear; i < 21 + currentYear; i++)
        [[self expiryYearsArray] addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    
    
    self.expiryYearPaymentTF.text = [[self expiryYearsArray]firstObject];
    self.expiryMonthPaymentTF.text = [[self expiryMonthsArray]firstObject];
    // hidding gift info
    [self.giftLabel setHidden:YES];
    [self.giftDollarLabel setHidden:YES];
    
    //filling paypments methods
    BTRPaymentTypesHandler *sharedPaymentTypes = [BTRPaymentTypesHandler sharedPaymentTypes];
    self.paymentTypesArray = [sharedPaymentTypes creditCardDisplayNameArray];
    
    // MasterPass first checkout
    if (self.masterCallBackInfo) {
        [self masterPassInfoDidReceived:self.masterCallBackInfo];
        return;
    }
    
    // paypal first checkout
    if (self.paypalCallBackInfo) {
        [self payPalInfoDidReceived:self.paypalCallBackInfo];
        return;
    }
    
    // setting default value
    [self setChosenShippingCountryString:@"Canada"];
    [self setChosenBillingCountryString:@"Canada"];
    [self setCurrentPaymentType:creditCard];
    [self.paymentMethodTF setText:@"Visa Credit"];
    [self.changePaymentMethodCheckbox setChecked:NO];
    [self.changePaymentMethodView setHidden:YES];
    [self setIsVisible:NO];
    [self loadOrderData];
    [self setComeFromMasterPass:NO];
    [self fillPaymentInfoWithCurrentData];
    
    [_expandHaveCode setOptions:@{ kFRDLivelyButtonLineWidth: @(1.5f),
                                   kFRDLivelyButtonHighlightedColor: [UIColor whiteColor],
                                   kFRDLivelyButtonColor: [BTRViewUtility BTRBlack]
                                   }];
    [_expandHaveCode setStyle:kFRDLivelyButtonStyleClose animated:YES];
    
    if (![BTRViewUtility isIPAD]) {
        self.paymentPicker = [[DownPicker alloc] initWithTextField:self.paymentMethodTF withData:[self paymentTypesArray] pickType:@"Payment"];
        self.expiryMonthPicker = [[DownPicker alloc] initWithTextField:self.expiryMonthPaymentTF withData:[self expiryMonthsArray] pickType:@"expMonth"];
        self.expiryYearPicker = [[DownPicker alloc] initWithTextField:self.expiryYearPaymentTF withData:[self expiryYearsArray] pickType:@"expYear"];
        self.shippingCountryPicker = [[DownPicker alloc] initWithTextField:self.countryShippingTF withData:[self countryNameArray] pickType:@"shiCountry"];
        self.billingCountryPicker = [[DownPicker alloc] initWithTextField:self.countryBillingTF withData:[self countryNameArray] pickType:@"bilCountry"];
        
        [self.paymentPicker showArrowImage:NO];
        [self.expiryYearPicker showArrowImage:NO];
        [self.expiryMonthPicker showArrowImage:NO];
        [self.shippingCountryPicker showArrowImage:NO];
        [self.billingCountryPicker showArrowImage:NO];
        
        self.paymentPicker.delegate = self;
        self.expiryYearPicker.delegate = self;
        self.expiryMonthPicker.delegate = self;
        self.shippingCountryPicker.delegate = self;
        self.billingCountryPicker.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setIsVisible:YES];
    [self addSampleGifts];
    [self setupApplePayButton];
}

- (void)resetData {
    self.arrayOfGiftCards = [[NSMutableArray alloc]init];
    self.arrayOfVanityCodes = [[NSMutableArray alloc]init];
    self.totalSave = 0;
}

- (void)loadOrderData {
    self.isLoading = YES;

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
    
    [self.bagTotalDollarLabel setText:[NSString stringWithFormat:@"$%.2f",[self.order bagTotalPrice].floatValue]];
    [self.subtotalDollarLabel setText:[NSString stringWithFormat:@"$%.2f",[self.order subTotalPrice].floatValue]];
    [self.shippingDollarLabel setText:[NSString stringWithFormat:@"$%.2f",[self.order shippingPrice].floatValue]];

    // calculating taxes
    
    [self.gstTaxLebl setHidden:YES];
    [self.gstTaxDollarLabel setHidden:YES];
    [self.qstTaxLabel setHidden:YES];
    [self.qstTaxDollarLabel setHidden:YES];
    
    if ([self.order.taxes count] > 0) {
        NSDictionary *firstTax = [self.order.taxes objectAtIndex:0];
        [self.gstTaxLebl setText:[[firstTax valueForKey:@"label"]uppercaseString]];
        [self.gstTaxDollarLabel setText:[NSString stringWithFormat:@"$%.2f",[[firstTax valueForKey:@"amount"]floatValue]]];
        [self.gstTaxLebl setHidden:NO];
        [self.gstTaxDollarLabel setHidden:NO];
    }
    if ([self.order.taxes count] > 1) {
        NSDictionary *secondTax = [self.order.taxes objectAtIndex:1];
        [self.qstTaxLabel setText:[[secondTax valueForKey:@"label"]uppercaseString]];
        [self.qstTaxDollarLabel setText:[NSString stringWithFormat:@"$%.2f",[[secondTax valueForKey:@"amount"]floatValue]]];
        [self.qstTaxLabel setHidden:NO];
        [self.qstTaxDollarLabel setHidden:NO];
    }
    
    [self.orderTotalDollarLabel setText:[NSString stringWithFormat:@"$%.2f",[self.order.orderTotalPrice floatValue]]];
    [self.youSaveDollarLabel setText:[NSString stringWithFormat:@"$%.2f",[self.order.saving floatValue]]];
    [self.totalDueLabel setText:[NSString stringWithFormat:@"TOTAL DUE (%@)",self.order.currency.uppercaseString]];
    [self.totalDueDollarLabel setText:self.orderTotalDollarLabel.text];
    
    if ([self.order.vanityCodes count] > 0) {
        // adding text for gift
        [self.giftDollarLabel setHidden:NO];
        [self.giftLabel setHidden:NO];
        NSString *currentVanity = [[self.order.vanityCodes allKeys]firstObject];
        [self.giftLabel setText:[NSString stringWithFormat:@"DISCOUNT (%@)",currentVanity]];
        [self.giftDollarLabel setText:[NSString stringWithFormat:@"$%@",[[self.order.vanityCodes valueForKey:currentVanity]valueForKey:@"discount"]]];
    }
    
    // VIP
    if ([[self.order vipPickupEligible] boolValue]) {
        self.pleaseFillOutTheShippingFormView.hidden = YES;
        self.fillFormLabelViewHeight.constant = 0;
        self.giftCardViewHeight.constant = 0;
        self.haveGiftCardView.hidden = YES;
        self.vipOptionView.hidden = NO;
    } else if (![[self.order vipPickupEligible] boolValue]) {
        self.pleaseFillOutTheShippingFormView.hidden = NO;
        self.fillFormLabelViewHeight.constant = FILL_SHIPPING_HEIGHT;
        [self.vipOptionViewHeight setConstant:0];
        if (_giftCardViewHeight.constant == 40 && shouldCallOnceInLaunch) {// This should call once in launch
            _haveAgiftInnerView.hidden = NO;
            shouldCallOnceInLaunch = NO;
            _giftCardViewHeight.constant += 125;
            self.haveAGiftViewHeight.constant += 125; // for iPad
        }
    }
    
    // Pick UP
    if ([[self.order eligiblePickup] boolValue]) {
        [_freeMontrealView setHidden:NO];
        [self.freeMontrealViewHeightConstraint setConstant:50];
        [self resetSize];
    } else {
        [_freeMontrealView setHidden:YES];
        [self.freeMontrealViewHeightConstraint setConstant:0];
        [self resetSize];
    }
    
    // Free ShipAddress
    BOOL shouldCallValidate = NO;
    if ([[self.order isFreeshipAddress]boolValue] && ![[self.order vipPickupEligible]boolValue]) {
        if (!self.freeshipOptionCheckbox.checked) {
            [self fillShippingAddressByAddress:self.order.promoShippingAddress];
            [self disableShippingAddress];
            [self.FreeshipingPromoView setHidden:NO];
            [self.pleaseFillOutTheShippingFormView setHidden:YES];
            [self.fillFormLabelViewHeight setConstant:0];
            [self.freeShippingPromoHeight setConstant:CHECKBOXES_HEIGHT];
            shouldCallValidate = YES;
        } else {
            [self enableShippingAddress];
            [self fillShippingAddressByAddress:self.order.shippingAddress];
        }
    } else {
        [self enableShippingAddress];
        [self fillShippingAddressByAddress:self.order.shippingAddress];
        [self.FreeshipingPromoView setHidden:YES];
        [self.freeShippingPromoHeight setConstant:0];
    }
    
    [self fillBillingAddressByAddress:self.order.billingAddress];
    // If Shipping Country is US we are displaying no shipping Label else we hide it
    
    if ([_countryShippingTF.text isEqualToString:@"Canada"]) {
        [_noShippingLabel setHidden:YES];
    } else {
        [_noShippingLabel setHidden:NO];
    }
    
    if (_noShippingLabel.hidden && _noShippingLabelHeight.constant != 0) {
        [_noShippingLabelHeight setConstant:0];
        [_noShippingLabelTopMargin setConstant:0];
        _shippingViewHeight.constant -= 47+8;
    } else if (!_noShippingLabel.hidden && _noShippingLabelHeight.constant == 0) {
        [_noShippingLabelHeight setConstant:47];
        [_noShippingLabelTopMargin setConstant:8];
        _shippingViewHeight.constant += 47+8;
    }
    
    if ([self.order.vipPickup boolValue]) {
        [self vipOptionChecked];
        [self disableShippingAddress];
    }
    
    if (self.isVisible)
        [self addSampleGifts];
    
    self.isLoading = NO;
    
    if (!self.isVisible && shouldCallValidate)
        [self validateAddressViaAPIAndInCompletion:nil];
}

- (void)addSampleGifts {
    if  (!self.selectedGift)
        self.selectedGift = [[NSMutableArray alloc]init];
    
    for (UIView *subView in [self.sampleGiftView subviews])
        [subView removeFromSuperview];
    
    CGFloat height = 0;
    height = [self.order.promoItems count] * SAMPLE_GIFT_HEIGHT;
    self.sampleGiftViewHeight.constant = height;
    
    int i = 0;
    
    CGFloat heightSize = 0;
    CGFloat widthSize = 0;
    if ([BTRViewUtility isIPAD]) {
        self.haveAGiftViewHeight.constant = self.haveAGiftViewHeight.constant + self.sampleGiftViewHeight.constant;
        self.payListWithSampleOut.constant += SAMPLE_GIFT_HEIGHT * [self.order.promoItems count];
        widthSize = self.view.frame.size.width/2 - 50;
    } else {
        widthSize = self.view.frame.size.width;
    }
    
    [self.selectedGift removeAllObjects];
    for (PromoItem* item in self.order.promoItems) {
            UIView *itemView = [[[NSBundle mainBundle]loadNibNamed:@"BTRSampleGiftView" owner:self options:nil]firstObject];
            itemView.frame = CGRectMake(0, heightSize, widthSize, SAMPLE_GIFT_HEIGHT);
            
            UIImageView *imageView = (UIImageView *)[itemView viewWithTag:100];
            CTCheckbox* checkbox = (CTCheckbox *)[itemView viewWithTag:200];
            UILabel * label = (UILabel *)[itemView viewWithTag:300];
            
            HTMLAttributedString *string  = [[HTMLAttributedString alloc] initWithHtml:item.text andBodyFont:[UIFont systemFontOfSize:12.0]];
            [label setAttributedText:string.attributedString];
            
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",item.image]] placeholderImage:nil];
            [checkbox addTarget:self action:@selector(sampleGiftSelected:) forControlEvents:UIControlEventValueChanged];
            [checkbox setTag:i];
            if ([item.selectedByDefault boolValue] && ![self.deSelectedGift containsObject:item.promoItemID])
                [checkbox setChecked:YES];
            [self.sampleGiftView addSubview:itemView];
            itemView.backgroundColor = [UIColor clearColor];
            heightSize += SAMPLE_GIFT_HEIGHT;
            i++;
    }
    [self resetSize];
}

- (void)setCheckboxesTargets {
    [self.vipOptionCheckbox addTarget:self action:@selector(checkboxVipOptionDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.sameAddressCheckbox addTarget:self action:@selector(checkboxSameAddressDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.pickupOptionCheckbox addTarget:self action:@selector(checkboxPickupOptionDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.changePaymentMethodCheckbox addTarget:self action:@selector(checkboxChangePaymentMethodDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.orderIsGiftCheckbox addTarget:self action:@selector(checkboxIsGiftChange:) forControlEvents:UIControlEventValueChanged];
    [self.freeshipOptionCheckbox addTarget:self action:@selector(checkboxFreeshipAddressChanged:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)shippingFieldChanged:(id)sender {
    if (self.sameAddressCheckbox.checked)
        [self copyShipingAddressToBillingAddress];
}

- (void)checkboxFreeshipAddressChanged:(CTCheckbox *)checkbox {
    if (checkbox.checked) {
        [self clearShippingAddressAndkeepPhoneAndName:NO];
        [self enableShippingAddress];
        [self.freeshipMessageLabelHeight setConstant:75];
    } else {
        [self.freeshipMessageLabelHeight setConstant:0];
        [self loadOrderData];
    }
    if (!self.comeFromMasterPass)
        [self validateAddressViaAPIAndInCompletion:nil];
    [self resetSize];
}

-(void)checkboxChangePaymentMethodDidChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    if (checkbox.checked) {
        UIAlertView * alert2 = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"By changing payment method, your payment information will be cleared from the system" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes, Continue",@"No, Cancel", nil];
        alert2.tag = 504;
        [alert2 show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 504) {
        if (buttonIndex == 0) {
            NSString *deleteTokenURL = [NSString stringWithFormat:@"%@",[BTRUserFetcher URLforDeleteCCToken]];
            [BTRConnectionHelper getDataFromURL:deleteTokenURL withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
                    if ([[response valueForKey:@"success"]boolValue]) {
                        [self.order setLockCCFields:@"0"];
                        [self enablePaymentInfo];
                        [self clearPaymentInfo];
                        [self setCurrentPaymentType:creditCard];
                        [self changeDetailPaymentFor:creditCard];
                        [self.paymentMethodTF setText:@"Visa Credit"];
                    } else {
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Something wrong, your credit card's information did not clean" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
                    }
                } faild:^(NSError *error) {
                
            }];
        } else if (buttonIndex == 1) {
            [self setIsLoading:YES];
            [_changePaymentMethodCheckbox setChecked:NO];
            [self setIsLoading:NO];
        }
    }
}
- (void)checkboxVipOptionDidChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    
    if ([checkbox checked]) {
        [self vipOptionChecked];
    } else if (![checkbox checked]) {
        [self clearShippingAddressAndkeepPhoneAndName:YES];
        [self enableShippingAddress];
    }
    [self validateAddressViaAPIAndInCompletion:nil];
}

-(void)vipOptionChecked {
    [self.addressLine1ShippingTF setText:self.order.pickupAddress.addressLine1];
    [self.addressLine2ShippingTF setText:self.order.pickupAddress.addressLine2];
    [self.countryShippingTF setText:[BTRViewUtility countryNameforCode:self.order.pickupAddress.country]];
    [self.zipCodeShippingTF setText:self.order.pickupAddress.postalCode];
    [self.provinceShippingTF setText:[BTRViewUtility provinceNameforCode:self.order.pickupAddress.province]];
    [self.cityShippingTF setText:self.order.pickupAddress.city];
    NSString * vipTitle = [NSString stringWithFormat:@"VIP Option: Pick up from %@ (no shipping fees)",self.order.pickupTitle];
    [self.vipTitleText setText:vipTitle];
    [self disableShippingAddress];
}

- (void)checkboxPickupOptionDidChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    
    if ([checkbox checked]) {
        [self saveCurrentShippingAddress];
        [self.addressLine1ShippingTF setText:self.order.pickupAddress.addressLine1];
        [self.addressLine2ShippingTF setText:self.order.pickupAddress.addressLine2];
        [self.countryShippingTF setText:[BTRViewUtility countryNameforCode:self.order.pickupAddress.country]];
        [self.zipCodeShippingTF setText:self.order.pickupAddress.postalCode];
        [self.provinceShippingTF setText:[BTRViewUtility provinceNameforCode:self.order.pickupAddress.province]];
        [self.cityShippingTF setText:self.order.pickupAddress.city];
        [self disableShippingAddress];

    } else if (![checkbox checked]) {
        [self.order setIsPickup:@"0"];
        if (self.savedShippingAddress)
            [self fillShippingAddressByAddress:self.savedShippingAddress];
        [self enableShippingAddress];
    }
    if (_sameAddressCheckbox.checked) {
        [self copyShipingAddressToBillingAddress];
    }
    [self validateAddressViaAPIAndInCompletion:nil];
}

-(void)sampleGiftSelected:(CTCheckbox *)checkbox {
    if (self.deSelectedGift == nil)
        self.deSelectedGift = [[NSMutableArray alloc]init];
    
    if  (checkbox.checked) {
        [self.selectedGift addObject:[[self.order.promoItems objectAtIndex:checkbox.tag]promoItemID]];
        [self.deSelectedGift removeObject:[(PromoItem *)[self.order.promoItems objectAtIndex:checkbox.tag]promoItemID]] ;
    }
    else {
        [self.selectedGift removeObject:[(PromoItem *)[self.order.promoItems objectAtIndex:checkbox.tag]promoItemID]];
        [self.deSelectedGift addObject:[(PromoItem *)[self.order.promoItems objectAtIndex:checkbox.tag]promoItemID]];
    }
}

- (void)disableShippingAddress {
    [self.sameAsShippingAddressView setHidden:TRUE];
    [self.sameAsShippingHeight setConstant:0];
    
    [self.shippingCountryButton setEnabled:FALSE];
    [self.shippingStateButton setEnabled:FALSE];
    
    [self.addressLine1ShippingTF setEnabled:FALSE];
    [self.addressLine2ShippingTF setEnabled:FALSE];
    [self.countryShippingTF setEnabled:FALSE];
    [self.zipCodeShippingTF setEnabled:FALSE];
    [self.provinceShippingTF setEnabled:FALSE];
    [self.cityShippingTF setEnabled:FALSE];
    
    [self.addressLine1ShippingTF setAlpha:0.6f];
    [self.addressLine2ShippingTF setAlpha:0.6f];
    [self.countryShippingTF setAlpha:0.6f];
    [self.zipCodeShippingTF setAlpha:0.6f];
    [self.provinceShippingTF setAlpha:0.6f];
    [self.cityShippingTF setAlpha:0.6f];
}

- (void)enableShippingAddress {
    [self.sameAsShippingAddressView setHidden:FALSE];
    [self.sameAsShippingHeight setConstant:CHECKBOXES_HEIGHT];

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
         
- (void)saveCurrentShippingAddress {
     if (!self.savedShippingAddress)
         self.savedShippingAddress = [[Address alloc]init];
    self.savedShippingAddress.addressLine1 = self.addressLine1ShippingTF.text;
    self.savedShippingAddress.addressLine2 = self.addressLine2ShippingTF.text;
    self.savedShippingAddress.country = [BTRViewUtility countryCodeforName:[[self countryShippingTF] text]];
    self.savedShippingAddress.province =  [BTRViewUtility provinceCodeforName:[[self provinceShippingTF] text]];
    self.savedShippingAddress.city = self.cityShippingTF.text;
    self.savedShippingAddress.postalCode = self.zipCodeShippingTF.text;
    self.savedShippingAddress.name = self.recipientNameShippingTF.text;
    self.savedShippingAddress.phoneNumber = self.phoneShippingTF.text;
}

- (void)checkboxIsGiftChange:(CTCheckbox *)checkbox {
    if (self.isLoading)
        return;
    if ([BTRViewUtility isIPAD]) {
        if (checkbox.checked) {
            self.giftViewHeight.constant = 250;
            self.giftCardInfoView.hidden = NO;
            self.viewHeight.constant = self.viewHeight.constant + 175;
        } else {
            self.giftViewHeight.constant = 75;
            self.giftCardInfoView.hidden = YES;
            self.viewHeight.constant = self.viewHeight.constant - 175;
        }
    } else {
        if (checkbox.checked) {
            self.giftViewHeight.constant = 250;
        }else {
            self.giftCardInfoView.hidden = YES;
            self.giftViewHeight.constant = 75;
        }
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if ([checkbox checked]) {
                                 self.giftCardInfoView.hidden = NO;
                             }
                             [self resetSize];
                         }];
    }
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
    [self.addressLine1BillingTF setEnabled:FALSE];
    [self.addressLine2BillingTF setEnabled:FALSE];
    [self.countryBillingTF setEnabled:FALSE];
    [self.postalCodeBillingTF setEnabled:FALSE];
    [self.provinceBillingTF setEnabled:FALSE];
    [self.cityBillingTF setEnabled:FALSE];
    [self.billingCountryButton setEnabled:FALSE];
    
    [self.addressLine1BillingTF setAlpha:0.6f];
    [self.addressLine2BillingTF setAlpha:0.6f];
    [self.countryBillingTF setAlpha:0.6f];
    [self.postalCodeBillingTF setAlpha:0.6f];
    [self.provinceBillingTF setAlpha:0.6f];
    [self.cityBillingTF setAlpha:0.6f];
}

- (void)enableBillingAddress {
    [self.addressLine1BillingTF setEnabled:TRUE];
    [self.addressLine2BillingTF setEnabled:TRUE];
    [self.countryBillingTF setEnabled:TRUE];
    [self.postalCodeBillingTF setEnabled:TRUE];
    [self.provinceBillingTF setEnabled:TRUE];
    [self.cityBillingTF setEnabled:TRUE];
    [self.billingCountryButton setEnabled:TRUE];
    
    [self.addressLine1BillingTF setAlpha:1.0f];
    [self.addressLine2BillingTF setAlpha:1.0f];
    [self.countryBillingTF setAlpha:1.0f];
    [self.postalCodeBillingTF setAlpha:1.0f];
    [self.provinceBillingTF setAlpha:1.0f];
    [self.cityBillingTF setAlpha:1.0f];
}

- (void)clearBillingAddress {
    [self.addressLine1BillingTF setText:@""];
    [self.addressLine2BillingTF setText:@""];
    [self.postalCodeBillingTF setText:@""];
    [self.provinceBillingTF setText:@""];
    [self.cityBillingTF setText:@""];
    [self.phoneBillingTF setText:@""];
}

- (void)clearShippingAddressAndkeepPhoneAndName:(BOOL)keepPhoneAndNum{
    [self.addressLine1ShippingTF setText:@""];
    [self.addressLine2ShippingTF setText:@""];
    [self.zipCodeShippingTF setText:@""];
    [self.provinceShippingTF setText:@""];
    [self.cityShippingTF setText:@""];
    if (!keepPhoneAndNum) {
        [self.phoneShippingTF setText:@""];
        [self.recipientNameShippingTF setText:@""];
    }
}

- (void)disablePaymentInfo {
    //Card
    [self.paymentMethodTF setEnabled:NO];
    [self.cardNumberPaymentTF setEnabled:NO];
    [self.cardVerificationPaymentTF setEnabled:NO];
    [self.nameOnCardPaymentTF setEnabled:NO];
    [self.expiryYearPaymentTF setEnabled:NO];
    [self.expiryMonthPaymentTF setEnabled:NO];
    //Paypal
    [self.paypalEmailTF setEnabled:NO];
    //iPad buttons
    [self.paymentMethodButton setEnabled:NO];
    [self.expMnthBtn setEnabled:NO];
    [self.expYearBtn setEnabled:NO];
//    [self.billingCountryButton setEnabled:NO];
//    [self.billingStateButton setEnabled:NO];
    
    [self.paymentMethodTF setAlpha:0.6f];
    [self.cardNumberPaymentTF setAlpha:0.6f];
    [self.cardVerificationPaymentTF setAlpha:0.6f];
    [self.nameOnCardPaymentTF setAlpha:0.6f];
    [self.expiryMonthPaymentTF setAlpha:0.6f];
    [self.expiryYearPaymentTF setAlpha:0.6f];
    [self.paypalEmailTF setAlpha:0.6f];
}

- (void)enablePaymentInfo {
    //Card
    [self.paymentMethodTF setEnabled:YES];
    [self.cardNumberPaymentTF setEnabled:YES];
    [self.cardVerificationPaymentTF setEnabled:YES];
    [self.nameOnCardPaymentTF setEnabled:YES];
    [self.expiryYearPaymentTF setEnabled:YES];
    [self.expiryMonthPaymentTF setEnabled:YES];
    //Paypal
    [self.paypalEmailTF setEnabled:YES];
    //iPad buttons
    [self.paymentMethodButton setEnabled:YES];
    [self.expMnthBtn setEnabled:YES];
    [self.expYearBtn setEnabled:YES];
//    [self.billingCountryButton setEnabled:YES];
//    [self.billingStateButton setEnabled:YES];
    
    [self.paymentMethodTF setAlpha:1.0f];
    [self.cardNumberPaymentTF setAlpha:1.0f];
    [self.cardVerificationPaymentTF setAlpha:1.0f];
    [self.nameOnCardPaymentTF setAlpha:1.0f];
    [self.expiryMonthPaymentTF setAlpha:1.0f];
    [self.expiryYearPaymentTF setAlpha:1.0f];
    [self.paypalEmailTF setAlpha:1.0f];
}

- (NSDictionary *)orderInfo {
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:[self shippingInfo] forKey:@"shipping"];
    [orderInfo setObject:[self billingInfo] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.sameAddressCheckbox checked]] forKey:@"billto_shipto"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.vipOptionCheckbox checked]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.orderIsGiftCheckbox checked]] forKey:@"is_gift"];
    [orderInfo setObject:[NSNumber numberWithBool:NO] forKey:@"check_booze"];
    [orderInfo setObject:[self.giftMessageTF text] forKey:@"recipient_message"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.pickupOptionCheckbox checked]] forKey:@"is_pickup"];
    
    return orderInfo;
}

- (void)fillShippingAddressByAddress:(Address *)address {
    [self.recipientNameShippingTF setText:address.name];
    [self.addressLine1ShippingTF setText:address.addressLine1];
    [self.addressLine2ShippingTF setText:address.addressLine2];
    [self.countryShippingTF setText:[BTRViewUtility countryNameforCode:address.country]];
    [self.zipCodeShippingTF setText:address.postalCode];
    [self.provinceShippingTF setText:[BTRViewUtility provinceNameforCode:address.province]];
    [self.cityShippingTF setText:address.city];
    [self.phoneShippingTF setText:address.phoneNumber];
    if ([[self.order.shippingAddress.country uppercaseString] isEqualToString:@"US"]) {
        self.shippingProvinceLB.text = @"STATE";
        self.shippingPostalCodeLB.text = @"ZIP CODE";
    } else {
        self.shippingProvinceLB.text = @"PROVINCE";
        self.shippingPostalCodeLB.text = @"POSTAL CODE";
    }
}

- (void)fillBillingAddressByAddress:(Address *)address {
    [self.addressLine1BillingTF setText:address.addressLine1];
    [self.addressLine2BillingTF setText:address.addressLine2];
    [self.countryBillingTF setText:[BTRViewUtility countryNameforCode:address.country]];
    [self.postalCodeBillingTF setText:address.postalCode];
    [self.provinceBillingTF setText:[BTRViewUtility provinceNameforCode:address.province]];
    [self.cityBillingTF setText:address.city];
    [self.phoneBillingTF setText:address.phoneNumber];
    if ([[self.order.billingAddress.country uppercaseString] isEqualToString:@"US"]) {
        self.billingProvinceLB.text = @"STATE";
        self.billingPostalCodeLB.text = @"ZIP CODE";
    } else {
        self.billingProvinceLB.text = @"PROVINCE";
        self.billingPostalCodeLB.text = @"POSTAL CODE";
    }
}

- (void)fillPaymentInfoWithCurrentData {
    if ([self.order.paymentType isEqualToString:@"paypal"]) {
        [self.paymentMethodTF setText:@"Paypal"];
        [self setCurrentPaymentType:paypal];
        if  (self.order.billingAddress.name.length > 0) {
            self.paypalEmailTF.text = self.order.billingAddress.name;
        }
    }
    else {
        if  (self.order.cardHolderName.length > 0)
            self.nameOnCardPaymentTF.text = self.order.cardHolderName;
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
        if ([self.order.billingAddress.country isEqualToString:@"US"])
            [self.paymentMethodImageView setImage:[UIImage imageNamed:@"cardImages_us"]];
        else
            [self.paymentMethodImageView setImage:[UIImage imageNamed:@"cardImages"]];
        [self showBillingAddress];
        [self showCardPaymentTip];
        if (![BTRViewUtility isIPAD]) {
            self.creditCardDetailHeight.constant = CARD_PAYMENT_HEIGHT;
            self.fastPaymentHeight.constant = FASTPAYMENT_HEIGHT;
        } else {
            self.billingAddressView.userInteractionEnabled = YES;
            self.billingAddressView.alpha = 1.0;
            self.fastPaymentHeight.constant = 56;
            self.creditCardDetailHeight.constant = CARD_PAYMENT_HEIGHT;
        }
        self.cameraButton.hidden = NO;
        self.paymentDetailsView.hidden = NO;
        self.paypalDetailsView.hidden = YES;
        self.fastPaymentView.hidden = NO;
        self.rememberCardInfoView.hidden = NO;
        if ([self.order.lockCCFields boolValue]) {
            self.cameraButton.hidden = YES;
            self.rememberCardInfoView.hidden = YES;
            self.changePaymentMethodView.hidden = NO;
            self.cardVerificationPaymentTF.text = @"xxx";
            [self disablePaymentInfo];
        } else {
            self.changePaymentMethodView.hidden = NO;
        }
        
    } else if (type == paypal) {
        [self.paymentMethodImageView setImage:[UIImage imageNamed:@"paypal_yellow"]];
        self.rememberCardInfoView.hidden = YES;
        self.fastPaymentHeight.constant = 0;
        self.fastPaymentView.hidden = YES;
        [self hideBillingAddress];
        [self hideCardPaymentTip];
        if ([BTRViewUtility isIPAD ]) {
             self.billingAddressView.userInteractionEnabled = NO;
            self.billingAddressView.alpha = 0.5;
        }
        if (self.paypalEmailTF.text.length > 0) {
            self.paypalEmailTF.hidden = NO;
            self.paypalDetailsView.hidden = NO;
            self.sendmeToPaypalCheckbox.hidden = NO;
            self.sendmeToPaypalLabel.hidden = NO;
            self.changePaymentMethodView.hidden = NO;
            if (![BTRViewUtility isIPAD]) {
                self.paymentDetailsView.hidden = YES;
                self.creditCardDetailHeight.constant = CARD_PAYMENT_HEIGHT - PAYPAL_PAYMENT_HEIGHT;
                self.paypalDetailHeight.constant = CARD_PAYMENT_HEIGHT;
            } else {
                self.creditCardDetailHeight.constant = CARD_PAYMENT_HEIGHT - PAYPAL_PAYMENT_HEIGHT_IPAD;
                self.paypalDetailHeight.constant = PAYPAL_PAYMENT_HEIGHT_IPAD;
            }
            [self disablePaymentInfo];
        }
        else {
            self.paypalDetailHeight.constant = 0;
            self.creditCardDetailHeight.constant = 0;
            self.changePaymentMethodView.hidden = YES;
            self.paymentDetailsView.hidden = YES;
            self.paypalDetailsView.hidden = YES;
        }
    }

    if (self.rememberCardInfoView.hidden && self.changePaymentMethodView.hidden)
        self.rememberCardInfoHeight.constant = 0;
    else
        self.rememberCardInfoHeight.constant = REMEBER_CARD_INFO_HEIGHT;
    
    [self resetSize];
}

- (void)hideCardPaymentTip {
    [self.cardPaymentTipHeight setConstant:0];
    [self.cardPaymentTipLabel setHidden:YES];
}

- (void)showCardPaymentTip {
    [self.cardPaymentTipHeight setConstant:CARD_PAYMENT_TIP_HEIGHT];
    [self.cardPaymentTipLabel setHidden:NO];
}

- (void)hideBillingAddress {
    if (self.billingAddressHeight.constant == BILLING_ADDRESS_HEIGHT) {
        self.billingAddressView.hidden = YES;
        self.billingAddressHeight.constant  =  0;
        [self.view layoutIfNeeded];
    } else if (self.billingAddressHeight.constant == BILLING_ADDRESS_HEIGHT_IPAD) {
        self.billingAddressView.alpha = 0.5;
    }
}

- (void)showBillingAddress {
    if (self.billingAddressHeight.constant == 0) {
        self.billingAddressView.hidden = NO;
        if ([BTRViewUtility isIPAD]) {
            self.billingAddressHeight.constant  =  BILLING_ADDRESS_HEIGHT_IPAD;
        } else {
            self.billingAddressHeight.constant  =  BILLING_ADDRESS_HEIGHT;
        }
        [self.view layoutIfNeeded];
    } else if (_billingAddressView.alpha == 0.5) {
        _billingAddressView.alpha = 1;
    }
}

#pragma mark - Dissmiss Keyboard

/**
 
 Tap Recognizer conflicts with checkbox inside scrollView
 
 */

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)dismissKeyboard {
    if (![BTRViewUtility isIPAD] && (self.paymentMethodTF.isEditing || self.countryShippingTF.isEditing || self.countryBillingTF.isEditing || self.expiryMonthPaymentTF.isEditing || self.expiryYearPaymentTF.isEditing)) {
        return;
    }
    [self.view endEditing:YES];
}

- (IBAction)viewTapped:(UIControl *)sender {
    [self dismissKeyboard];
}

- (IBAction)shippingDetailsViewTapped:(UIControl *)sender {
    if (_sameAddressCheckbox.checked) {
        [self copyShipingAddressToBillingAddress];
    }
    [self dismissKeyboard];
}

- (IBAction)billingAddressViewTapped:(UIControl *)sender {
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


- (IBAction)haveGiftCardHeight:(id)sender {
    if (_giftCardViewHeight.constant == 40) {
        if ([BTRViewUtility isIPAD]) {
            _giftCardViewHeight.constant += 125;
            self.haveAGiftViewHeight.constant += 125;
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                _giftCardViewHeight.constant += 125;
                [self.view layoutIfNeeded];
            }];
        }
        _haveAgiftInnerView.hidden = NO;
        [_expandHaveCode setStyle:kFRDLivelyButtonStyleClose animated:YES];
    } else {
        if ([BTRViewUtility isIPAD]) {
            _giftCardViewHeight.constant -= 125;
            self.haveAGiftViewHeight.constant -= 125;
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                _giftCardViewHeight.constant -= 125;
                [self.view layoutIfNeeded];
            }];
        }
        _haveAgiftInnerView.hidden = YES;
        [_expandHaveCode setStyle:kFRDLivelyButtonStylePlus animated:YES];
    }
    [self resetSize];
}

- (IBAction)shippingCountryButtonTapped:(UIButton *)sender {
    if (_sameAddressCheckbox.checked) {
        [self copyShipingAddressToBillingAddress];
    }
    
    _popType = PopUPTypeShippingCountry;
    [self setBillingOrShipping:SHIPPING_ADDRESS];
    [self openPopView:sender Data:[NSMutableArray arrayWithArray:[self countryNameArray]] inView:_shippingDetailsView inFrameView:sender];
}

- (IBAction)shippingStateButtonTapped:(UIButton *)sender {
    if ([[[self countryShippingTF] text] isEqualToString:@"USA"]) {
        _popType = PopUPTypeState;
        [self setBillingOrShipping:SHIPPING_ADDRESS];
        [self openPopView:sender Data:[NSMutableArray arrayWithArray:[self statesArray]] inView:_shippingDetailsView inFrameView:sender];
    }
    else {
        _popType = PopUPTypeProvince;
        [self setBillingOrShipping:SHIPPING_ADDRESS];
        [self openPopView:sender Data:[NSMutableArray arrayWithArray:[self provincesArray]] inView:_shippingDetailsView inFrameView:sender];
    }
}

- (IBAction)billingCountryButtonTapped:(UIButton *)sender {
    _popType = PopUPTypeBillingCountry;
    [self setBillingOrShipping:BILLING_ADDRESS];
    [self openPopView:sender Data:[NSMutableArray arrayWithArray:[self countryNameArray]] inView:_billingAddressView inFrameView:sender];
}

- (IBAction)billingStateButtonTapped:(UIButton *)sender {
    if ([[[self countryBillingTF] text] isEqualToString:@"USA"]) {
        _popType = PopUPTypeState;
        [self setBillingOrShipping:BILLING_ADDRESS];
        [self openPopView:sender Data:[NSMutableArray arrayWithArray:[self statesArray]] inView:_billingAddressView inFrameView:sender];
    }
    else {
        _popType = PopUPTypeProvince;
        [self setBillingOrShipping:BILLING_ADDRESS];
        [self openPopView:sender Data:[NSMutableArray arrayWithArray:[self provincesArray]] inView:_billingAddressView inFrameView:sender];
    }
}

- (IBAction)expiryYearButtonTapped:(UIButton *)sender {
    _popType = PopUPTypeExpiryYear;
    [self openPopView:sender Data:[self expiryYearsArray] inView:_paymentCreditView inFrameView:sender];
}

- (IBAction)expiryMonthButtonTapped:(UIButton *)sender {
    _popType = PopUPTypeExpiryMonth;
    [self openPopView:sender Data:[NSMutableArray arrayWithArray:[self expiryMonthsArray]] inView:_paymentCreditView inFrameView:sender];
}

- (IBAction)paymentMethodButtonTapped:(UIButton *)sender {
    _popType = PopUPTypePayment;
    [self openPopView:sender Data:[self paymentTypesArray] inView:_paymentTypeView inFrameView:_paymentMethodButton];
}

#pragma mark Actions

- (IBAction)processOrderTpped:(BTRLoadingButton *)sender {
    if (![self isShippingAddressCompeleted] && self.currentPaymentType != paypal)
        return;
    
    if (self.currentPaymentType == creditCard && [self isBillingAddressCompeleted] && [self isCardInfoCompeleted]) {
        [sender showLoading];
        [self validateAddressViaAPIAndInCompletion:^() {
            [self makePaymentWithSuccess:^(id responseObject) {
                [self orderConfirmationWithReceipt:responseObject];
                [sender hideLoading];
            } failure:^(NSError *error) {
                [sender hideLoading];
                NSLog(@"%@",error);
            }];
        }];
    } else if (self.currentPaymentType == paypal) {
        [self validateAddressViaAPIAndInCompletion:^() {
            [self sendPayPalInfo];
        }];
    } else if (self.currentPaymentType == masterPass){
        [self sendMasterPassInfo];
    }
}

#pragma mark ApplePay

- (void)setupApplePayButton {
    if (self.applePayManager == nil)
        self.applePayManager = [[ApplePayManager alloc]init];
    if ([self.applePayManager isApplePayAvailable]) {
        if ([self.applePayManager isApplePaySetup]) {
            self.applePayButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
            [self.applePayButton addTarget:self action:@selector(buyWithApplePay:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            self.applePayButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleBlack];
            [self.applePayButton addTarget:self action:@selector(setupApplePay:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.applePayButton.frame = self.applePayButtonView.bounds;
        [self.applePayButtonView addSubview:self.applePayButton];
    }
}

- (IBAction)buyWithApplePay:(UIButton *)sender {
    self.order.shippingAddress.phoneNumber = self.phoneShippingTF.text;
    self.applePayManager = [[ApplePayManager alloc]init];
    self.applePayManager.delegate = self;
    [self.applePayManager requestForTokenWithSuccess:^(id responseObject) {
        [self.applePayManager initWithClientWithToken:[responseObject valueForKey:@"token"] andOrderInfromation:self.order checkoutMode:checkoutTwo];
        [self.applePayManager setSelectedPromoGifts:self.selectedGift];
        [self.applePayManager setRecipientMessage:self.giftMessageTF.text];
        [self.applePayManager showPaymentViewFromViewController:self];
    } failure:^(NSError *error) {
    }];
}

- (IBAction)setupApplePay:(UIButton *)sender {
    [self.applePayManager setupApplePay];
}

#pragma mark - Credit Card RESTful Payment

- (void)makePaymentWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforCheckoutProcess]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self orderInfo] forKey:@"orderInfo"];
    [params setObject:[self cardInfo] forKey:@"cardInfo"];
    [params setObject:[self selectedGift] forKey:@"promotions_opted_in"];
    [params setObject:self.arrayOfVanityCodes forKey:@"vanity_codes"];
    [params setObject:@"creditcard" forKey:@"paymentMethod"];
    [params setObject:[NSDictionary dictionary] forKey:@"masterPassInfo"];
    [params setObject:[NSDictionary dictionary] forKey:@"visaMeInfo"];
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(response);
    } faild:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark Paypal RESTful Payment

- (void)sendPayPalInfo {
    NSMutableDictionary *params;
    if (self.paypalCallBackInfo) {
        params = [[NSMutableDictionary alloc]initWithDictionary:self.paypalCallBackInfo copyItems:YES];
        [params setObject:[self orderInfo] forKey:@"orderInfo"];
        [params setObject:[self selectedGift] forKey:@"promotions_opted_in"];
        [params setObject:self.arrayOfVanityCodes forKey:@"vanity_codes"];
    }
    else {
        params = [[NSMutableDictionary alloc]init];
        [params setObject:[self orderInfo] forKey:@"orderInfo"];
        [params setObject:[self cardInfo] forKey:@"cardInfo"];
        [params setObject:[self selectedGift] forKey:@"promotions_opted_in"];
        [params setObject:self.arrayOfVanityCodes forKey:@"vanity_codes"];
        NSDictionary* paypalMode;
        
        if (self.paypalEmailTF.text.length == 0 || self.sendmeToPaypalCheckbox.checked)
            paypalMode = [NSDictionary dictionaryWithObject:@"paypalLogin" forKey:@"mode"];
        else
            paypalMode = [NSDictionary dictionaryWithObject:@"billingAgreement" forKey:@"mode"];
        
        [params setObject:paypalMode forKey:@"paypalInfo"];
    }
    [self setPaypalCallBackInfo:params];
    NSString * identifierSB;
    if ([BTRViewUtility isIPAD]) {
        identifierSB  = @"BTRPaypalCheckoutSegueiPadIdentifier";
    } else {
        identifierSB = @"BTRPaypalCheckoutSegueIdentifier";
    }
    [self performSegueWithIdentifier:identifierSB sender:self];
}

#pragma mark MasterPass RESTful Payment

- (void)sendMasterPassInfo {
    if (self.masterCallBackInfo) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:self.masterCallBackInfo copyItems:YES];
        [params setObject:[self orderInfo] forKey:@"orderInfo"];
        [params setObject:[self selectedGift] forKey:@"promotions_opted_in"];
        [params setObject:self.arrayOfVanityCodes forKey:@"vanity_codes"];
        [self setMasterCallBackInfo:params];
        
        NSString * identifierSB;
        if ([BTRViewUtility isIPAD]) {
            identifierSB = @"BTRMasterPassCheckoutSegueiPadIdentifier";
        } else {
            identifierSB = @"BTRMasterPassCheckoutSegueIdentifier";
        }
        [self performSegueWithIdentifier:identifierSB sender:self];
    }
}

- (void)getMasterPassInfo {
    self.masterCallBackInfo = nil;
    NSString* url = [NSString stringWithFormat:@"%@", [BTRMasterPassFetcher URLforStartMasterPass]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            MasterPassInfo* master = [MasterPassInfo masterPassInfoWithAppServerInfo:response];
            self.masterpass= master;
            NSString * identifierSB;
            if ([BTRViewUtility isIPAD]) {
                identifierSB = @"BTRMasterPassCheckoutSegueiPadIdentifier";
            } else {
                identifierSB = @"BTRMasterPassCheckoutSegueIdentifier";
            }
            [self performSegueWithIdentifier:identifierSB sender:self];
        }
    } faild:^(NSError *error) {
        
    }];
}

#pragma mark - ApplePay Delegate

- (void)applePayReceiptInfoDidReceivedSuccessful:(NSDictionary *)receiptInfo {
    self.confirmationInfo = [[ConfirmationInfo alloc]init];
    self.confirmationInfo = [ConfirmationInfo extractConfirmationInfoFromConfirmationInfo:receiptInfo forConformationInfo:self.confirmationInfo];
    NSString * identifierSB;
    if ([BTRViewUtility isIPAD]) {
        identifierSB = @"BTRConfirmationSegueiPadIdentifier";
    } else {
        identifierSB = @"BTRConfirmationSegueIdentifier";
    }
    [self performSegueWithIdentifier:identifierSB sender:self];
}

- (void)applePayInfoFailedWithError:(NSError *)error {
    [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Apple pay process does not work" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    [BTRLoader hideLoaderFromView:self.view];
}

- (void)applePayProcessDidStart {
    [BTRLoader showLoaderInView:self.view];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BTRConfirmationSegueIdentifier"] || [segue.identifier isEqualToString:@"BTRConfirmationSegueiPadIdentifier"]) {
        BTRConfirmationViewController* confirm = [segue destinationViewController];
        confirm.info = self.confirmationInfo;
    } else if ([[segue identifier]isEqualToString:@"BTRPaypalCheckoutSegueIdentifier"] || [[segue identifier]isEqualToString:@"BTRPaypalCheckoutSegueiPadIdentifier"]) {
        BTRPaypalCheckoutViewController* paypalVC = [segue destinationViewController];
        paypalVC.paypalInfo = self.paypalCallBackInfo;
    } else if ([[segue identifier]isEqualToString:@"BTRMasterPassCheckoutSegueIdentifier"] || [[segue identifier]isEqualToString:@"BTRMasterPassCheckoutSegueiPadIdentifier"]) {
        BTRMasterPassViewController* mpVC = [segue destinationViewController];
        mpVC.info = self.masterpass;
        mpVC.processInfo = self.masterCallBackInfo;
        mpVC.delegate = self;
    }
}

#pragma mark Validation

- (void)validateAddressViaAPIAndInCompletion:(void(^)())completionBlock; {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:[self shippingInfo] forKey:@"shipping"];
    [orderInfo setObject:[self billingInfo] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.sameAddressCheckbox checked]] forKey:@"billto_shipto"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.orderIsGiftCheckbox checked]] forKey:@"is_gift"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.vipOptionCheckbox checked]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.pickupOptionCheckbox checked]] forKey:@"is_pickup"];
    [params setObject:orderInfo forKey:@"orderInfo"];
    [params setObject:self.arrayOfVanityCodes forKey:@"vanity_codes"];

    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforAddressValidation]];
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        self.order = [Order extractOrderfromJSONDictionary:response forOrder:self.order isValidating:YES];
        [self loadOrderData];
        if (completionBlock)
            completionBlock(nil);
    } faild:^(NSError *error) {
    }];
}

- (IBAction)billingAddressChangeds:(id)sender {
    if (self.currentPaymentType == masterPass) {
        [self setCurrentPaymentType:creditCard];
        [self.cardVerificationPaymentTF setHidden:NO];
        [self.cardVerificationPaymentLB setHidden:NO];
        [self changeDetailPaymentFor:creditCard];
    }
}

- (IBAction)zipCodeHasBeenEntererd:(UITextField *)sender {
    if (_sameAddressCheckbox.checked) {
        [self copyShipingAddressToBillingAddress];
    }
    [self validateAddressViaAPIAndInCompletion:nil];
}

- (IBAction)learnMoreAboutGifts:(UIButton *)sender {
    [self learnMoreAboutGift];
}

- (BOOL)isShippingAddressCompeleted {
    // checking address line
    
    if (self.recipientNameShippingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter recipient name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.recipientNameShippingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.recipientNameShippingTF.frame animated:YES];
        return NO;
    }
    
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
    
    if (self.cityShippingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter your shipping city" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.cityShippingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.cityShippingTF.frame animated:YES];
        return NO;
    }
    
    if (self.phoneShippingTF.text.length == 0) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter your phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
        [self.phoneShippingTF becomeFirstResponder];
        [self.scrollView scrollRectToVisible:self.phoneShippingTF.frame animated:YES];
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

- (void)orderConfirmationWithReceipt:(NSDictionary *)receipt {
    if ([[[receipt valueForKey:@"payment"]valueForKey:@"success"]boolValue]) {
        [self getConfirmationInfoWithOrderID:[[receipt valueForKey:@"order"]valueForKey:@"order_id"]];
    } else if ([[receipt valueForKey:@"orderInfo"]valueForKey:@"errors"])
        [[[UIAlertView alloc]initWithTitle:@"Error" message:[[receipt valueForKey:@"orderInfo"]valueForKey:@"errors"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
}

#pragma mark giftcard adding

- (IBAction)checkAndValidateGiftCard:(BTRLoadingButton *)sender {
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
    [sender showLoading];
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
            if ([[response valueForKey:@"success"]boolValue]) {
                if ([[response valueForKey:@"type"]isEqualToString:@"vanity"]) {
                    [self.arrayOfVanityCodes addObject:self.giftCardCodePaymentTF.text];
                    [[[UIAlertView alloc]initWithTitle:@"Promotional code applied" message:[response valueForKey:@"description"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                } else {
                    [[[UIAlertView alloc]initWithTitle:@"Gift" message:[NSString stringWithFormat:@"%@$ has been added sucessfully",[response valueForKey:@"amount"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                    [self.arrayOfGiftCards addObject:self.giftCardCodePaymentTF.text];
                }
                [self.giftCardCodePaymentTF resignFirstResponder];
                [self validateAddressViaAPIAndInCompletion:^{
                    [sender hideLoading];
                }];
            } else {
                [[[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"Not Vaild"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
                [sender hideLoading];
            }
        } faild:^(NSError *error) {
            [sender hideLoading];
            NSLog(@"%@",error);
        }
     ];
}

#pragma mark checkout image
- (void)getImage {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRFreeshipFetcher URLforFreeship]];
    self.freeshipInfo = [[Freeship alloc]init];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        self.freeshipInfo = [Freeship extractFreeshipInfofromJSONDictionary:response forFreeship:self.freeshipInfo];
        self.bannerImageView.hidden = NO;
        [self.bannerImageView setImageWithURL:[BTRFreeshipFetcher URLforImage:self.freeshipInfo.checkoutImage withBaseURL:self.freeshipInfo.imagesDomain] placeholderImage:nil];
    } faild:^(NSError *error) {
        
    }];
}

#pragma mark confirmation

- (void)getConfirmationInfoWithOrderID:(NSString *)orderID {
    NSString* url = [NSString stringWithFormat:@"%@",[BTROrderFetcher URLforOrderNumber:orderID]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        self.confirmationInfo = [[ConfirmationInfo alloc]init];
        self.confirmationInfo = [ConfirmationInfo extractConfirmationInfoFromConfirmationInfo:response forConformationInfo:self.confirmationInfo];
        NSString * identifierSB;
        if ([BTRViewUtility isIPAD]) {
            identifierSB = @"BTRConfirmationSegueiPadIdentifier";
        } else {
            identifierSB = @"BTRConfirmationSegueIdentifier";
        }
        [self performSegueWithIdentifier:identifierSB sender:self];
    } faild:^(NSError *error) {
        
    }];
}

#pragma masterpass delegate;

- (void)masterPassInfoDidReceived:(NSDictionary *)info {
    self.masterCallBackInfo = info;
    self.order = [Order extractOrderfromJSONDictionary:info forOrder:self.order isValidating:NO];
    [self fixViewForMasterPass];
}

- (void)fixViewForMasterPass {
    [self setComeFromMasterPass:YES];
    if ([self.order.isFreeshipAddress boolValue]){
        [self.FreeshipingPromoView setHidden:NO];
        [self.freeshipOptionCheckbox setChecked:YES];
    }
    [self loadOrderData];
    [self fillPaymentInfoWithCurrentData];
    [self changeDetailPaymentFor:creditCard];
    [self setCurrentPaymentType:masterPass];
    [self.cardVerificationPaymentTF setHidden:YES];
    [self.cardVerificationPaymentLB setHidden:YES];
    [self.creditCardDetailHeight setConstant:self.creditCardDetailHeight.constant - 60];
    [self resetSize];
    [self setComeFromMasterPass:NO];
}

- (void)payPalInfoDidReceived:(NSDictionary *)info {
    self.order = [Order extractOrderfromJSONDictionary:info forOrder:self.order isValidating:NO];
    [self fixViewForPaypal];
}

- (void)fixViewForPaypal {
    [self loadOrderData];
    [self fillPaymentInfoWithCurrentData];
    [self changeDetailPaymentFor:paypal];
    [self resetSize];
}

- (void)resetSize {
    CGFloat size;
    if ([BTRViewUtility isIPAD])
        size = DEFAULT_VIEW_HEIGHT_IPAD;
    else
        size = DEFAULT_VIEW_HEIGHT_IPHONE;
    
    if (self.currentPaymentType == paypal && self.paypalEmailTF.text.length > 0) {
        if(![BTRViewUtility isIPAD]) {
            size = size - (CARD_PAYMENT_HEIGHT - PAYPAL_PAYMENT_HEIGHT);
            size = size - BILLING_ADDRESS_HEIGHT;
            size = size - FASTPAYMENT_HEIGHT;
        } else {
            size -= 100;
        }
    }
    else if (self.currentPaymentType == paypal) {
        if(![BTRViewUtility isIPAD]) {
            size = size - (CARD_PAYMENT_HEIGHT) ;
            size = size - BILLING_ADDRESS_HEIGHT;
            size = size - FASTPAYMENT_HEIGHT;
        } else {
            size -= 100;
        }
    }
    else if (self.currentPaymentType == masterPass) {
        
    }
    
    if (self.freeShippingPromoHeight.constant == 0) {
        size = size - CHECKBOXES_HEIGHT;
    }
    if (self.freeshipMessageLabelHeight.constant > 0) {
        size = size + self.freeshipMessageLabelHeight.constant;
    }
    if ( _giftCardViewHeight.constant == 165) {
        size += 125;
    }
    if (self.orderIsGiftCheckbox.checked)
        size = size + GIFT_MAX_HEIGHT;
    
    if (_vipOptionViewHeight.constant == 0) {
        size = size - CHECKBOXES_HEIGHT;
    }
    if (_freeMontrealViewHeightConstraint.constant == 50) {
        size += 50;
    } else if (_freeMontrealViewHeightConstraint.constant == 0 && [BTRViewUtility isIPAD]) {
        size += 50;
    }
    if (self.pleaseFillOutTheShippingFormView.hidden)
        size = size - FILL_SHIPPING_HEIGHT;
    
    if (self.giftCardViewHeight.constant == 0)
        size = size - GIFT_CARD_HEIGHT;
    
    if (self.rememberCardInfoHeight.constant == 0)
        size = size - REMEBER_CARD_INFO_HEIGHT;
    
    if (_noShippingLabelHeight.constant == 0 && ![BTRViewUtility isIPAD]) {
        size -= 47;
    }
    size = size + self.sampleGiftViewHeight.constant;
    self.viewHeight.constant = size;
    [self.view layoutIfNeeded];
}

#pragma mark camera

- (IBAction)cameraButtonTapped:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.hideCardIOLogo = YES;
    scanViewController.disableManualEntryButtons = YES;
    scanViewController.collectCVV = YES;
    scanViewController.collectExpiry = YES;
    scanViewController.guideColor = [UIColor grayColor];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    self.expiryMonthPaymentTF.text = [self.expiryMonthsArray objectAtIndex:info.expiryMonth - 1];
    self.expiryYearPaymentTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)info.expiryYear];
    self.cardNumberPaymentTF.text = info.cardNumber;
    self.cardVerificationPaymentTF.text = info.cvv;
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)openPopView:(UIButton*)sender Data:(NSMutableArray*)getArr inView:(UIView*)view inFrameView:(UIView*)frameV {
    BTRPopUpVC *popView = [self.storyboard instantiateViewControllerWithIdentifier:@"popView"];
    popView.delegate = self;
    popView.getArray = [NSMutableArray arrayWithArray:getArr];
    self.userDataPopover = [[UIPopoverController alloc] initWithContentViewController:popView];
    CGFloat popHeight = getArr.count * 44;
    if (popHeight > 250) {
        popHeight = 284;
    }
    self.userDataPopover.popoverContentSize = CGSizeMake(200, popHeight);
    [self.userDataPopover presentPopoverFromRect:[frameV frame]
                                          inView:view
                        permittedArrowDirections:UIPopoverArrowDirectionDown && UIPopoverArrowDirectionUp
                                        animated:NO];
}

#pragma mark - BTRPopUPDelegate method implementation

-(void)userDataChangedWith:(NSIndexPath *)index{
    if (_popType == PopUPTypePayment) {
        [self.paymentMethodTF setText:[[self paymentTypesArray] objectAtIndex:index.row]];
        if ([self.paymentMethodTF.text isEqualToString:@"Paypal"])
            [self setCurrentPaymentType:paypal];
        else
            [self setCurrentPaymentType:creditCard];
        [self changeDetailPaymentFor:self.currentPaymentType];
    }
    else if (_popType == PopUPTypeExpiryMonth) {
        [self.expiryMonthPaymentTF setText:[[self expiryMonthsArray] objectAtIndex:index.row]];
    }
    else if (_popType == PopUPTypeExpiryYear) {
        [self.expiryYearPaymentTF setText:[[self expiryYearsArray] objectAtIndex:index.row]];
    }
    else if (_popType == PopUPTypeBillingCountry) {
        [self.countryBillingTF setText:[[self countryNameArray] objectAtIndex:index.row]];
        [self validateAddressViaAPIAndInCompletion:nil];
    }
    else if (_popType == PopUPTypeShippingCountry) {
        if (index.row == 1) {
            [_noShippingLabel setHidden:NO];
        } else {
            [_noShippingLabel setHidden:YES];
        }
        [self.countryShippingTF setText:[[self countryNameArray] objectAtIndex:index.row]];
        if (_sameAddressCheckbox.checked) {
            if (index.row == 0) {
                self.billingProvinceLB.text = @"PROVINCE";
                self.billingPostalCodeLB.text = @"POSTAL CODE";
                
            } else {
                self.billingProvinceLB.text = @"STATE";
                self.billingPostalCodeLB.text = @"ZIP CODE";
            }
            self.countryBillingTF.text = self.countryShippingTF.text;
        }
        [self validateAddressViaAPIAndInCompletion:nil];
    }
    [self.userDataPopover dismissPopoverAnimated:NO];
}


//// iPhone PickerView
#pragma mark DropPicker Delegate

-(void)pickerType:(NSString *)pickType selectedIndex:(NSInteger)row {
    [self showPickerWithType:pickType selectedIndex:row];
}

-(void)showPickerWithType:(NSString*)picType selectedIndex:(NSInteger)row {

    if ([picType isEqualToString:@"Payment"]) {
        if ([self.paymentMethodTF.text isEqualToString:@"Paypal"])
            [self setCurrentPaymentType:paypal];
        else
            [self setCurrentPaymentType:creditCard];
        
        [self.paymentMethodTF setText:[[self paymentTypesArray] objectAtIndex:row]];
        [self changeDetailPaymentFor:self.currentPaymentType];
    }
    else if ([picType isEqualToString:@"expMonth"]) {
        [self.expiryMonthPaymentTF setText:[[self expiryMonthsArray] objectAtIndex:row]];
    }
    else if ([picType isEqualToString:@"expYear"]) {
        [self.expiryYearPaymentTF setText:[[self expiryYearsArray] objectAtIndex:row]];
    }
    else if ([picType isEqualToString:@"shiCountry"]) {
        if (row == 1) {
            [_noShippingLabel setHidden:NO];
        } else {
            [_noShippingLabel setHidden:YES];
        }
        [self.countryShippingTF setText:[[self countryNameArray] objectAtIndex:row]];
        if (_sameAddressCheckbox.checked) {
            if (row == 0) {
                self.billingProvinceLB.text = @"PROVINCE";
                self.billingPostalCodeLB.text = @"POSTAL CODE";
            } else {
                self.billingProvinceLB.text = @"STATE";
                self.billingPostalCodeLB.text = @"ZIP CODE";
            }
            self.countryBillingTF.text = self.countryShippingTF.text;
        }
        [self validateAddressViaAPIAndInCompletion:nil];
    }
    else if ([picType isEqualToString:@"bilCountry"]) {
        [self.countryBillingTF setText:[[self countryNameArray] objectAtIndex:row]];
        [self validateAddressViaAPIAndInCompletion:nil];
    }
}


- (void)learnMoreAboutGift {
    if (self.faqArray == nil) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self fetchFAQWithSuccess:^(id responseObject) {
                BTRHelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRHelpViewController"];
                help.getOriginalVCString = FROM_CHECKOUT;
                [help setFaqArray:self.faqArray];
                [self presentViewController:help animated:YES completion:nil];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
        });
    }else {
        BTRHelpViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"BTRHelpViewController"];
        [help setFaqArray:self.faqArray];
        help.getOriginalVCString = FROM_CHECKOUT;
        [self presentViewController:help animated:YES completion:nil];
    }
}
// getting FAQ

- (void)fetchFAQWithSuccess:(void (^)(id  responseObject)) success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@", [BTRFAQFetcher URLforFAQ]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if (response) {
            self.faqArray = [FAQ arrayOfFAQWithAppServerInfo:response];
            success(self.faqArray);
        }
    } faild:^(NSError *error) {
        failure(nil, error);
    }];
}

@end
