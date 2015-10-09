//
//  ConfirmationInfo.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-10-08.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "Item.h"

@interface ConfirmationInfo : NSObject

@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * confirmationNumber;
@property (nonatomic, retain) NSString * billingCardType;
@property (nonatomic, retain) NSString * billingCardLastdigits;
@property (nonatomic, retain) NSString * billingName;
@property (nonatomic, retain) Address * billingAddress;
@property (nonatomic, retain) NSString * shippingName;
@property (nonatomic, retain) Address * shippingAddress;
@property (nonatomic, retain) NSString * orderCurrency;
@property (nonatomic, retain) NSNumber * totalOrderValue;
@property (nonatomic, retain) NSNumber * totalShipping;
@property (nonatomic, retain) NSNumber * totalTax1;
@property (nonatomic, retain) NSNumber * totalTax2;
@property (nonatomic, retain) NSNumber * totalDiscount;
@property (nonatomic, retain) NSNumber * shippingTaxGroup;
@property (nonatomic, retain) NSNumber * orderedCurrencyRate;
@property (nonatomic, retain) NSString * orderNote;
@property (nonatomic, retain) NSNumber * totalCreditApplied;
@property (nonatomic, retain) NSNumber * orderSubtotal;
@property (nonatomic, retain) NSNumber * bagTotal;
@property (nonatomic, retain) NSArray* items;
@property (nonatomic, retain) NSString * labelTax1;
@property (nonatomic, retain) NSString * labelTax2;
@property (nonatomic, retain) NSString * paymentMethod;

@end
