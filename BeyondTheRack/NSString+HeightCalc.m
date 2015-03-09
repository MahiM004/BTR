//
//  NSString+HeightCalc.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2015-03-09.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import "NSString+HeightCalc.h"

@implementation NSString (HeightCalc)

- (CGFloat)heightForWidth:(CGFloat)width usingFont:(UIFont *)font
{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){width, FLT_MAX};
    CGRect r = [self boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    return r.size.height;
}

@end
