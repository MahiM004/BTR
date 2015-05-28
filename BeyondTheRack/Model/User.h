//
//  User.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-05-28.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * birthDate;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * cobrandKeyword;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * invitationCode;
@property (nonatomic, retain) NSString * isAddressFilled;
@property (nonatomic, retain) NSString * isEmployee;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * passwordHint;
@property (nonatomic, retain) NSString * personalCode;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * preferencesList;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSString * sessionId;
@property (nonatomic, retain) NSString * maritalStatus;
@property (nonatomic, retain) NSString * children;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * alternateEmail;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * education;
@property (nonatomic, retain) NSString * income;
@property (nonatomic, retain) NSString * favoriteShopping;

@end
