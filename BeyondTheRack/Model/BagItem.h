//
//  BagItem.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-31.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BagItem : NSManagedObject

@property (nonatomic, retain) NSString * bagItemId;
@property (nonatomic, retain) NSDate * bagItemTimer;
@property (nonatomic, retain) NSString * createDateTime;
@property (nonatomic, retain) NSString * expiryDateTime;
@property (nonatomic, retain) NSString * isInStock;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * orderId;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * selectedSize;
@property (nonatomic, retain) NSString * usernameId;
@property (nonatomic, retain) NSString * retailUnitPrice;
@property (nonatomic, retain) NSString * saleUnitPrice;

@end
