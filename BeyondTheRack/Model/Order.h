//
//  Order.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-17.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "PromoItem.h"

@interface Order : NSObject <NSCopying>

@property BOOL isAccepted;
@property (nonatomic, retain) NSString * confirmDateTime;
@property (nonatomic, retain) NSString * confirmed;
@property (nonatomic, retain) NSString * createDateTime;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * orderStatus;
@property (nonatomic, retain) Address * pickupAddress;
@property (nonatomic, retain) NSString * pickupTitle;
@property (nonatomic, retain) Address * shippingAddress;
@property (nonatomic, retain) NSString * shippingRecipientName;
@property (nonatomic, retain) NSString * billingSameAsShipping;
@property (nonatomic, retain) Address * billingAddress;
@property (nonatomic, retain) NSString * cardHolderName;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, retain) NSString * ccvNumber;
@property (nonatomic, retain) NSString * expiryYear;
@property (nonatomic, retain) NSString * expiryMonth;
@property (nonatomic, retain) NSString * eligiblePickup;
@property (nonatomic, retain) NSString * cardToken;
@property (nonatomic, retain) NSString * paymentType;
@property (nonatomic, retain) NSString * lockCCFields;
@property (nonatomic, retain) NSNumber * forceCardUpdate;
@property (nonatomic, retain) NSString * vipPickupEligible;
@property (nonatomic, retain) NSString * vipPickup;
@property (nonatomic, retain) NSString * recipientGiftMessage;
@property (nonatomic, retain) NSString * isPickup;
@property (nonatomic, retain) NSString * isGift;
@property (nonatomic, retain) NSString * isVisaMe;
@property (nonatomic, retain) NSString * isPaypal;
@property (nonatomic, retain) NSString * isMasterpass;
@property (nonatomic, retain) NSString * isInterac;
@property (nonatomic, retain) NSString * cardNumber;
@property (nonatomic, retain) NSString * useToken;
@property (nonatomic, retain) NSString * requireCcv;
@property (nonatomic, retain) NSString * rememberCard;
@property (nonatomic, retain) NSString * isFreeshipAddress;
@property (nonatomic, retain) Address * promoBillingAddress;
@property (nonatomic, retain) NSString * promoBillingName;
@property (nonatomic, retain) Address * promoShippingAddress;
@property (nonatomic, retain) NSString * promoCredit;
@property (nonatomic, retain) NSString * accountCredit;
@property (nonatomic, retain) NSString * promoShipName;
@property (nonatomic, retain) NSString * billingName;
@property (nonatomic, retain) NSString * promoShipPhone;
@property (nonatomic, retain) NSString * bagTotalPrice;
@property (nonatomic, retain) NSString * subTotalPrice;
@property (nonatomic, retain) NSString * allTotalPrice;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * saving;
@property (nonatomic, retain) NSString * orderTotalPrice;
@property (nonatomic, retain) NSString * shippingPrice;
@property (nonatomic, retain) NSArray * taxes;
@property (nonatomic, retain) NSString * totalTax;
@property (nonatomic, retain) NSArray * items;
@property (nonatomic, retain) NSArray * promoItems;
@property (nonatomic, retain) NSDictionary * vanityCodes;


@end
