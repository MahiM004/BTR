//
//  Item.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-03.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * attributeList;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * categoryList;
@property (nonatomic, retain) NSNumber * clearancePriceCAD;
@property (nonatomic, retain) NSNumber * clearancePriceUSD;
@property (nonatomic, retain) NSString * discount;
@property (nonatomic, retain) NSString * dropShip;
@property (nonatomic, retain) NSNumber * employeePriceCAD;
@property (nonatomic, retain) NSNumber * employeePriceUSD;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * generalAttribute1;
@property (nonatomic, retain) NSString * generalAttribute2;
@property (nonatomic, retain) NSString * generalAttribute3;
@property (nonatomic, retain) NSString * generalNote;
@property (nonatomic, retain) NSString * imageCount;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * longItemDescription;
@property (nonatomic, retain) NSNumber * priceCAD;
@property (nonatomic, retain) NSNumber * priceUSD;
@property (nonatomic, retain) NSString * priorityA;
@property (nonatomic, retain) NSString * priorityB;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productType;
@property (nonatomic, retain) NSString * relatedSkuslist;
@property (nonatomic, retain) NSNumber * retailCAD;
@property (nonatomic, retain) NSNumber * retailUSD;
@property (nonatomic, retain) NSString * saveUpTo;
@property (nonatomic, retain) NSDate * shipTime;
@property (nonatomic, retain) NSString * shortItemDescription;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * specialNote;
@property (nonatomic, retain) NSString * vendorId;
@property (nonatomic, retain) NSString * videoCount;
@property (nonatomic, retain) NSString * videoName;
@property (nonatomic, retain) NSDate * saleStartDate;
@property (nonatomic, retain) NSDate * saleEndDate;

@end
