//
//  BTRUtility.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-18.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "BTRUtility.h"

@implementation BTRUtility


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






+ (NSString *)contentTypeForSearchQuery {
    
    return @"text/html";
}


+ (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary {
    
    return ((NSDictionary *)responseDictionary[@"facet_counts"]);
}

+ (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary {
    
    NSDictionary *tempDic = responseDictionary[@"response"];
    return [tempDic valueForKey:@"docs"];
}


+ (NSMutableArray *) extractFilterFacetsForDisplayFromResponse:(NSDictionary *)facetsDictionary {
    
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    
    NSDictionary *facetQueriesDictionary = facetsDictionary[@"facet_queries"];
    NSDictionary *facetFieldsDictionary =  facetsDictionary[@"facet_fields"];

    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSString *tempString = [NSString stringWithFormat:@"$0 to $200: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[0 TO 200]"] ];
    [tempArray addObject:tempString];
    tempString = [NSString stringWithFormat:@"$200 to $400: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[200 TO 400]"] ];
    [tempArray addObject:tempString];
    tempString = [NSString stringWithFormat:@"$400 to $600: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[400 TO 600]"] ];
    [tempArray addObject:tempString];
    tempString = [NSString stringWithFormat:@"$600 to $800: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[600 TO 800]"] ];
    [tempArray addObject:tempString];
    tempString = [NSString stringWithFormat:@"$800 to $1000: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[800 TO 1000]"] ];
    [tempArray addObject:tempString];
    tempString = [NSString stringWithFormat:@"$1000 to *: (%@)",(NSNumber *)[facetQueriesDictionary valueForKey:@"price_sort_ca:[1000 TO *]"] ];
    [tempArray addObject:tempString];
    
    [resultsArray addObject:tempArray];
    [tempArray removeAllObjects];
    
    
    NSMutableArray *allKeys = [[facetFieldsDictionary allKeys] mutableCopy];

    for (NSString * dicKey in allKeys) {
        
        NSDictionary *tempDic = [facetFieldsDictionary objectForKey:dicKey];
        
        for (NSString *item in tempDic)
            [tempArray addObject:[NSString stringWithFormat:@"%@: (%@)", item, (NSNumber *)tempDic[item]] ];
        
        [tempArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        [resultsArray addObject:tempArray];
        [tempArray removeAllObjects];
    }

    
    return resultsArray;
}



@end
















