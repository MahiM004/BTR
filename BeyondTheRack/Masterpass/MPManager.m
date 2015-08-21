//
//  MPManager.m
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import "MPManager.h"
#import "NSDictionary+ObjectiveSugar.h"

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
                                     @"requestPairing":@1,
                                     @"version":MPVersion};
    
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

- (void)pairingView:(MPLightboxViewController *)pairingViewController didCompletePairing:(BOOL)success error:(NSError *)error{
    [pairingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"PAIR MANAGER");
        if ([self.delegate respondsToSelector:@selector(pairingDidComplete:error:)]) {
            [self.delegate pairingDidComplete:success error:error];
        }
    }];
}

-(void)lightBox:(MPLightboxViewController *)pairingViewController didCompleteCheckout:(BOOL)success error:(NSError *)error withInfo:(NSDictionary *)info{
    NSLog(@"CHECKOUR MANAGER , DELEGATE : %@",self.delegate);
    [pairingViewController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(checkoutDidComplete:error:withInfo:)]) {
            [self.delegate checkoutDidComplete:success error:error withInfo:info];
        }
    }];
}

-(void)lightBox:(MPLightboxViewController *)lightBoxViewController didCompletePreCheckout:(BOOL)success data:(NSDictionary *)data error:(NSError *)error{
    NSLog(@"PRECHECKOUT MANAGER");
    [lightBoxViewController dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(preCheckoutDidComplete:data:error:)]) {
            [self.delegate preCheckoutDidComplete:success data:data error:error];
        }
    }];
}


@end
