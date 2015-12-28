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
    paymentRequest.merchantIdentifier = @"merchant.com.beyondtherack.sandbox";
    paymentRequest.requiredShippingAddressFields = (PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName);
    paymentRequest.requiredBillingAddressFields = (PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName);
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    paymentRequest.billingContact = [self contactForAddress:self.info.billingAddress];
    paymentRequest.shippingContact = [self contactForAddress:self.info.shippingAddress];
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
    nameComponent.givenName = [[address.name componentsSeparatedByString:@" "]firstObject];
    if ([[address.name componentsSeparatedByString:@" "]count] > 1)
        nameComponent.familyName = [[address.name componentsSeparatedByString:@" "]objectAtIndex:1];
    contact.name = nameComponent;
    
    CNPhoneNumber *phone = [CNPhoneNumber phoneNumberWithStringValue:address.phoneNumber];
    contact.phoneNumber = phone;
    
    CNMutablePostalAddress *postalAddress = [[CNMutablePostalAddress alloc]init];
    postalAddress.postalCode = address.postalCode;
    postalAddress.street = address.addressLine1;
    postalAddress.ISOCountryCode = address.country;
    postalAddress.city = address.city;
    postalAddress.state = address.province;
    contact.postalAddress = postalAddress;
    return contact;
}

- (NSArray *)summaryItems {
    NSArray *summaryItems;
    if ([self.info.taxes count] > 1) {
        summaryItems =
        @[
          [PKPaymentSummaryItem summaryItemWithLabel:@"BAG TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.bagTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"SUBTOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.subTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:[[[self.info.taxes firstObject]valueForKey:@"label"]uppercaseString] amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",[[self.info.taxes firstObject]valueForKey:@"amount"]]]],
          [PKPaymentSummaryItem summaryItemWithLabel:[[[self.info.taxes objectAtIndex:1]valueForKey:@"label"]uppercaseString] amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",[[self.info.taxes objectAtIndex:1]valueForKey:@"amount"]]]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"SHIPPING" amount:[NSDecimalNumber decimalNumberWithString:self.info.shippingPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"ORDER TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.orderTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"BEYOND THE RACK" amount:[NSDecimalNumber decimalNumberWithString:self.info.orderTotalPrice]],
          ];
    }else if ([self.info.taxes count] > 0) {
        summaryItems =
        @[
          [PKPaymentSummaryItem summaryItemWithLabel:@"BAG TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.bagTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"SUBTOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.subTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:[[[self.info.taxes firstObject]valueForKey:@"label"]uppercaseString] amount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",[[self.info.taxes firstObject]valueForKey:@"amount"]]]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"SHIPPING" amount:[NSDecimalNumber decimalNumberWithString:self.info.shippingPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"ORDER TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.orderTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"BEYOND THE RACK" amount:[NSDecimalNumber decimalNumberWithString:self.info.orderTotalPrice]],
          ];
    } else {
        summaryItems =
        @[
          [PKPaymentSummaryItem summaryItemWithLabel:@"BAG TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.bagTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"SUBTOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.subTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"SHIPPING" amount:[NSDecimalNumber decimalNumberWithString:self.info.shippingPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"ORDER TOTAL" amount:[NSDecimalNumber decimalNumberWithString:self.info.orderTotalPrice]],
          [PKPaymentSummaryItem summaryItemWithLabel:@"BEYOND THE RACK" amount:[NSDecimalNumber decimalNumberWithString:self.info.orderTotalPrice]],
          ];
    }
    return summaryItems;
}

- (NSArray *)shippingMethod {
    NSMutableArray *shippingMethods = [[NSMutableArray alloc]init];
    if ([self.info.isPickup boolValue]) {
        PKShippingMethod *newMethod = [[PKShippingMethod alloc]init];
        [newMethod setLabel:self.info.pickupTitle];
        [newMethod setIdentifier:@"PICKUP"];
        [newMethod setDetail:[self stringOfAddress:[self.info pickupAddress]]];
        [newMethod setAmount:[NSDecimalNumber decimalNumberWithString:@"0"]];
        [shippingMethods addObject:newMethod];
    }
    else if ([self.info.vipPickup boolValue]){
        PKShippingMethod *newMethod = [[PKShippingMethod alloc]init];
        [newMethod setLabel:self.info.pickupTitle];
        [newMethod setIdentifier:@"VIPPICKUP"];
        [newMethod setDetail:[self stringOfAddress:[self.info pickupAddress]]];
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
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(response);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (void)initWithClientWithToken:(NSString *)token andOrderInfromation:(Order *)information checkoutMode:(checkoutMode)mode{
    self.braintreeClient = [[BTAPIClient alloc]initWithAuthorization:token];
    self.info = information;
    self.currentCheckOutMode = mode;
}

- (void)showPaymentViewFromViewController:(UIViewController *)viewController {
    self.applePayIsLoaded = NO;
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
    [orderInfo setObject:[self addressForContact:self.paymentInfo.shippingContact] forKey:@"shipping"];
    [orderInfo setObject:[self addressForContact:self.paymentInfo.billingContact] forKey:@"billing"];
    [orderInfo setObject:[NSNumber numberWithBool:self.info.isPickup.boolValue] forKey:@"is_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:self.info.vipPickup.boolValue] forKey:@"vip_pickup"];
    [orderInfo setObject:[NSNumber numberWithBool:self.info.isGift.boolValue] forKey:@"is_gift"];
    
    if (self.recipientMessage)
        [orderInfo setObject:self.recipientMessage forKey:@"recipient_message"];
    else
        [orderInfo setObject:@"" forKey:@"recipient_message"];
    
    if (self.vanityCodes)
        [orderInfo setObject:self.vanityCodes forKey:@"vanity_codes"];
    else
        [orderInfo setObject:[NSArray array] forKey:@"vanity_codes"];
    [order setObject:orderInfo forKey:@"orderInfo"];
    
    return order;
}

- (NSDictionary *)addressForContact:(PKContact *)contact {
    NSMutableDictionary* addressDic = [[NSMutableDictionary alloc]init];
    [addressDic setObject:[NSString stringWithFormat:@"%@ %@",contact.name.givenName,contact.name.familyName] forKey:@"name"];
    
    if (contact.postalAddress.postalCode)
        if ([contact.postalAddress.postalCode length] < 4)
            [addressDic setObject:[[contact.postalAddress postalCode]stringByAppendingString:@"@@@"] forKey:@"postal"];
        else
            [addressDic setObject:[contact.postalAddress postalCode] forKey:@"postal"];
    else
        [addressDic setObject:@" " forKey:@"postal"];
    
    if (contact.postalAddress.street)
        [addressDic setObject:contact.postalAddress.street forKey:@"address1"];
    else
        [addressDic setObject:@" " forKey:@"address1"];
    
    [addressDic setObject:@" " forKey:@"address2"];

    if (contact.postalAddress.ISOCountryCode)
        [addressDic setObject:contact.postalAddress.ISOCountryCode forKey:@"country"];
    else
        [addressDic setObject:@" " forKey:@"country"];
    
    if (contact.postalAddress.state)
        [addressDic setObject:contact.postalAddress.state forKey:@"state"];
    else
        [addressDic setObject:@" " forKey:@"state"];
    
    if (contact.phoneNumber)
        [addressDic setObject:contact.phoneNumber.stringValue forKey:@"phone"];
    else
        [addressDic setObject:@" " forKey:@"phone"];
    
    if (contact.postalAddress.city)
        [addressDic setObject:contact.postalAddress.city forKey:@"city"];
    else
        [addressDic setObject:@" " forKey:@"city"];
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
    if ((self.applePayIsLoaded && self.currentCheckOutMode == checkoutTwo) || self.currentCheckOutMode == checkoutOne) {
        [self validateShippingAddress:[self addressForContact:contact] andBillingAddress:[self dictionatyOfAddress:self.info.billingAddress] AndInCompletion:^{
            completion(PKPaymentAuthorizationStatusSuccess,[self shippingMethod],[self summaryItems]);
        }];
    }
    else {
        completion(PKPaymentAuthorizationStatusSuccess,[self shippingMethod],[self summaryItems]);
    }
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
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [self.delegate applePayReceiptInfoDidReceivedSuccessful:response];
    } faild:^(NSError *error) {
        [self.delegate applePayInfoFailedWithError:error];
    }];
}

- (void)setupApplePay {
    PKPassLibrary* passbookLibrary = [[PKPassLibrary alloc] init];
    [passbookLibrary openPaymentSetup];
}

@end
