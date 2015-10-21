//
//  MPManager.m
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPManager.h"

@interface MPManager () <MPLightboxViewControllerDelegate>

@end

@implementation MPManager

NSString *const DataTypeCard = @"CARD";
NSString *const DataTypeAddress = @"ADDRESS";
NSString *const DataTypeProfile = @"PROFILE";

NSString *const CardTypeAmex = @"amex";
NSString *const CardTypeMasterCard = @"master";
NSString *const CardTypeDiscover = @"discover";
NSString *const CardTypeVisa = @"visa";
NSString *const CardTypeMaestro = @"maestro";

NSString *const MPVersion = @"v6";

NSString *const MPErrorDomain = @"MasterPassErrorDomain";
NSString *const MPErrorNotPaired = @"No long access token found associated with user (user not paired with Masterpass)";
NSInteger const MPErrorCodeBadRequest = 400;

#pragma mark - Init

+ (instancetype)sharedInstance{
    static MPManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance) return sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [MPManager alloc];
        sharedInstance = [sharedInstance init];
    });
    
    return sharedInstance;
}


- (void)pairAndCheckoutInViewController:(UIViewController *)viewController WithInfo:(MasterPassInfo *)info {
    NSDictionary *lightBoxParams = @{@"requestToken":info.requestToken,
                                     @"merchantCheckoutId":info.merchantCheckoutId,
                                     @"requestedDataTypes":info.requestDataType,
                                     @"callbackUrl":info.callbackUrl,
                                     @"pairingRequestToken":info.pairingRequestToken,
                                     @"allowedCardTypes":info.allowedCardTypes,
                                     @"requestPairing":info.requestPairing,
                                     @"version":info.version,
                                     @"shippingLocationProfile":info.shippingLocationProfile
                                     };
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLightboxWindowOfType:MPLightBoxTypeCheckout options:lightBoxParams inViewController:viewController];
    });
}

- (void)showLightboxWindowOfType:(MPLightBoxType)type options:(NSDictionary *)options inViewController:(UIViewController *)viewController{
    MPLightboxViewController *lightboxViewController = [[MPLightboxViewController alloc]init];
    lightboxViewController.delegate = self;
    [viewController presentViewController:lightboxViewController animated:YES completion:^{
        [lightboxViewController initiateLightBoxOfType:type WithOptions:options];
    }];
}



#pragma mark - Delegates

-(void)pairingView:(MPLightboxViewController *)pairingViewController didCompletePairingWithError:(NSError *)error{
    [pairingViewController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(pairingDidCompleteError:)]) {
            [self.delegate pairingDidCompleteError:error];
        }
    }];
}

- (void)lightBox:(MPLightboxViewController *)pairingViewController didCompleteCheckoutWithError:(NSError *)error Info:(NSString *)info {
    [pairingViewController dismissViewControllerAnimated:YES completion:^{
        
        if ([info containsString:@"cancel"]) {
            if ([self.delegate respondsToSelector:@selector(checkoutDidCancel)])
                [self.delegate checkoutDidCancel];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(checkoutDidCompleteWithError:withInfo:)]) {
            [self.delegate checkoutDidCompleteWithError:error withInfo:info];
        }
    }];
}

-(void)lightBox:(MPLightboxViewController *)lightBoxViewController didCompletePreCheckoutWithData:(NSDictionary *)data error:(NSError *)error{
    [lightBoxViewController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(preCheckoutDidCompleteWithData:error:)]) {
            [self.delegate preCheckoutDidCompleteWithData:data error:error];
        }
    }];
}


@end
