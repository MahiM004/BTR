//
//  BTRUtility.h
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-18.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRUtility : NSObject

+ (UIColor *)BTRBlack;

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (void)saveImage:(UIImage *)image withFilename:(NSString *)filename;
+ (UIImage *)imageWithFilename:(NSString *)filename;


+ (NSAttributedString *)crossedOffTextFrom:(NSString *)someText;

+ (NSDictionary *)getFacetsDictionaryFromResponse:(NSDictionary *)responseDictionary;
+ (NSMutableArray *)getItemDataArrayFromResponse:(NSDictionary *)responseDictionary;
+ (NSMutableArray *)extractFilterFacetsForDisplayFromResponse:(NSDictionary *)facetsDictionary;

+ (NSString *)contentTypeForSearchQuery;

@end
