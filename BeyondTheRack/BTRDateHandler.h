//
//  BTRDateHandler.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-06-16.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRDateHandler : NSObject

+ (NSString *)convertToStringfromDate:(NSDate *)someDate;
+ (NSDate *)convertToDatefromString:(NSString *)dateString;

@end
