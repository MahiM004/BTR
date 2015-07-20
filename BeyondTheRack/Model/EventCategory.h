//
//  EventCategory.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-18.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventCategory : NSObject

@property (nonatomic, retain) NSString * active;
@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryOrder;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sortCriteria;
@property (nonatomic, retain) NSString * sortCriteriaNewSite;

@end
