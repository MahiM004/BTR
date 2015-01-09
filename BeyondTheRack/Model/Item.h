//
//  Item.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * discount;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * saveUpTo;

@end
