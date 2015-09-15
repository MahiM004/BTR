//
//  MPManager.h
//  MPTestPairApp
//
//  Created by David Benko on 10/31/14.
//  Copyright (c) 2015 AnyPresence, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLightboxViewController.h"
#import "MPCreditCard.h"
#import "MPAddress.h"
#import "MasterPassInfo.h"

@protocol MPManagerDelegate <NSObject>

@optional

/**
 * Method that executes when pairing completes
 *
 * @param success the status of the pairing
 * @param error any errors that occurred during pairing
 */
-(void)pairingDidCompleteError:(NSError *)error;

/**
 * Method that executes when checkout completes
 *
 * @param success the status of the checkout
 * @param error any errors that occurred during checkout
 */
- (void)checkoutDidCompleteWithError:(NSError *)error withInfo:(NSString *)info;

/**
 * Method that executes when precheckout completes
 *
 * @param success the status of the checkout
 * @param data the precheckout data
 * @param error any errors that occurred during checkout
 */
- (void)preCheckoutDidCompleteWithData:(NSDictionary *)data error:(NSError *)error;

/**
 * Method that executes when pair & checkout completes
 *
 * @param success the status of the checkout
 * @param error any errors that occurred during checkout
 */
- (void)pairCheckoutDidCompleteWithError:(NSError *)error;

/**
 * Method that executes when manual checkout completes
 *
 * @param success the status of the checkout
 * @param error any errors that occurred during checkout
 */
- (void)manualCheckoutDidComplete:(BOOL)success error:(NSError *)error;

/**
 * Method to force the reset of a user token
 * This is usually acheived by forceably removing the 
 * long access token from the user object
 */
- (void)resetUserPairing;


/**
 * Method that executes when checkout has been canceled
 *
 *
 */
- (void)checkoutDidCancel;

@end

@interface MPManager : NSObject

FOUNDATION_EXPORT NSString *const DataTypeCard;         // Constant for Card Datatype. Used for initializing some MP services.
FOUNDATION_EXPORT NSString *const DataTypeAddress;      // Constant for Address Datatype. Used for initializing some MP services.
FOUNDATION_EXPORT NSString *const DataTypeProfile;      // Constant for Profile Datatype. Used for initializing some MP services.

FOUNDATION_EXPORT NSString *const CardTypeAmex;         // Constant for American Express Card Support
FOUNDATION_EXPORT NSString *const CardTypeMasterCard;   // Constant for MasterCard Card Support
FOUNDATION_EXPORT NSString *const CardTypeDiscover;     // Constant for Discover Card Support
FOUNDATION_EXPORT NSString *const CardTypeVisa;         // Constant for Visa Card Support
FOUNDATION_EXPORT NSString *const CardTypeMaestro;      // Constant for Maestro Card Support

FOUNDATION_EXPORT NSString *const MPErrorNotPaired;

@property (nonatomic, weak) id<MPManagerDelegate> delegate;


#pragma mark - Init

/**
 * Initializes (for returns the shared instance of) the manager to interact with
 * the MasterPass services
 *
 * @return MPManager instance
 */
+ (instancetype)sharedInstance;


#pragma mark - Manual Checkout


- (void)pairAndCheckoutInViewController:(UIViewController *)viewController WithInfo:(MasterPassInfo *)info;

@end
