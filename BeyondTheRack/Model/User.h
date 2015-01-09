//
//  User.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-01-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * usernameId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * familyName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * sessionId;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * isAddressFilled;

@end
