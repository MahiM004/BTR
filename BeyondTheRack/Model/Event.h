//
//  Event.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-27.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * discount;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * saveUpTo;
@property (nonatomic, retain) NSString * shortEventDescription;
@property (nonatomic, retain) NSString * longEventDescription;
@property (nonatomic, retain) NSString * activeEvent;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * importance;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSString * startDateTime;
@property (nonatomic, retain) NSDate * endDateTime;
@property (nonatomic, retain) NSString * categoryList;
@property (nonatomic, retain) NSString * specialNote;
@property (nonatomic, retain) NSString * eventTags;
@property (nonatomic, retain) NSString * itemLimit;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSString * topPerformers;
@property (nonatomic, retain) NSString * outfitFlag;
@property (nonatomic, retain) NSString * isFlatRate;
@property (nonatomic, retain) NSString * isDropShip;
@property (nonatomic, retain) NSString * isWhiteGlove;
@property (nonatomic, retain) NSString * liveUpcoming;
@property (nonatomic, retain) NSString * includeBrandName;
@property (nonatomic, retain) NSString * showMinQtyFlag;
@property (nonatomic, retain) NSString * showMinQtyMinutes;
@property (nonatomic, retain) NSString * poStatus;
@property (nonatomic, retain) NSString * generalAttribute1;
@property (nonatomic, retain) NSString * generalAttribute2;
@property (nonatomic, retain) NSString * generalAttribute3;
@property (nonatomic, retain) NSString * myCategoryName;

@end
