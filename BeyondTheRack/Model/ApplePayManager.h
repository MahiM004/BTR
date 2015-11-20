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

@interface ApplePayManager : NSObject <PKPaymentAuthorizationViewControllerDelegate>

+ (id)sharedManager;

- (void)requestForTokenWithSuccess:(void (^)(id  responseObject)) success
                           failure:(void (^)(NSError *error)) failure;
- (void)initWithClientWithToken:(NSString *)token;
- (void)showPaymentViewFromViewController:(UIViewController *)viewController;

@end
