//
//  BTRUtility.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-18.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRViewUtility : NSObject

+ (BOOL)isIPAD;

+ (UIColor *)BTRBlack;
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (void)saveImage:(UIImage *)image withFilename:(NSString *)filename;
+ (UIImage *)imageWithFilename:(NSString *)filename;

+ (NSAttributedString *)crossedOffPricefromNumber:(NSNumber *)priceNumber;
+ (NSString *)priceStringfromNumber:(NSNumber *)priceNumber;
+ (NSString *)priceStringfromString:(NSString *)priceString;
+ (UITextField *)underlineTextField:(UITextField *)textField;

+ (NSAttributedString *)crossedOffStringfromString:(NSString *)string withFont:(UIFont *)font;
+ (NSAttributedString *)crossedOffStringfromString:(NSString *)string;

+ (NSString *)provinceCodeforName:(NSString *)name;
+ (NSString *)provinceNameforCode:(NSString *)code;

+ (NSString *)countryCodeforName:(NSString *)name;
+ (NSString *)countryNameforCode:(NSString *)code;

+ (NSString *)formatDateStringToStringforMonthDayDisplay:(NSString  *)someDate;
+ (NSString *)formatDateStringToStringforYearDisplay:(NSString *)someDate;

+ (NSDictionary *)inquiryTypes;

+ (UIAlertView*)showAlert:(NSString *)title msg:(NSString *)messege;
@end
