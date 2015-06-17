//
//  Order.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-17.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Order : NSManagedObject

@property (nonatomic, retain) NSDate * confirmDateTime;
@property (nonatomic, retain) NSString * confirmed;
@property (nonatomic, retain) NSDate * createDateTime;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * orderStatus;
@property (nonatomic, retain) NSString * totalPrice;
@property (nonatomic, retain) NSString * shippingAddressLine1;
@property (nonatomic, retain) NSString * shippingAddressLine2;
@property (nonatomic, retain) NSString * shippingCity;
@property (nonatomic, retain) NSString * shippingCountry;
@property (nonatomic, retain) NSString * shippingPhoneNumber;
@property (nonatomic, retain) NSString * shippingPostalCode;
@property (nonatomic, retain) NSString * shippingRecipientName;
@property (nonatomic, retain) NSString * shippingProvince;
@property (nonatomic, retain) NSNumber * billingSameAsShipping;
@property (nonatomic, retain) NSString * billingAddressLine1;
@property (nonatomic, retain) NSString * billingAddressLine2;
@property (nonatomic, retain) NSString * billingCity;
@property (nonatomic, retain) NSString * billingCountry;
@property (nonatomic, retain) NSString * billingPostalCode;
@property (nonatomic, retain) NSString * billingProvince;
@property (nonatomic, retain) NSString * billingPhoneNumber;
@property (nonatomic, retain) NSString * cardHolderName;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, retain) NSString * ccvNumber;
@property (nonatomic, retain) NSString * expiryYear;
@property (nonatomic, retain) NSString * expiryMonth;
@property (nonatomic, retain) NSNumber * eligiblePickup;
@property (nonatomic, retain) NSString * cardToken;
@property (nonatomic, retain) NSString * paymentType;
@property (nonatomic, retain) NSNumber * lockCCFields;
@property (nonatomic, retain) NSNumber * forceCardUpdate;
@property (nonatomic, retain) NSNumber * vipPickupEligible;
@property (nonatomic, retain) NSNumber * vipPickup;
@property (nonatomic, retain) NSString * recipientGiftMessage;
@property (nonatomic, retain) NSNumber * isPickup;
@property (nonatomic, retain) NSNumber * isGift;
@property (nonatomic, retain) NSNumber * isVisaMe;
@property (nonatomic, retain) NSNumber * isPaypal;
@property (nonatomic, retain) NSNumber * isMasterpass;
@property (nonatomic, retain) NSNumber * isInterac;
@property (nonatomic, retain) NSString * subTotalPrice;
@property (nonatomic, retain) NSString * cardNumber;
@property (nonatomic, retain) NSString * useToken;
@property (nonatomic, retain) NSNumber * requireCcv;
@property (nonatomic, retain) NSNumber * rememberCard;
@property (nonatomic, retain) NSNumber * isFreeshipAddress;
@property (nonatomic, retain) NSString * promoBillingState;
@property (nonatomic, retain) NSString * promoBillingPostal;
@property (nonatomic, retain) NSString * promoBillingPhone;
@property (nonatomic, retain) NSString * promoBillingName;
@property (nonatomic, retain) NSString * promoBillingCountry;
@property (nonatomic, retain) NSString * promoBillingCity;
@property (nonatomic, retain) NSString * promoBillingAddress2;
@property (nonatomic, retain) NSString * promoBillingAddress1;
@property (nonatomic, retain) NSString * promoShipState;
@property (nonatomic, retain) NSString * promoShipPostal;
@property (nonatomic, retain) NSString * promoShipName;
@property (nonatomic, retain) NSString * promoShipCountry;
@property (nonatomic, retain) NSString * promoShipCity;
@property (nonatomic, retain) NSString * promoShipAddress2;
@property (nonatomic, retain) NSString * promoShipAddress1;
@property (nonatomic, retain) NSString * billingName;
@property (nonatomic, retain) NSString * promoShipPhone;

@end
