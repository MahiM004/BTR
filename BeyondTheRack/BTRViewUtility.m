//
//  BTRUtility.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-18.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRViewUtility.h"

@interface BTRViewUtility()


@end

@implementation BTRViewUtility


+ (BOOL)isIPAD {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    else
        return NO;
}

+ (UIColor *)BTRBlack {
    return [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];
}

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (void)saveImage:(UIImage *)image withFilename:(NSString *)filename {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:@"AppPics/"];
    BOOL isDir;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        if(!isDir) {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            
        }
    }
    path = [path stringByAppendingPathComponent:filename];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:path atomically:YES];
}

+ (UIImage *)imageWithFilename:(NSString *)filename {
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:@"AppPics"];
    path = [path stringByAppendingPathComponent:filename];
    return [UIImage imageWithContentsOfFile:path];
}



+ (NSAttributedString *)crossedOffPricefromNumber:(NSNumber *)priceNumber {
    NSString *dollaredString = [self priceStringfromNumber:priceNumber];
    UIFont *priceFont = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0];
    NSAttributedString *crossedOffText = [self crossedOffStringfromString:dollaredString withFont:priceFont];
    return crossedOffText;
}


+ (NSAttributedString *)crossedOffStringfromString:(NSString *)string withFont:(UIFont *)font{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSAttributedString *crossedOffText = [[NSAttributedString alloc] initWithString:string
                                                                         attributes:@{
                                                                                      NSStrikethroughStyleAttributeName:
                                                                                          [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                                                                      NSParagraphStyleAttributeName: paragraphStyle,
                                                                                      NSFontAttributeName:font
                                                                                      }];
    return crossedOffText;
}



+ (NSAttributedString *)crossedOffStringfromString:(NSString *)string {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    NSAttributedString *crossedOffText = [[NSAttributedString alloc] initWithString:string
                                                                         attributes:@{
                                                                                      NSStrikethroughStyleAttributeName:
                                                                                          [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                                                                      NSParagraphStyleAttributeName: paragraphStyle,
                                                                                      }];
    return crossedOffText;
}

+ (NSString *)priceStringfromNumber:(NSNumber *)priceNumber {
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *formatted = [currencyStyle stringFromNumber:priceNumber];
    return formatted;
}


+ (NSString *)priceStringfromString:(NSString *)priceString {
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber *amount = [NSNumber numberWithFloat:[priceString floatValue]];
    NSString* formatted = [currencyStyle stringFromNumber:amount];
    
    return formatted;
}


+ (UITextField *)underlineTextField:(UITextField *)textField {
    CGRect layerFrame = CGRectMake(0, 0, textField.frame.size.width, textField.frame.size.height);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    //CGPathAddLineToPoint(path, NULL, layerFrame.size.width, 0); // top line
    CGPathMoveToPoint(path, NULL, 0, layerFrame.size.height);
    CGPathAddLineToPoint(path, NULL, layerFrame.size.width, layerFrame.size.height); // bottom line
    CAShapeLayer * line = [CAShapeLayer layer];
    line.path = path;
    line.lineWidth = 1;
    line.frame = layerFrame;
    line.strokeColor = [UIColor grayColor].CGColor;
    [textField.layer addSublayer:line];
    CFRelease(path);
    
    return textField;
}

+ (NSString *)provinceCodeforName:(NSString *)name {
    if ([name length] < 2)
        return @"";
    NSArray *provinceNamesArray =  @[@"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick",
                                     @"New foundland & Labrador", @"Northwest Territories", @"Nova Scotia",
                                     @"Nunavut", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan", @"Yukon",
                                     @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut",
                                     @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa",
                                     @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan",
                                     @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire",
                                     @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma",
                                     @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee",
                                     @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming",@"Quebec"];
    
    NSArray *provinceCodesArray = @[@"AB", @"BC", @"MB", @"NB", @"NL", @"NS", @"NT", @"NU", @"ON", @"PE", @"QC", @"SK",@"YT",
                                    @"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL",
                                    @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT",
                                    @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI",
                                    @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY", @"QU"];
    return [provinceCodesArray objectAtIndex:[provinceNamesArray indexOfObject:name]];
}

+ (NSString *)provinceNameforCode:(NSString *)code {
    if ([code length] < 2)
        return @"";
    NSArray *provinceNamesArray =  @[@"Alberta", @"British Columbia", @"Manitoba", @"New Brunswick",
                                     @"New foundland & Labrador", @"Northwest Territories", @"Nova Scotia",
                                     @"Nunavut", @"Ontario", @"Prince Edward Island", @"Quebec", @"Saskatchewan", @"Yukon",
                                     @"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut",
                                     @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa",
                                     @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan",
                                     @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire",
                                     @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma",
                                     @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee",
                                     @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming",@"Quebec"];
    
    NSArray *provinceCodesArray = @[@"AB", @"BC", @"MB", @"NB", @"NL", @"NS", @"NT", @"NU", @"ON", @"PE", @"QC", @"SK",@"YT",
                                    @"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL",
                                    @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT",
                                    @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI",
                                    @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY", @"QU" ];
    return [provinceNamesArray objectAtIndex:[provinceCodesArray indexOfObject:code]];
}

+ (NSDictionary *)inquiryTypes {
    NSDictionary* inquiryTypes = [[NSDictionary alloc]initWithObjects:@[@"signin",@"order",@"return",@"product",@"question"] forKeys:@[@"I can't sign in to my account",@"I have a question about a recent order",@"I have a question about a return or refund",@"I need some product information",@"I have a different question or topic"]];
    return inquiryTypes;
}

+ (NSString *)countryCodeforName:(NSString *)name {
    if ([name  isEqualToString:@"USA"])
        return @"us";
    return @"ca";
}

+ (NSString *)countryNameforCode:(NSString *)code {
    if ([[code uppercaseString] isEqualToString:@"US"])
        return @"USA";
    return @"Canada";
}

+ (NSString *)formatDateStringToStringforMonthDayDisplay:(NSString *)someDateString{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate = [dateFormatter dateFromString:someDateString];
    [dateFormatter setDateFormat:@"MMMM d"];
    NSString  *dateString = [dateFormatter stringFromDate:myDate];
    return dateString;
}

+ (NSString *)formatDateStringToStringforYearDisplay:(NSString *)someDateString {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate = [dateFormatter dateFromString:someDateString];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString  *dateString = [dateFormatter stringFromDate:myDate];
    return dateString;
}


+ (UIAlertView*)showAlert:(NSString *)title msg:(NSString *)messege {
    UIAlertView * aa = [[UIAlertView alloc]initWithTitle:title message:messege delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [aa show];
    return aa;
}

@end










