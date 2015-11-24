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

@interface ApplePayManager()
@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) PKPayment *paymentInfo;
@property (nonatomic, strong) NSString *nonce;
@end

@implementation ApplePayManager

- (PKPaymentRequest *)paymentRequest {
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.merchantIdentifier = @"merchant.com.beyondtherack.sandbox";
    paymentRequest.requiredShippingAddressFields = PKAddressFieldAll;
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    paymentRequest.countryCode = [self.info valueForKey:@"country"]; // e.g. US
    paymentRequest.currencyCode = [self.info valueForKey:@"currency"]; // e.g. USD
    paymentRequest.paymentSummaryItems =
    @[
      [PKPaymentSummaryItem summaryItemWithLabel:@"BEYONDTHERACK" amount:[NSDecimalNumber decimalNumberWithString:[self.info valueForKey:@"total"]]]
      ];
    return paymentRequest;
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

- (void)initWithClientWithToken:(NSString *)token andOrderInfromation:(NSDictionary *)information{
    self.braintreeClient = [[BTAPIClient alloc]initWithAuthorization:token];
    self.info = information;
}

- (void)showPaymentViewFromViewController:(UIViewController *)viewController {
    PKPaymentRequest *paymentRequest = [self paymentRequest];
    PKPaymentAuthorizationViewController *vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
    
    vc.delegate = self;
    [viewController presentViewController:vc animated:YES completion:nil];
        // Present Apple Pay as an option in your UI based on Apple's recommendations at https://developer.apple.com/apple-pay/

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
    [orderInfo setObject:[self addressFromRecord:self.paymentInfo.shippingAddress] forKey:@"shipping"];
    [orderInfo setObject:[self addressFromRecord:self.paymentInfo.billingAddress] forKey:@"billing"];
    
    if ([self.info valueForKey:@"is_pickup"])
        [orderInfo setObject:[self.info valueForKey:@"is_pickup"] forKey:@"is_pickup"];
    else
        [orderInfo setObject:@"" forKey:@"is_pickup"];
    
    if ([self.info valueForKey:@"vip_pickup"])
        [orderInfo setObject:[self.info valueForKey:@"vip_pickup"] forKey:@"vip_pickup"];
    else
        [orderInfo setObject:@"" forKey:@"vip_pickup"];
    
    if ([self.info valueForKey:@"is_gift"])
        [orderInfo setObject:[self.info valueForKey:@"is_gift"] forKey:@"is_gift"];
    else
        [orderInfo setObject:@"" forKey:@"is_gift"];
    
    if ([self.info valueForKey:@"recipient_message"])
        [orderInfo setObject:[self.info valueForKey:@"recipient_message"] forKey:@"recipient_message"];
    else
        [orderInfo setObject:@"" forKey:@"recipient_message"];
    
    if ([self.info valueForKey:@"vanity_codes"])
        [orderInfo setObject:[self.info valueForKey:@"vanity_codes"] forKey:@"vanity_codes"];
    else
        [orderInfo setObject:[NSArray array] forKey:@"vanity_codes"];
    
    [order setObject:orderInfo forKey:@"orderInfo"];
    return order;
}

- (NSDictionary *)addressFromRecord:(ABRecordRef)record {
    ABMultiValueRef addresses = ABRecordCopyValue(record, kABPersonAddressProperty);
    ABMultiValueRef phoneNumberMultiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
    NSString *phoneNumber  = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneNumberMultiValue, 0);
    if (phoneNumber == nil) {
        phoneNumber = @"8888888888";
    }
    CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(addresses, 0);
    NSString *fname = (__bridge NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonFirstNameProperty);
    NSString *lname = (__bridge NSString *)ABRecordCopyValue((ABRecordRef)record, kABPersonLastNameProperty);
    NSString *postCode = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey) copy];
    NSString *street = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey) copy];
    NSString *state = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey) copy];
    NSString *city = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey) copy];
    NSString *country = [[(NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryCodeKey) copy]uppercaseString];
    
    NSDictionary *addressDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@ %@",fname,lname],@"name",
                                street,@"address1",
                                @"",@"address2",
                                country,@"country",
                                postCode,@"postal",
                                state,@"state",
                                city,@"city",
                                phoneNumber,@"phone"
                                , nil];
    return addressDic;
}

- (void)getConfirmationInfoWithOrderID:(NSString *)orderID {
    NSString* url = [NSString stringWithFormat:@"%@",[BTROrderFetcher URLforOrderNumber:orderID]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        [self.delegate applePayReceiptInfoDidReceivedSuccessful:response];
    } faild:^(NSError *error) {
        [self.delegate applePayInfoFailedWithError:error];
    }];
}

@end
