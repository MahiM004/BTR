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

@property (strong, nonatomic) UIManagedDocument *beyondTheRackDocument;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (assign, nonatomic) BOOL checkboxVipOption;
@property (assign, nonatomic) BOOL checkboxSameAsShipping;
@property (assign, nonatomic) BOOL checkboxThisOrderIsGift;
@property (assign, nonatomic) BOOL checkboxRememberCardInfo;

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
    [[self paymentTypesArray] addObjectsFromArray:[sharedPaymentTypes creditCardDisplayNameArray]];
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
    
    int load_tax_and_dollars;
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

- (void)setupDocument
{
    if (!self.managedObjectContext) {
        self.beyondTheRackDocument = [[BTRDocumentHandler sharedDocumentHandler] document];
        self.managedObjectContext = [[self beyondTheRackDocument] managedObjectContext];
    }
    
    int pickUp_UI_for_normal_or_employee;
    int true_false_values;
}

- (void)makePaymentforSessionId:(NSString *)sessionId
                           success:(void (^)(id  responseObject)) success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    NSDictionary *shippingInfo = (@{@"name": [[self recipientNameShippingTF] text],
                                    @"address1": [[self addressLine1ShippingTF] text],
                                    @"address2": [[self addressLine2ShippingTF] text],
                                    @"country": [BTRViewUtility countryCodeforName:[[self countryShippingTF] text]],
                                    @"postal": [[self zipCodeShippingTF] text],
                                    @"state": [BTRViewUtility provinceCodeforName:[[self provinceShippingTF] text]],
                                    @"city": [[self cityShippingTF] text],
                                    @"phone": [[self phoneShippingTF] text] });
    
    NSDictionary *billingInfo = (@{ @"name": [[self nameOnCardPaymentTF] text],
                                    @"address1": [[self addressLine1BillingTF] text],
                                    @"address2": [[self addressLine2BillingTF] text],
                                    @"country": [BTRViewUtility countryCodeforName:[[self countryBillingTF] text]],
                                    @"postal": [[self postalCodeBillingTF] text],
                                    @"state": [BTRViewUtility provinceCodeforName:[[self provinceBillingTF] text]],
                                    @"city": [[self cityBillingTF] text],
                                    @"phone": [[self phoneBillingTF] text] });
    
    [orderInfo setObject:shippingInfo forKey:@"shipping"];
    [orderInfo setObject:billingInfo forKey:@"billing"];
    [orderInfo setObject:@false forKey:@"billto_shipto"];
    [orderInfo setObject:@true forKey:@"vip_pickup"];
    [orderInfo setObject:@false forKey:@"is_gift"];
    [orderInfo setObject:@"" forKey:@"recipient_message"];
    [orderInfo setObject:@true forKey:@"is_pickup"];
    
    NSInteger expMonthInt = [[[[self expiryMonthPaymentTF] text] componentsSeparatedByString:@" -"][0] integerValue];
    NSString *expMonth = [NSString stringWithFormat:@"%ld", (long)expMonthInt];
    
    NSDictionary *cardInfo = (@{@"type": [[self paymentMethodTF] text],
                                @"name": [[self nameOnCardPaymentTF] text],
                                @"number": [[self cardNumberPaymentTF] text],
                                @"year": [[self expiryYearPaymentTF] text],
                                @"month": expMonth,
                                @"cvv": [[self cardVerificationPaymentTF] text],
                                @"remember_card": @false });

    [params setObject:orderInfo forKey:@"orderInfo"];
    [params setObject:@"creditcard" forKey:@"paymentMethod"];
    [params setObject:cardInfo forKey:@"cardInfo"];
    
    [manager.requestSerializer setValue:sessionId forHTTPHeaderField:@"SESSION"];
    [manager POST:[NSString stringWithFormat:@"%@", [BTROrderFetcher URLforCheckoutProcess]]
       parameters:(NSDictionary *)params success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary *entitiesPropertyList = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
              [self setOrder:[Order orderWithAppServerInfo:entitiesPropertyList inManagedObjectContext:[self managedObjectContext]]];
              [self.beyondTheRackDocument saveToURL:self.beyondTheRackDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
              success(@"TRUE");
           
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation, error);
          }];
}




#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end



















