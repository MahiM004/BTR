//
//  OrderHistoryBag.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-29.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistoryBag : NSObject

@property (nonatomic, retain) NSString *orderId;
@property (nonatomic, retain) NSString *orderDateString;
@property (nonatomic, retain) NSString *subtotal;
@property (nonatomic, retain) NSString *taxes;
@property (nonatomic, retain) NSString *shipping;
@property (nonatomic, retain) NSString *credits;
@property (nonatomic, retain) NSString *total;

@end
