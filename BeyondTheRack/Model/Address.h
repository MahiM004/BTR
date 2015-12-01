//
//  Address.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * addressLine1;
@property (nonatomic,strong) NSString * addressLine2;
@property (nonatomic,strong) NSString * city;
@property (nonatomic,strong) NSString * province;
@property (nonatomic,strong) NSString * country;
@property (nonatomic,strong) NSString * phoneNumber;
@property (nonatomic,strong) NSString * postalCode;

@property BOOL postalCodeValid;
@end
