//
//  UserNotifications.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserNotifications : NSManagedObject

@property (nonatomic, retain) NSString * childrenDesignerBrands;
@property (nonatomic, retain) NSString * dailyEventStart;
@property (nonatomic, retain) NSString * homeOffice;
@property (nonatomic, retain) NSString * menDesignerBrands;
@property (nonatomic, retain) NSString * usernameId;
@property (nonatomic, retain) NSString * weeklySneakPeaks;
@property (nonatomic, retain) NSString * womenDesignerBrands;
@property (nonatomic, retain) NSString * userNotificationsId;

@end
