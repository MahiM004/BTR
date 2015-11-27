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


@protocol ApplePayDelegate <NSObject>

- (void)applePayReceiptInfoDidReceivedSuccessful:(NSDictionary *)receiptInfo;
- (void)applePayInfoFailedWithError:(NSError *)error;

@end

@interface ApplePayManager : NSObject <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic,strong) id <ApplePayDelegate> delegate;

- (void)requestForTokenWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure;
- (void)initWithClientWithToken:(NSString *)token andOrderInfromation:(NSDictionary *)information;
- (void)showPaymentViewFromViewController:(UIViewController *)viewController;
- (BOOL)isApplePlayAvailable;

@end
