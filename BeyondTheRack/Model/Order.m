//
//  Order.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-17.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Order.h"


@implementation Order

-(id) copyWithZone: (NSZone *) zone {
    Order *another = [[Order allocWithZone:zone]init];
    another.allTotalPrice = self.allTotalPrice;
    another.bagTotalPrice = self.bagTotalPrice;
    another.billingAddress = self.billingAddress;
    another.billingName = self.billingName;
    another.billingSameAsShipping = self.billingSameAsShipping;
    another.cardHolderName = self.cardHolderName;
    another.cardNumber = self.cardNumber;
    another.cardType = self.cardType;
    another.ccvNumber = self.ccvNumber;
    another.confirmDateTime = self.confirmDateTime;
    another.confirmed = self.confirmed;
    another.country = self.country;
    another.createDateTime = self.createDateTime;
    another.currency = self.currency;
    another.eligiblePickup = self.eligiblePickup;
    another.expiryDateTime = self.expiryDateTime;
    another.expiryMonth = self.expiryMonth;
    another.expiryYear = self.expiryYear;
    another.forceCardUpdate = self.forceCardUpdate;
    another.isAccepted = self.isAccepted;
    another.isFreeshipAddress = self.isFreeshipAddress;
    another.isGift = self.isGift;
    another.isInterac = self.isInterac;
    another.isMasterpass = self.isMasterpass;
    another.isPaypal = self.isPaypal;
    another.isPickup = self.isPickup;
    another.isVisaMe = self.isVisaMe;
    another.items = self.items;
    another.lockCCFields = self.lockCCFields;
    another.orderId = self.orderId;
    another.orderStatus = self.orderStatus;
    another.orderTotalPrice = self.orderTotalPrice;
    another.paymentType = self.paymentType;
    another.pickupAddress = self.pickupAddress;
    another.pickupTitle = self.pickupTitle;
    another.promoBillingAddress = self.promoBillingAddress;
    another.promoBillingName = self.promoBillingName;
    another.promoItems = self.promoItems;
    another.promoShipName = self.promoShipName;
    another.promoShipPhone = self.promoShipPhone;
    another.promoShippingAddress = self.shippingAddress;
    another.recipientGiftMessage = self.recipientGiftMessage;
    another.rememberCard = self.rememberCard;
    another.requireCcv = self.requireCcv;
    another.shippingAddress = self.shippingAddress;
    another.shippingPrice = self.shippingPrice;
    another.shippingRecipientName = self.shippingRecipientName;
    another.subTotalPrice = self.subTotalPrice;
    another.taxes = self.taxes;
    another.totalTax = self.totalTax;
    another.useToken = self.useToken;
    another.vanityCodes = self.vanityCodes;
    another.vipPickup = self.vipPickup;
    another.vipPickupEligible = self.vipPickupEligible;
    return another;
}

@end
