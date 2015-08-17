//
//  Contact+AppServer.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-08-14.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "Contact+AppServer.h"

@implementation Contact (AppServer)

+ (Contact *)contactWithAppServerInfo:(NSDictionary *)contactDictionary {
    Contact *newContact = [[Contact alloc]init];
    
    NSMutableArray* header = [[NSMutableArray alloc]init];
    if ([contactDictionary valueForKeyPath:@"0"]  && [[contactDictionary valueForKeyPath:@"0"]valueForKey:@"content"]) {
        NSArray *contentArray = [[contactDictionary valueForKeyPath:@"0"]valueForKey:@"content"];
        for (NSDictionary *content in contentArray) {
            TextSection* section = [[TextSection alloc]init];
            section.title = [content valueForKey:@"subheading"];
            section.content = [[content valueForKey:@"text"]firstObject];
            [header addObject:section];
        }
    }
    newContact.headersArray = [header mutableCopy];
    
    if ([contactDictionary valueForKeyPath:@"LOST_EMAILS"]  && [[contactDictionary valueForKeyPath:@"LOST_EMAILS"]valueForKey:@"text"])
        newContact.lostEmail = [[contactDictionary valueForKey:@"LOST_EMAILS"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"OTHER_METHODS_GUEST"]  && [[contactDictionary valueForKeyPath:@"OTHER_METHODS_GUEST"]valueForKey:@"text"])
        newContact.otherMethodGuest = [[contactDictionary valueForKey:@"OTHER_METHODS_GUEST"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"OTHER_METHODS_HOLIDAY"]  && [[contactDictionary valueForKeyPath:@"OTHER_METHODS_HOLIDAY"]valueForKey:@"text"])
        newContact.otherMethodHolidays = [[contactDictionary valueForKey:@"OTHER_METHODS_HOLIDAY"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"CONTACT_SUPPORT_HOLIDAY"]  && [[contactDictionary valueForKeyPath:@"CONTACT_SUPPORT_HOLIDAY"]valueForKey:@"text"])
        newContact.contactSupportHoliday = [[contactDictionary valueForKey:@"CONTACT_SUPPORT_HOLIDAY"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"OTHER_METHODS_GUEST_HOLIDAY"]  && [[contactDictionary valueForKeyPath:@"OTHER_METHODS_GUEST_HOLIDAY"]valueForKey:@"text"])
        newContact.otherMethodsGuestHoliday = [[contactDictionary valueForKey:@"OTHER_METHODS_GUEST_HOLIDAY"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"INQUIRY"]  && [[contactDictionary valueForKeyPath:@"INQUIRY"]valueForKey:@"text"])
        newContact.inquiry = [[contactDictionary valueForKey:@"INQUIRY"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"INQUIRY_RETURN"]  && [[contactDictionary valueForKeyPath:@"INQUIRY_RETURN"]valueForKey:@"text"])
        newContact.inquiryReturn = [[contactDictionary valueForKey:@"INQUIRY_RETURN"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"INQUIRY_SIGNIN"]  && [[contactDictionary valueForKeyPath:@"INQUIRY_SIGNIN"]valueForKey:@"text"])
        newContact.inquirySignIn = [[contactDictionary valueForKey:@"INQUIRY_SIGNIN"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"INQUIRY_RECENT_ORDER"]  && [[contactDictionary valueForKeyPath:@"INQUIRY_RECENT_ORDER"]valueForKey:@"text"])
        newContact.inquiryRecentOrder = [[contactDictionary valueForKey:@"INQUIRY_RECENT_ORDER"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"INQUIRY_PRODUCT"]  && [[contactDictionary valueForKeyPath:@"INQUIRY_PRODUCT"]valueForKey:@"text"])
        newContact.inquiryProduct = [[contactDictionary valueForKey:@"INQUIRY_PRODUCT"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"INQUIRY_OTHER"]  && [[contactDictionary valueForKeyPath:@"INQUIRY_OTHER"]valueForKey:@"text"])
        newContact.inquiryOther = [[contactDictionary valueForKey:@"INQUIRY_OTHER"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"ORDER_NUMBER"]  && [[contactDictionary valueForKeyPath:@"ORDER_NUMBER"]valueForKey:@"text"])
        newContact.orderNumber = [[contactDictionary valueForKey:@"ORDER_NUMBER"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"PRODUCT"]  && [[contactDictionary valueForKeyPath:@"PRODUCT"]valueForKey:@"text"])
        newContact.product = [[contactDictionary valueForKey:@"PRODUCT"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"IF_APPLICABLE"]  && [[contactDictionary valueForKeyPath:@"IF_APPLICABLE"]valueForKey:@"text"])
        newContact.ifApplicable = [[contactDictionary valueForKey:@"IF_APPLICABLE"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"HELP_DETAILS"]  && [[contactDictionary valueForKeyPath:@"HELP_DETAILS"]valueForKey:@"text"])
        newContact.helpDetails = [[contactDictionary valueForKey:@"HELP_DETAILS"]valueForKey:@"text"];
    
    if ([contactDictionary valueForKeyPath:@"SEND_MESSAGE"]  && [[contactDictionary valueForKeyPath:@"SEND_MESSAGE"]valueForKey:@"text"])
        newContact.sendMessage = [[contactDictionary valueForKey:@"SEND_MESSAGE"]valueForKey:@"text"];
    
    
    return newContact;
}

@end
