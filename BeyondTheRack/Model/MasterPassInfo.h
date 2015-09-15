//
//  MasterPassInfo.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-20.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterPassInfo : NSObject

@property (nonatomic, retain) NSArray * allowedCardTypes;
@property (nonatomic, retain) NSArray * requestDataType;
@property (nonatomic, retain) NSString * callbackUrl;
@property (nonatomic, retain) NSString * cancelCallback;
@property (nonatomic, retain) NSNumber * loyaltyEnabled;
@property (nonatomic, retain) NSString * merchantCheckoutId;
@property (nonatomic, retain) NSString * pairingRequestToken;
@property (nonatomic, retain) NSNumber * requestBasicCheckout;
@property (nonatomic, retain) NSNumber * requestPairing;
@property (nonatomic, retain) NSString * requestToken;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSArray * shippingLocationProfile;

@end
