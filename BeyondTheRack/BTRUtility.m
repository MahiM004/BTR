//
//  BTRUtility.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-18.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRUtility.h"

@implementation BTRUtility


+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (void)saveImage:(UIImage *)image withFilename:(NSString *)filename
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:@"ProfilePics/"];
    
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

+ (UIImage *)imageWithFilename:(NSString *)filename
{
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [paths[0] stringByAppendingPathComponent:@"ProfilePics"];
    path = [path stringByAppendingPathComponent:filename];
    
    return [UIImage imageWithContentsOfFile:path];
}



+ (NSAttributedString *)crossedOffTextFrom:(NSString *)someText
{
    UIFont *priceFont = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    NSAttributedString *corssedOffText = [[NSAttributedString alloc] initWithString:someText 
                                                                          attributes:@{
                                                                                       NSStrikethroughStyleAttributeName:
                                                                                           [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                                                                       NSParagraphStyleAttributeName: paragraphStyle,
                                                                                       NSFontAttributeName:priceFont
                                                                                       }];
    
    
    return corssedOffText;
}


+ (NSString *)priceRangeForHumanReadableFromRangeString:(NSString *)rangeString andCountString:(NSString *)countString {
    
    NSString *tempString = nil;
    
    // TODO: put these guys in an array
    
    if ([rangeString isEqualToString:@"price_sort_ca:[0 TO 200]"]) {
        
        tempString = [NSString stringWithFormat:@"$0 to $200: (%@)", countString];
    }
    else if ([rangeString isEqualToString:@"price_sort_ca:[200 TO 400]"]) {
     
        tempString = [NSString stringWithFormat:@"$200 to $400: (%@)", countString];
    }
    else if ([rangeString isEqualToString:@"price_sort_ca:[400 TO 600]"]) {
     
        tempString = [NSString stringWithFormat:@"$400 to $600: (%@)", countString];
    
    } else if ([rangeString isEqualToString:@"price_sort_ca:[600 TO 800]"]) {
    
        tempString = [NSString stringWithFormat:@"$600 to $800: (%@)", countString];
    
    } else if ([rangeString isEqualToString:@"price_sort_ca:[800 TO 1000]"]) {
        
        tempString = [NSString stringWithFormat:@"$800 to $1000: (%@)", countString];
        
    } else if ([rangeString isEqualToString:@"price_sort_ca:[1000 TO *]"]) {
    
        tempString = [NSString stringWithFormat:@"$1000 to Unlimited: (%@)", countString];
    }
    
    return tempString;
}


+ (NSString *)priceRangeForAPIReadableFromRangeString:(NSString *)rangeString {
    
    
    
    NSString *tempString = nil;
    
    if ([rangeString isEqualToString:@"price_sort_ca:[0 TO 200]"]) {
        
        tempString = [NSString stringWithFormat:@"$0 to $200"];
    }
    else if ([rangeString isEqualToString:@"price_sort_ca:[200 TO 400]"]) {
        
        tempString = [NSString stringWithFormat:@"$200 to $400"];
    }
    else if ([rangeString isEqualToString:@"price_sort_ca:[400 TO 600]"]) {
        
        tempString = [NSString stringWithFormat:@"$400 to $600"];
        
    } else if ([rangeString isEqualToString:@"price_sort_ca:[600 TO 800]"]) {
        
        tempString = [NSString stringWithFormat:@"$600 to $800"];
        
    } else if ([rangeString isEqualToString:@"price_sort_ca:[800 TO 1000]"]) {
        
        tempString = [NSString stringWithFormat:@"$800 to $1000"];
        
    } else if ([rangeString isEqualToString:@"price_sort_ca:[1000 TO *]"]) {
        
        tempString = [NSString stringWithFormat:@"$1000 to Unlimited"];
    }
    
    return tempString;
    }


@end
















