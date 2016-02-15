//
//  ApplePayManager.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-11-18.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

@import AddressBook;

#import "ApplePayManager.h"
#import "BTRApplePayFetcher.h"
#import "BTRConnectionHelper.h"
#import "BTROrderFetcher.h"
#import "BTRViewUtility.h"
#import "SDVersion.h"

@interface ApplePayManager()
@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) Order *info;
@property (nonatomic, strong) PKPayment *paymentInfo;
@property (nonatomic, strong) NSString *nonce;
@property (nonatomic, strong) PKPaymentAuthorizationViewController *vc;
@property (nonatomic) BOOL applePayIsLoaded;
@property (nonatomic) BOOL addressChanged;
@property (nonatomic) checkoutMode currentCheckOutMode;

@end

@implementation ApplePayManager

- (BOOL)isApplePayAvailable {
   if ([PKPaymentAuthorizationViewController canMakePayments])
       return YES;
    return NO;
}

- (BOOL)isApplePaySetup {
    NSArray *acceptedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex];
    BOOL canPay = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:acceptedNetworks];
    return canPay;
}

- (PKPaymentRequest *)paymentRequest {
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.merchantIdentifier = @"merchant.beyondtherack.com.prod";
    paymentRequest.requiredShippingAddressFields = (PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName);
    paymentRequest.requiredBillingAddressFields = (PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName);
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    if ([self.info.shippingAddress.postalCode length] > 0) {
        paymentRequest.shippingContact = [self contactForAddress:self.info.shippingAddress];
        paymentRequest.shippingAddress = [self recordFromAddress:self.info.shippingAddress withLabel:@"Shipping"];
    }
    paymentRequest.billingContact = [self contactForAddress:self.info.billingAddress];
    paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    paymentRequest.countryCode = [self.info.country uppercaseString];
    paymentRequest.currencyCode = [self.info.currency uppercaseString];
    paymentRequest.paymentSummaryItems = [self summaryItems];
    paymentRequest.shippingMethods = [self shippingMethod];
    return paymentRequest;
}

- (PKContact *)contactForAddress:(Address *)address {
    PKContact *contact = [[PKContact alloc]init];
    
    NSPersonNameComponents *nameComponent = [[NSPersonNameComponents alloc]init];
    address.name = [address.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    nameComponent.givenName = [[address.name componentsSeparatedByString:@" "]firstObject];
    if ([[address.name componentsSeparatedByString:@" "]count] > 1)
        nameComponent.familyName = [[address.name componentsSeparatedByString:@" "]objectAtIndex:1];
    contact.name = nameComponent;
    
    CNPhoneNumber *phone = [CNPhoneNumber phoneNumberWithStringValue:address.phoneNumber];
    contact.phoneNumber = phone;
    
    NSString * streetAdress = [NSString stringWithFormat:@"%@\n%@",[address.addressLine1 stringByReplacingOccurrencesOfString:@" " withString:@"\n"],[address.addressLine2 stringByReplacingOccurrencesOfString:@" " withString:@"\n"]];
    
    CNMutablePostalAddress *postalAddress = [[CNMutablePostalAddress alloc]init];
    postalAddress.postalCode = address.postalCode;
    postalAddress.street = streetAdress;
    postalAddress.ISOCountryCode = address.country;
    postalAddress.country = address.country;
    postalAddress.city = address.city;
    postalAddress.state = address.province;
    
    contact.postalAddress = postalAddress;
    
    return contact;
}

- (NSArray *)summaryItems {
    NSMutableArray *summaryItems = [[NSMutableArray alloc]init];
    NSString *vanityCode;
    NSString *vanityValue;
    if ([self.info.vanityCodes count] > 0) {
        NSString *currentVanity = [[self.info.vanityCodes allKeys]firstObject];
        NSDictionary *vanityDic = [self.info.vanityCodes valueForKey:currentVanity];
        if ([[vanityDic valueForKey:@"success"]boolValue]) {
            vanityCode = [NSString stringWithFormat:@"DISCOUNT (%@)",[currentVanity uppercaseString]];
            vanityValue = [NSString stringWithFormat:@"%@",[[self.info.vanityCodes valueForKey:currentVanity]valueForKey:@"discount"]];
            float price = [vanityValue floatValue];
            self.info.bagTotalPrice = [NSString stringWithFormat:@"%.2f",self.info.bagTotalPrice.floatValue + price];
        }
    }
    [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:@"BAG TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.bagTotalPrice]]];
    if (vanityCode)
        [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:vanityCode amount:[NSDecimalNumber decimalNumberWithString:vanityValue]]];
    if (self.info.promoCredit.floatValue > 0.0) {
        self.info.promoCredit = [NSString stringWithFormat:@"%.2f",self.info.promoCredit.floatValue];
       [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:@"PROMO CREDIT" amount:[NSDecimalNumber decimalNumberWithString:self.info.promoCredit]]];
    }
    [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:@"SUBTOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.subTotalPrice]]];
    [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:@"SHIPPING" amount:[NSDecimalNumber decimalNumberWithString:self.info.shippingPrice]]];
    for (int i = 0; i < [self.info.taxes count]; i++)
        [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:[[[self.info.taxes objectAtIndex:i]valueForKey:@"label"]uppercaseString] amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",[[self.info.taxes objectAtIndex:i]valueForKey:@"amount"]]]]];
    [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:@"ORDER TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.orderTotalPrice]]];
    if (self.info.accountCredit.floatValue > 0.0){
        self.info.accountCredit = [NSString stringWithFormat:@"%.2f",self.info.accountCredit.floatValue];
        [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:@"ACCOUNT CREDIT" amount:[NSDecimalNumber decimalNumberWithString:self.info.accountCredit]]];
    }
    [summaryItems addObject:[PKPaymentSummaryItem summaryItemWithLabel:@"BEYOND THE RACK" amount:[NSDecimalNumber decimalNumberWithString:self.info.allTotalPrice]]];
    return summaryItems;
}

- (NSArray *)shippingMethod {
    NSMutableArray *shippingMethods = [[NSMutableArray alloc]init];
    if ([self.info.isPickup boolValue]) {
        PKShippingMethod *newMethod = [[PKShippingMethod alloc]init];
        [newMethod setLabel:@"PICKUP"];
        [newMethod setIdentifier:@"PICKUP"];
        [newMethod setDetail:[self.info pickupTitle]];
        [newMethod setAmount:[NSDecimalNumber decimalNumberWithString:@"0"]];
        [shippingMethods addObject:newMethod];
    }
    else if ([self.info.vipPickup boolValue]){
        PKShippingMethod *newMethod = [[PKShippingMethod alloc]init];
        [newMethod setLabel:@"VIP PICKUP"];
        [newMethod setIdentifier:@"VIPPICKUP"];
        [newMethod setDetail:[self.info pickupTitle]];
        [newMethod setAmount:[NSDecimalNumber decimalNumberWithString:@"0"]];
        [shippingMethods addObject:newMethod];
    } else {
        PKShippingMethod *newMethod = [[PKShippingMethod alloc]init];
        [newMethod setLabel:@"SHIPPING"];
        [newMethod setIdentifier:@"SHIPPING"];
        [newMethod setDetail:@"SHIPPING"];
        [newMethod setAmount:[NSDecimalNumber decimalNumberWithString:self.info.shippingPrice]];
        [shippingMethods addObject:newMethod];
    }
    return shippingMethods;
}

- (void)requestForTokenWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRApplePayFetcher URLForRequestToken]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
        success(response);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (void)initWithClientWithToken:(NSString *)token andOrderInfromation:(Order *)information checkoutMode:(checkoutMode)mode{
    if (mode == checkoutOne) {
        if ([information.isFreeshipAddress boolValue]) {
            information.isPickup = @"0";
            information.vipPickup = @"0";
        }
    }
    self.braintreeClient = [[BTAPIClient alloc]initWithAuthorization:token];
    self.info = information;
    self.currentCheckOutMode = mode;
}

- (NSString *)makePhoneNumberFromString:(NSString *)phoneNumber {
    if (phoneNumber) {
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *resultString = [[phoneNumber componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
        return resultString;
    }
    return @"";
}

- (void)showPaymentViewFromViewController:(UIViewController *)viewController {
    [BTRGAHelper logScreenWithName:@"/checkout/ApplePay"];
    self.applePayIsLoaded = NO;
    self.addressChanged = NO;
    PKPaymentRequest *paymentRequest = [self paymentRequest];
    self.vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
    self.vc.delegate = self;
    [viewController presentViewController:self.vc animated:YES completion:^{
        self.applePayIsLoaded = YES;
    }];
}

#pragma mark Delegates

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion{
    
    if (![self isContactCompelet:payment.shippingContact]) {
        completion(PKPaymentAuthorizationStatusInvalidShippingPostalAddress);
        return;
    }
    if (![self isPhoneNumberCompeletInContact:payment.shippingContact]) {
        completion(PKPaymentAuthorizationStatusInvalidShippingContact);
        return;
    }
    if (![self isContactCompelet:payment.billingContact]) {
        completion(PKPaymentAuthorizationStatusInvalidBillingPostalAddress);
        return;
    }
    
    BTApplePayClient *applePayClient = [[BTApplePayClient alloc]
                                        initWithAPIClient:self.braintreeClient];
    self.paymentInfo = payment;
    [applePayClient tokenizeApplePayPayment:payment
                                 completion:^(BTApplePayCardNonce *tokenizedApplePayPayment,
                                              NSError *error) {
                                     if (tokenizedApplePayPayment) {
                                         [self setNonce:tokenizedApplePayPayment.nonce];
                                         completion(PKPaymentAuthorizationStatusSuccess);
                                     } else {
                                         completion(PKPaymentAuthorizationStatusFailure);
                                     }
                                 }];
    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        if (self.nonce) {
            [self.delegate applePayProcessDidStart];
            [self processApplePayWithSuccess:^(id responseObject) {
            } failure:^(NSError *error) {
                [self.delegate applePayInfoFailedWithError:error];
            }];
        }
    }];
}

- (void)processApplePayWithSuccess:(void (^)(id  responseObject)) success
                              failure:(void (^)(NSError *error)) failure {
    [self makeOrderInfo];
    NSString* url = [NSString stringWithFormat:@"%@",[BTRApplePayFetcher URLForCheckout]];
    [BTRConnectionHelper postDataToURL:url withParameters:[self makeOrderInfo] setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        if ([[[response valueForKey:@"payment"]valueForKey:@"success"]boolValue])
            [self getConfirmationInfoWithOrderID:[[response valueForKey:@"order"]valueForKey:@"order_id"]];
    } faild:^(NSError *error) {
        [self.delegate applePayInfoFailedWithError:error];
    }];
}

- (NSMutableDictionary *)makeOrderInfo{
    NSMutableDictionary *order = [[NSMutableDictionary alloc]init];
    NSDictionary *nonce = [NSDictionary dictionaryWithObject:self.nonce forKey:@"nonce"];
    [order setObject:nonce forKey:@"applePay"];
    
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc]init];
    if (!self.addressChanged) {
        [orderInfo setObject:[self dictionatyOfAddress:self.info.shippingAddress] forKey:@"shipping"];
    }
    else
        [orderInfo setObject:[self addressForContact:self.paymentInfo.shippingContact] forKey:@"shipping"];
    self.paymentInfo.billingContact.phoneNumber = self.paymentInfo.shippingContact.phoneNumber;
    [orderInfo setObject:[self addressForContact:self.paymentInfo.billingContact] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:self.info.isPickup.boolValue] forKey:@"is_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:self.info.vipPickup.boolValue] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:self.info.isGift.boolValue] forKey:@"is_gift"];
    
    if (self.recipientMessage)
        [orderInfo setObject:self.recipientMessage forKey:@"recipient_message"];
    else
        [orderInfo setObject:@"" forKey:@"recipient_message"];
    
    if (self.selectedPromoGifts)
        [order setObject:self.selectedPromoGifts forKey:@"promotions_opted_in"];
    else
        [order setObject:[NSArray array] forKey:@"promotions_opted_in"];
    
    if (self.vanityCodes)
        [order setObject:self.vanityCodes forKey:@"vanity_codes"];
    else
        [order setObject:[NSArray array] forKey:@"vanity_codes"];
    
    [order setObject:orderInfo forKey:@"orderInfo"];
    
    return order;
}

- (NSDictionary *)addressForContact:(PKContact *)contact {
    NSMutableDictionary* addressDic = [[NSMutableDictionary alloc]init];
    [addressDic setObject:[NSString stringWithFormat:@"%@ %@",contact.name.givenName,contact.name.familyName] forKey:@"name"];
    if (contact.postalAddress.postalCode){
        NSString *postCode = [contact.postalAddress.postalCode stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([postCode length] < 4)
            [addressDic setObject:[[contact.postalAddress postalCode]stringByAppendingString:@"@@@"] forKey:@"postal"];
        else
            [addressDic setObject:[contact.postalAddress postalCode] forKey:@"postal"];
    }
    else
        [addressDic setObject:@"" forKey:@"postal"];
    
    if (contact.postalAddress.street) {
        NSArray *array = [contact.postalAddress.street componentsSeparatedByString:@"\n"];
        if ([array count] == 1) {
            [addressDic setObject:contact.postalAddress.street forKey:@"address1"];
            [addressDic setObject:@"" forKey:@"address2"];
        } else {
            NSString *addressOne = @"";
            for (int i = 0; i <([array count] / 2); i++)
                addressOne = [addressOne stringByAppendingString:[array objectAtIndex:i]];
            NSString *addressTwo = @"";
            for (unsigned long i = ([array count] / 2); i <[array count]; i++)
                addressTwo = [addressTwo stringByAppendingString:[array objectAtIndex:i]];
            [addressDic setObject:addressOne forKey:@"address1"];
            [addressDic setObject:addressTwo forKey:@"address2"];
        }
    }
    else {
        [addressDic setObject:@"" forKey:@"address1"];
        [addressDic setObject:@"" forKey:@"address2"];
    }
    
    if ([contact.postalAddress.ISOCountryCode length] > 0)
        [addressDic setObject:[contact.postalAddress.ISOCountryCode uppercaseString] forKey:@"country"];
    else if ([contact.postalAddress.country isEqualToString:@"United States"])
        [addressDic setObject:@"US" forKey:@"country"];
    else if ([contact.postalAddress.country isEqualToString:@"Canada"])
        [addressDic setObject:@"CA" forKey:@"country"];
    else
        [addressDic setObject:@"" forKey:@"country"];
    
    if (contact.postalAddress.state && contact.postalAddress.state.length > 2)
        [addressDic setObject:[BTRViewUtility provinceCodeforName:contact.postalAddress.state] forKey:@"state"];
    else if (contact.postalAddress)
        [addressDic setObject:contact.postalAddress.state forKey:@"state"];
    else
        [addressDic setObject:@"" forKey:@"state"];
    
    if (contact.phoneNumber)
        [addressDic setObject:[self makePhoneNumberFromString:contact.phoneNumber.stringValue] forKey:@"phone"];
    else
        [addressDic setObject:@"" forKey:@"phone"];
    
    if (contact.postalAddress.city)
        [addressDic setObject:contact.postalAddress.city forKey:@"city"];
    else
        [addressDic setObject:@"" forKey:@"city"];
    return addressDic;
}

- (NSDictionary *)dictionatyOfAddress:(Address *)address {
    NSDictionary *addressDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                address.name,@"name",
                                address.addressLine1,@"address1",
                                address.addressLine2,@"address2",
                                address.country,@"country",
                                address.postalCode,@"postal",
                                address.province,@"state",
                                address.city,@"city",
                                address.phoneNumber,@"phone"
                                , nil];
    return addressDic;
}

- (NSString *)stringOfAddress:(Address *)address {
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",address.addressLine1,address.addressLine2,address.city,address.province,address.country,address.postalCode];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingContact:(PKContact *)contact completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
    self.info.vipPickup = @"0";
    self.info.isPickup = @"0";
    if (![self isContactCompeletForValidate:contact]) {
        completion(PKPaymentAuthorizationStatusInvalidShippingPostalAddress,[self shippingMethod],[self summaryItems]);
        return;
    }
    if ((self.applePayIsLoaded && self.currentCheckOutMode == checkoutTwo) || self.currentCheckOutMode == checkoutOne) {
        [self validateShippingAddress:[self addressForContact:contact] andBillingAddress:[self dictionatyOfAddress:self.info.billingAddress] AndInCompletion:^{
            self.addressChanged = YES;
            completion(PKPaymentAuthorizationStatusSuccess,[self shippingMethod],[self summaryItems]);
        }];
    }
    else {
        completion(PKPaymentAuthorizationStatusSuccess,[self shippingMethod],[self summaryItems]);
    }
}

- (BOOL)isContactCompeletForValidate:(PKContact *)contact {
    if ([[[contact postalAddress]postalCode]length] == 0)
        return NO;
    if ([[[contact postalAddress]city]length] == 0)
        return NO;
    if ([[[contact postalAddress]state]length] == 0)
        return NO;
    if ([[[contact postalAddress]country]length] == 0)
        return NO;
    return YES;
}

- (BOOL)isContactCompelet:(PKContact *)contact {
    if ([[[contact name]familyName]length] == 0 && [[[contact name]givenName]length] == 0)
        return NO;
    if ([[[contact postalAddress]street]length] == 0)
        return NO;
    if ([[[contact postalAddress]postalCode]length] == 0)
        return NO;
    if ([[[contact postalAddress]city]length] == 0)
        return NO;
    if ([[[contact postalAddress]state]length] == 0)
        return NO;
    if ([[[contact postalAddress]country]length] == 0)
        return NO;
    return YES;
}

- (BOOL)isPhoneNumberCompeletInContact:(PKContact *)contact{
    if (contact.phoneNumber == nil)
        return NO;
    if ([self makePhoneNumberFromString:contact.phoneNumber.stringValue].length < 8 || [self makePhoneNumberFromString:contact.phoneNumber.stringValue].length > 15 )
        return NO;
    return YES;
}


//
//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion {
//    NSLog(@"Shipping Did Select");
//
//    if ([shippingMethod.identifier isEqualToString:@"PICKUP"])
//        [self.info setIsPickup:@"1"];
//    else
//        [self.info setIsPickup:@"0"];
//    
//    if ([shippingMethod.identifier isEqualToString:@"VIPPICKUP"])
//        [self.info setVipPickup:@"1"];
//    else
//        [self.info setVipPickup:@"0"];
//    
//    [self validateShippingAddress:[self dictionatyOfAddress:self.info.shippingAddress] andBillingAddress:[self dictionatyOfAddress:self.info.billingAddress] AndInCompletion:^{
//        completion(PKPaymentAuthorizationStatusSuccess,[self summaryItems]);
//    }];
//}

- (void)validateShippingAddress:(NSDictionary *)shippingAddress andBillingAddress:(NSDictionary*)billingAddress AndInCompletion:(void(^)())completionBlock; {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    
    [orderInfo setObject:shippingAddress forKey:@"shipping"];
    [orderInfo setObject:billingAddress forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.info.isGift boolValue]] forKey:@"is_gift"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.info.vipPickup boolValue]] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:[self.info.isPickup boolValue]] forKey:@"is_pickup"];
    [params setObject:[NSArray array] forKey:@"vanity_codes"];
    [params setObject:orderInfo forKey:@"orderInfo"];
    
    NSString* url = [NSString stringWithFormat:@"%@", [BTROrderFetcher URLforAddressValidation]];
    [BTRConnectionHelper postDataToURL:url withParameters:params setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [Order extractOrderfromJSONDictionary:response forOrder:self.info isValidating:YES];
        if (completionBlock)
            completionBlock(nil);
    } faild:^(NSError *error) {
        
    }];
}

- (void)getConfirmationInfoWithOrderID:(NSString *)orderID {
    NSString* url = [NSString stringWithFormat:@"%@",[BTROrderFetcher URLforOrderNumber:orderID]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response,NSString *jSonString) {
        [self.delegate applePayReceiptInfoDidReceivedSuccessful:response];
    } faild:^(NSError *error) {
        [self.delegate applePayInfoFailedWithError:error];
    }];
}

- (void)setupApplePay {
    PKPassLibrary* passbookLibrary = [[PKPassLibrary alloc] init];
    [passbookLibrary openPaymentSetup];
}

- (ABRecordRef)recordFromAddress:(Address *)userAddress withLabel:(NSString *)label{
    NSString *fullname = [userAddress.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *firstName = [[fullname componentsSeparatedByString:@" "]firstObject];
    NSString *lastName = @" ";
    if ([[userAddress.name componentsSeparatedByString:@" "]count] > 1)
        lastName = [[userAddress.name componentsSeparatedByString:@" "]objectAtIndex:1];
    
    NSString * streetAdress = [NSString stringWithFormat:@"%@ %@",userAddress.addressLine1,userAddress.addressLine2];
    
    ABRecordRef person = ABPersonCreate();
    CFErrorRef error = NULL;
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(firstName), &error);
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(lastName), &error);
    
    ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
    CFStringRef keys[6];
    CFStringRef values[6];
    
    keys[0] = kABPersonAddressStreetKey;
    keys[1] = kABPersonAddressCityKey;
    keys[2] = kABPersonAddressStateKey;
    keys[3] = kABPersonAddressZIPKey;
    keys[4] = kABPersonAddressCountryKey;
    keys[5] = kABPersonAddressCountryCodeKey;
    
    CFStringRef ref1;
    CFStringRef ref2;
    CFStringRef ref3;
    CFStringRef ref4;
    CFStringRef ref5;
    CFStringRef ref6;
    
    if (streetAdress.length > 0)
        ref1 = (__bridge_retained CFStringRef)streetAdress;
    else
        ref1 = CFSTR("");
    if (userAddress.city.length > 0)
        ref2 = (__bridge_retained CFStringRef)userAddress.city;
    else
        ref2 = CFSTR("");
    if (userAddress.province.length > 0)
        ref3 = (__bridge_retained CFStringRef)userAddress.province;
    else
        ref3 = CFSTR("");
    if (userAddress.postalCode.length > 0)
        ref4 = (__bridge_retained CFStringRef)userAddress.postalCode;
    else
        ref4 = CFSTR("");
    if (userAddress.country.length > 0) {
        ref5 = (__bridge_retained CFStringRef)[BTRViewUtility countryNameforCode:userAddress.country];
        ref6 = (__bridge_retained CFStringRef)userAddress.country;
    }
    else {
        ref5 = CFSTR("");
        ref6 = CFSTR("");
    }
    
    values[0] = ref1;
    values[1] = ref2;
    values[2] = ref3;
    values[3] = ref4;
    values[4] = ref5;
    values[5] = ref6;
    
    CFDictionaryRef dicref = CFDictionaryCreate(kCFAllocatorDefault, (void *)keys, (void *)values, 6, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    ABMultiValueIdentifier identifier;
    ABMultiValueAddValueAndLabel(address, dicref, (__bridge_retained CFStringRef)label, &identifier);
    ABRecordSetValue(person, kABPersonAddressProperty, address,&error);
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(userAddress.phoneNumber), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);

    return person;
}

@end
