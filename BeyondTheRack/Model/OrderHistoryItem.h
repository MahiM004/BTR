//
//  OrderHistoryItem.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistoryItem : NSObject

@property (nonatomic, retain) NSString *orderHistoryItemId;
@property (nonatomic, retain) NSString *skuNumber;
@property (nonatomic, retain) NSString *orderId;
@property (nonatomic, retain) NSString *shortDescription;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *status;

@end
