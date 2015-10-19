//
//  Item.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-04-01.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, retain) NSNumber * allReserved;
@property (nonatomic, retain) NSDictionary * attributeDictionary;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * categoryList;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * generalNote;
@property (nonatomic, retain) NSString * imageCount;
@property (nonatomic, retain) NSString * imageNameLarge;
@property (nonatomic, retain) NSString * imageNameMedium;
@property (nonatomic, retain) NSString * imageNameSmall;
@property (nonatomic, retain) NSString * isFragile;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * longItemDescription;
@property (nonatomic, retain) NSString * productHeight;
@property (nonatomic, retain) NSString * productLength;
@property (nonatomic, retain) NSString * productWeight;
@property (nonatomic, retain) NSString * productWidth;
@property (nonatomic, retain) NSString * relatedSkuslist;
@property (nonatomic, retain) NSString * restrictedShipping;
@property (nonatomic, retain) NSDate * saleEndDate;
@property (nonatomic, retain) NSDate * saleStartDate;
@property (nonatomic, retain) NSString * saveUpTo;
@property (nonatomic, retain) NSString * shipTime;
@property (nonatomic, retain) NSString * shortItemDescription;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSString * specialNote;
@property (nonatomic, retain) NSDictionary * variantInventory;
@property (nonatomic, retain) NSString * videoCount;
@property (nonatomic, retain) NSString * videoName;
@property (nonatomic, retain) NSNumber * retailPrice;
@property (nonatomic, retain) NSNumber * employeePrice;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSString * variant;

@property float discount;

@end
