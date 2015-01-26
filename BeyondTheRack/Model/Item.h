//
//  Item.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-26.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * discount;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * imageName1;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * saveUpTo;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * shortItemDescription;
@property (nonatomic, retain) NSString * longItemDescription;
@property (nonatomic, retain) NSString * imageCount;
@property (nonatomic, retain) NSString * imageName5;
@property (nonatomic, retain) NSString * imageName6;
@property (nonatomic, retain) NSString * attributeList;
@property (nonatomic, retain) NSString * imageName2;
@property (nonatomic, retain) NSString * imageName3;
@property (nonatomic, retain) NSString * imageName4;
@property (nonatomic, retain) NSString * videoCount;
@property (nonatomic, retain) NSString * videoName2;
@property (nonatomic, retain) NSString * relatedSkuslist;
@property (nonatomic, retain) NSString * categoryList;
@property (nonatomic, retain) NSString * priorityA;
@property (nonatomic, retain) NSString * priorityB;
@property (nonatomic, retain) NSNumber * retailUSD;
@property (nonatomic, retain) NSString * videoName1;
@property (nonatomic, retain) NSNumber * retailCAD;
@property (nonatomic, retain) NSNumber * priceUSD;
@property (nonatomic, retain) NSNumber * priceCAD;
@property (nonatomic, retain) NSNumber * employeePriceUSD;
@property (nonatomic, retain) NSNumber * employeePriceCAD;
@property (nonatomic, retain) NSNumber * clearancePriceUSD;
@property (nonatomic, retain) NSNumber * clearancePriceCAD;
@property (nonatomic, retain) NSString * productType;
@property (nonatomic, retain) NSString * vendorId;
@property (nonatomic, retain) NSString * generalAttribute1;
@property (nonatomic, retain) NSString * generalAttribute2;
@property (nonatomic, retain) NSString * generalAttribute3;
@property (nonatomic, retain) NSString * specialNote;
@property (nonatomic, retain) NSString * generalNote;
@property (nonatomic, retain) NSDate * shipTime;
@property (nonatomic, retain) NSString * dropShip;

@end
