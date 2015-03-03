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



+ (NSAttributedString *)crossedOffTextFrom:(NSString *)someText {
    
    UIFont *priceFont = [UIFont fontWithName:@"STHeitiSC-Light" size:15.0];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *corssedOffText = [[NSAttributedString alloc] initWithString:someText 
                                                                          attributes:@{
                                                                                       NSStrikethroughStyleAttributeName:
                                                                                           [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                                                                       NSParagraphStyleAttributeName: paragraphStyle,
                                                                                       NSFontAttributeName:priceFont
                                                                                       }];
    
    
    return corssedOffText;
}




@end




