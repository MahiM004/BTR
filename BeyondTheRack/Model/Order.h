//
//  Order.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Order : NSManagedObject

@property (nonatomic, retain) NSDate * confirmDateTime;
@property (nonatomic, retain) NSString * confirmed;
@property (nonatomic, retain) NSDate * createDateTime;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * orderStatus;
@property (nonatomic, retain) NSString * paymentDetailsId;
@property (nonatomic, retain) NSString * shippingAddressId;
@property (nonatomic, retain) NSString * totalPrice;
@property (nonatomic, retain) NSString * usernameId;
@property (nonatomic, retain) NSString * orderId;

@end
