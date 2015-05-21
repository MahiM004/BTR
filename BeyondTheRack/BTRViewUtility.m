//
//  BTRUtility.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-18.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRViewUtility.h"

@implementation BTRViewUtility


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
    
    NSString *dollaredString = [NSString stringWithFormat:@"$%@", priceNumber];

    return dollaredString;
}


+ (NSString *)priceStringfromString:(NSString *)priceString {
    
    NSString *dollaredString = [NSString stringWithFormat:@"$%@", priceString];
    
    return dollaredString;
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




@end










