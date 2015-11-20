//
//  ApplePayManager.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-11-18.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "ApplePayManager.h"
#import "BTRApplePayFetcher.h"
#import "BTRConnectionHelper.h"

@interface ApplePayManager()
@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, strong) NSString *token;
@end

@implementation ApplePayManager


- (PKPaymentRequest *)paymentRequest {
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.merchantIdentifier = @"merchant.com.beyondtherack.sandbox";
    paymentRequest.requiredShippingAddressFields = PKAddressFieldAll;
//    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard];
    paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
    paymentRequest.countryCode = @"CA"; // e.g. US
    paymentRequest.currencyCode = @"CAD"; // e.g. USD
    paymentRequest.paymentSummaryItems =
    @[
//      [PKPaymentSummaryItem summaryItemWithLabel:@"<#ITEM_NAME#>" amount:[NSDecimalNumber decimalNumberWithString:@"<#PRICE#>"]],
//      // Add add'l payment summary items...
      [PKPaymentSummaryItem summaryItemWithLabel:@"BEYONDTHERACK" amount:[NSDecimalNumber decimalNumberWithString:@"10.0"]]
      ];
    return paymentRequest;
}

+ (id)sharedManager {
    static ApplePayManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)requestForTokenWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure {
    NSString* url = [NSString stringWithFormat:@"%@",[BTRApplePayFetcher URLforRequestToken]];
    [BTRConnectionHelper getDataFromURL:url withParameters:nil setSessionInHeader:YES contentType:kContentTypeJSON success:^(NSDictionary *response) {
        success(response);
    } faild:^(NSError *error) {
        failure(error);
    }];
}

- (void)initWithClientWithToken:(NSString *)token {
    self.braintreeClient = [[BTAPIClient alloc]initWithAuthorization:token];
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
    [applePayClient tokenizeApplePayPayment:payment
                                 completion:^(BTApplePayCardNonce *tokenizedApplePayPayment,
                                              NSError *error) {
                                     if (tokenizedApplePayPayment) {
                                         // On success, send nonce to your server for processing.
                                         // If applicable, address information is accessible in `payment`.
                                         NSLog(@"nonce = %@", tokenizedApplePayPayment.nonce);
                                         
                                         // Then indicate success or failure via the completion callback, e.g.
                                         completion(PKPaymentAuthorizationStatusSuccess);
                                     } else {
                                         // Tokenization failed. Check `error` for the cause of the failure.
                                         
                                         // Indicate failure via the completion callback:
                                         completion(PKPaymentAuthorizationStatusFailure);
                                     }
                                 }];
    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
