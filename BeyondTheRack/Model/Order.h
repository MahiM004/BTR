//
//  Order.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-16.
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
@property (nonatomic, retain) NSString * shippingAddressId;
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

@end
