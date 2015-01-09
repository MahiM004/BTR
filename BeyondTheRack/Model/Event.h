//
//  Event.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSDate * expiryDateTime;
@property (nonatomic, retain) NSString * discount;
@property (nonatomic, retain) NSString * saveUpTo;

@end
