//
//  BagItem.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-13.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BagItem : NSObject

@property (nonatomic, retain) NSString * bagItemId;
@property (nonatomic, retain) NSDate * createDateTime;
@property (nonatomic, retain) NSString * isInStock;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * expiredItem;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSNumber * pricing;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * additionalShipping;
@property (nonatomic, retain) NSString * isEmployee;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * variant;
@property (nonatomic, retain) NSString * expiryDuration;
@property (nonatomic, retain) NSDate * dueDateTime;
@property (nonatomic, retain) NSDate * serverDateTime;


@end
