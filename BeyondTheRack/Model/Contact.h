//
//  Contact.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextSection : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@end


@interface Contact : NSObject

@property (nonatomic,strong) NSArray *headersArray;
@property (nonatomic,strong) NSString *lostEmail;
@property (nonatomic,strong) NSString *otherMethodHolidays;
@property (nonatomic,strong) NSString *otherMethodGuest;
@property (nonatomic,strong) NSString *contactSupportHoliday;
@property (nonatomic,strong) NSString *otherMethodsGuestHoliday;
@property (nonatomic,strong) NSString *inquiry;
@property (nonatomic,strong) NSString *inquirySignIn;
@property (nonatomic,strong) NSString *inquiryRecentOrder;
@property (nonatomic,strong) NSString *inquiryReturn;
@property (nonatomic,strong) NSString *inquiryProduct;
@property (nonatomic,strong) NSString *inquiryOther;
@property (nonatomic,strong) NSString *orderNumber;
@property (nonatomic,strong) NSString *product;
@property (nonatomic,strong) NSString *ifApplicable;
@property (nonatomic,strong) NSString *helpDetails;
@property (nonatomic,strong) NSString *sendMessage;

@end
