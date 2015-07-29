//
//  Order.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-17.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Order : NSObject

@property (nonatomic, retain) NSString * confirmDateTime;
@property (nonatomic, retain) NSString * confirmed;
@property (nonatomic, retain) NSString * createDateTime;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * orderStatus;
@property (nonatomic, retain) NSString * shippingAddressLine1;
@property (nonatomic, retain) NSString * shippingAddressLine2;
@property (nonatomic, retain) NSString * shippingCity;
@property (nonatomic, retain) NSString * shippingCountry;
@property (nonatomic, retain) NSString * shippingPhoneNumber;
@property (nonatomic, retain) NSString * shippingPostalCode;
@property (nonatomic, retain) NSString * shippingRecipientName;
@property (nonatomic, retain) NSString * shippingProvince;
@property (nonatomic, retain) NSString * billingSameAsShipping;
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
@property (nonatomic, retain) NSString * bagTotalPrice;
@property (nonatomic, retain) NSString * subTotalPrice;
@property (nonatomic, retain) NSString * allTotalPrice;
@property (nonatomic, retain) NSString * orderTotalPrice;
@property (nonatomic, retain) NSString * gstTax;
@property (nonatomic, retain) NSString * qstTax;
@property (nonatomic, retain) NSString * totalTax;

@end
