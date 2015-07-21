//
//  BTRDateHandler.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "BTRDateHandler.h"

@implementation BTRDateHandler


+ (NSString *)convertToStringfromDate:(NSDate *)someDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // e.g. 2015-08-14 15:36:49
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSString *stringDate = [dateFormatter stringFromDate:someDate];
    
    return stringDate;
}


+ (NSDate *)convertToDatefromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}

@end





















