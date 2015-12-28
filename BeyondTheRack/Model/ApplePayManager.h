//
//  ApplePayManager.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-11-18.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

@import PassKit;

#import <Foundation/Foundation.h>
#import "BraintreeApplePay.h"
#import "Order+AppServer.h"

typedef enum checkoutMode {
    checkoutOne = 1,
    checkoutTwo = 2,
}checkoutMode;

@protocol ApplePayDelegate <NSObject>

- (void)applePayReceiptInfoDidReceivedSuccessful:(NSDictionary *)receiptInfo;
- (void)applePayInfoFailedWithError:(NSError *)error;

@end

@interface ApplePayManager : NSObject <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic,strong) id <ApplePayDelegate> delegate;
@property (nonatomic,strong) NSString *recipientMessage;
@property (nonatomic,strong) NSArray *vanityCodes;

- (void)requestForTokenWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure;
- (void)initWithClientWithToken:(NSString *)token andOrderInfromation:(Order *)information checkoutMode:(checkoutMode)mode;
- (void)showPaymentViewFromViewController:(UIViewController *)viewController;
- (BOOL)isApplePayAvailable;
- (BOOL)isApplePaySetup;
- (void)setupApplePay;

@end
